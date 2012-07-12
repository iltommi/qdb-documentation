Distribution
**************************************************

Features
=====================================================

A wrpme hive is a peer-to-peer distributed hash table based on `Chord <http://pdos.csail.mit.edu/chord/>`_. It has the following features:

    Distributed load
        The load is fairly and automatically distributed amongst the nodes of the hive
 
    Automatic configuration
        Nodes organize themselves and exchange data as needed

    Fault tolerance
        The failure of one or several nodes does not compromise the hive
 
    Transparent topology
        A client queries the hive from any node without any concern for performance


Principles
=====================================================

Nodes
-----------

To be properly operated a ring needs to be stable (see :ref:`fault-tolerance`).

A ring is stable when each node is connected to the proper :term:`successor` and :term:`predecessor`, that is, when all nodes are ordered by their respective ids. Each node requires an unique id that may either be automatically generated or given by the user (see :doc:`../reference/wrpmed`).

If a node detects that its id is already in use, it will part the ring.

Each node periodically checks the validity of its :term:`successor` and :term:`predecessor` and will adjust them if necessary. This process is called :term:`stabilization`.

Entries
---------

Each entry is assigned an unique ID. This unique ID is a `SHA-3 <http://en.wikipedia.org/wiki/Skein_(hash_function)>`_ of the alias. 

The entry is then placed on the node whose ID is the :term:`successor` of the entry's ID. If replication is in place, the entry will also be placed on the successor's successor.

When a client queries the hive, it locates the node who is the successor of the entry and queries that node.

Stabilization
---------------

Each node periodically "stabilizes" itself. 

Stabilizing means a node will exchange information with its neighbourgs in order to:

    * Make sure the neighbors (the :term:`successor` and the :term:`predecessor`) are still up and running
    * A new node isn't a best :term:`successor` that the existing one

In a sane, stable cluster, stabilization is extremely short and does not result in any modification. However, if one or several node fail or new nodes join the hive, stabilization will migrate keys and change the neighbors (see :ref:`data-migration`).

Thus the stabilization duration depends on the amount of data to migrate, if any. Migrating data is done as fast as the underlying architecture permits.

The duration between each stabilization is between 1 (one) second and 20 (twenty) seconds.

When the node evaluates its surrounding to be stable, it will increase the duration between each stabilization. On the contrary, when the surrounding are deemed *unstable* this duration will be reduced.

.. tip::
    Stabilization happens when bootstrapping a hive, in case of failure or when adding nodes. It is transparent and does not require any intervention.

.. _data-migration:

Data migration
----------------

When a new node joins the ring, it may imply data migration. Data migration occurs if the new node is the successor of keys already bound to another node. Data migration occurs regardless of replication as it makes sure entries are always bound to the correct node.

The protocol for data migration is the following:

    1. N joins the ring by looking for its successor M
    2. N stabilizes itself, informing its successor and predecessor of its existence
    3. When N has got both predecessor M and successor O, N request its successor M for the range ]O, N] of keys
    4. M sends the requested keys, one by one. 

It has to be noted that, without replication, between steps 2 and 4 the entries in the range ]O, N] may not be available. This is a temporary failure that resolves itself automatically.

If there is a large amount of entries to migrate, this may negatively impact performances. Migration speed therefore depends on the available network bandwidth.

.. tip::
    Add nodes when the trafic is at its lowest point.

Usage
=====================================================

Building a hive
----------------

To build a hive, nodes are added to each other. A node only needs to know one other node within the ring (see :doc:`../tutorials/one_ring`). It is paramount to make sure that rings are not disjoint, that is, that all nodes will eventually join the same large ring. 

The simplest way to ensure this is to make all nodes initially join the same node. This will not create a single point of failure as once the ring is stabilized the nodes will properly reference each other.

Connecting to a hive
------------------------

A client may connect to any node within the hive. It will automatically discover the nodes as needed.

Recovering a node
--------------------

When a node recovers from failure, it needs to reference a peer within the need to properly rejoin. The first node in a ring generally does not reference any other, thus, if the first node of the ring fails, it needs to be restarted with a different command line.

.. _fault-tolerance:

Fault tolerance
=====================================================

Data loss
--------------

wrpme is designed to be extremely resilient. All failures are temporary, assuming the underlying cause of failure can be fixed (power failure, hardware fault, driver bug, operating system fault, etc.). 

However, there is one case where data may be lost:

    1. A node fails **and**
    2. Data is not replicated **and**
    3. The data was not persisted to disk **or** storage failed

The persistence layer is able to recover from write failures, which means that one write error will not compromise everything. It is also possible to make sure writes are synced to disks (see :doc:`../reference/wrpmed`) to increase reliability further. 

Data persistence enables a node to fully recover from a failure and should be considered for production environments. Its impact on performance is negligible for *read-mostly* hives.

Unstable state
-----------------

When a node fails, a segment of the ring will become unstable. When a ring's segment is unstable, requests might fail. This happens when:

    1. The requested node's :term:`predecessor` or :term:`successor` is unavailable **and**
    2. The requested node is currently looking for a valid :term:`predecessor` or :term:`successor`

In this context the node choses to answer to the client with an "unstable" error status. The client will then look for another node on the ring able to answer its query. If it fails to do so, the client will return an error to the user.

When a node joins a ring, it is in an unstable state until the join is complete.

That means that although a ring's segment may be unable to serve requests for a short period of time, the rest of the ring remains unaffected.

In a production environment, hive segments may become unstable for a short period of time after a node fails. This temporary instability does not require human intervention to be resolved. 

.. tip::
    When a hive's segment is unstable requests *might* temporarily fail. The probability for failure is exponentially correlated with the number of simultaneous failures.

Minimum number of working nodes required
-------------------------------------------

A hive can successfully operate with a single node; however, the single node may not be able to handle all the load of the ring by itself. Additionally, managing nodes failures implies extra work for the nodes. Frequent failures will severely impact performances.

.. tip::
    A hive operates best when more than 90% of the nodes are fully functional. Anticipate traffic growth and add nodes before the hive is saturated.




