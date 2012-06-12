Distribution
**************************************************

Features
=====================================================

A wrpme hive is a peer-to-peer distributed hash table based on `Chord <http://pdos.csail.mit.edu/chord/>`_. It has the following features:

 * Distributed load - The load is fairly and automatically distributed amongst the nodes of the hive
 * Automatic configuration - Nodes organize themselves and exchange data as needed
 * Fault tolerance - The failure of one node does not compromise the hive
 * Transparent topology - A client queries the hive from any node without any concern for performance


Principles
=====================================================

Nodes
-----------

To be properly operated a ring needs to be stable (see :ref:`fault-tolerance`:).

A ring is stable when each node is connected to the proper :term:`successor` and :term:`predecessor`, that is, when all nodes are ordered by their respective ids. That is why each node requires an unique id that may either be automatically generated or given by the user (see :doc:`../reference/wrpmed`).

If a node detects that its id is already in use, it will part the ring.


Each node periodically checks the validity of its :term:`successor` and :term:`predecessor` and will adjust if necessary. This process is called "stabilization".

Entries
---------

Each entry is assigned an unique ID. This unique ID is computed using the `SHA-3 <http://en.wikipedia.org/wiki/Skein_(hash_function)>`_ algorithm. 

The entry is then placed on the node whose ID is the :term:`successor` of the entry's ID. If replication is in place, the entry will also be placed on the successor's successor.

When a client queries the hive, it locates the node who is the successor of the entry and queries that node.


Usage
=====================================================

Building a hive
----------------

To build a hive, nodes are added to each other. A node only needs to know one other node within the ring (see :doc:`../tutorials/one_ring`). What is paramount is to make sure that rings are not disjoint, that is, all nodes will eventually join the same large ring. 

The most simple way to ensure this is to make all nodes initially join the same node. This will not create a single point of failure as once the ring is stabilized, the nodes will properly reference each other.

Connecting to a hive
------------------------

A client may connect to any node within the hive. It will progressively discover the rest of the ring as queries are made.

.. _fault-tolerance:

Fault tolerance
=====================================================

Data loss
--------------

Data may be lost if:

    1. A node fails AND
    2. Data is not replicated AND
    3. The data has not been persisted to disk or the persistence failed

The number 3 item probability of occurence can be reduced via a combination of options in the daemon (see :doc:`../reference/wrpmed`) and the usage of redundant disks.

The persistence layer is able to recover from write failures, which means that one write error will not compromise all the data on a node.

That means that outside this case all failures are temporary, assuming the underlying cause of failure can be fixed (power failure, hardware fault, driver bug, operating system fault, etc.).

Unstable state
-----------------

When a node fails, a segment of the ring will become unstable. When a ring's segment is unstable, requests may fail. This happens when:

    1. The requested node's :term:`predecessor` or :term:`successor` is unavailable AND
    2. The requested node is currently looking for a valid :term:`predecessor` or :term:`successor`

In this context the node choses to answer to the client with an "unstable" error status. The client will then look for another node on the ring able to answer its query. If it fails to do so, the client will return an error to the user.

When a node joins a ring, it is in an unstable state until the join is complete.

That means that although a ring's segment may be unable to serve requests for a short period of time, the rest of the ring remains unaffected.

Minimum number of working nodes required
-------------------------------------------

A hive can successfully operate with a single node, however, the single node may not be able to handle all the load of the ring by itself. Additionally, managing nodes failures implies extra work for the nodes. Frequent failures will severely impact performances.

.. tip::
    A hive operates best when more than 90% of the nodes are fully functional.




