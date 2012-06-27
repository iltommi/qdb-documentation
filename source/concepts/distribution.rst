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
        The failure of one node does not compromise the hive
 
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

    * Make sure the neighbours are still up and running
    * A new node isn't a best neighbourg that the existing ones

In a sane, stable cluster, stabilization is extremely short and does not result in any modification. However, if one or several node fail or new nodes join the hive, stabilization will migrate keys and adjust the neighourgh information.

Thus the stabilization time depends on the amount of data to migrate, if any. wrpme is as fast as the underlying architecture permits at migrating data.

The duration between each stabilization is between 1 (one) second and 20 (twenty) seconds.

When the node evaluates its surrounding to be stable, it will increase the duration between each stabilization. On the contrary, when the surrounding are deemed *unstable* this duration will be reduced.

.. tip::
    Stabilization happens when bootstraping a hive, in case of failure or when adding nodes. It is transparent and does not require any intervention.

Usage
=====================================================

Building a hive
----------------

To build a hive, nodes are added to each other. A node only needs to know one other node within the ring (see :doc:`../tutorials/one_ring`). It is paramount to make sure that rings are not disjoint, that is, that all nodes will eventually join the same large ring. 

The most simple way to ensure this is to make all nodes initially join the same node. This will not create a single point of failure as once the ring is stabilized, the nodes will properly reference each other.

Connecting to a hive
------------------------

A client may connect to any node within the hive. It will automatically discover the nodes as needed.

.. _fault-tolerance:

Fault tolerance
=====================================================

Data loss
--------------

wrpme is designed to be extremly resilient. All failures are temporary, assuming the underlying cause of failure can be fixed (power failure, hardware fault, driver bug, operating system fault, etc.). 

However, there is one case where data may be lost:

    1. A node fails **and**
    2. Data is not replicated **and**
    3. The data is not persisted to disk 

The persistence layer is able to recover from write failures, which means that one write error will not compromise all the data on a node. It is also possible to make sure write are synced to disks (see :doc:`../reference/wrpmed`). 

Data persistence enables a node to fully recover from a failure and should be considered for production environments. Its impact on performance is neglible for *read-mostly* hives.

Unstable state
-----------------

When a node fails, a segment of the ring will become unstable. When a ring's segment is unstable, requests may fail. This happens when:

    1. The requested node's :term:`predecessor` or :term:`successor` is unavailable **and**
    2. The requested node is currently looking for a valid :term:`predecessor` or :term:`successor`

In this context the node choses to answer to the client with an "unstable" error status. The client will then look for another node on the ring able to answer its query. If it fails to do so, the client will return an error to the user.

When a node joins a ring, it is in an unstable state until the join is complete.

That means that although a ring's segment may be unable to serve requests for a short period of time, the rest of the ring remains unaffected.

In a production environement, hive segments may become unstable for a short period (in the order of minutes, generally in less than one minute) of time after a node fails. This unstability is temporary and does not require human intervention to be resolved. 

.. tip::
    To sum up, when a hive's segment is unstable request *may* temporarly fail. The probability for failure is correlated with the number of simultaneous failures.

Minimum number of working nodes required
-------------------------------------------

A hive can successfully operate with a single node, however, the single node may not be able to handle all the load of the ring by itself. Additionally, managing nodes failures implies extra work for the nodes. Frequent failures will severely impact performances.

.. tip::
    A hive operates best when more than 90% of the nodes are fully functional.




