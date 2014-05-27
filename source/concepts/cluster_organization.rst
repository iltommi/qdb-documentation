Cluster Organization
====================

.. The design and topology of a cluster.
.. NOT about its data.
.. NOT about its network protocols
.. NOT about its ACID guarantees

.. ### "Cluster Organization" Content Plan
   - Definition of the Cluster (show web bridge?)
   - Definition of a node (show node details from web bridge?)
   - Links between nodes, concepts of predecessor and successor
   - Stabilization, reorganization into a ring (explain what happens for both adding and removing a node)
   - Talk about cluster efficiency and performance
   - The Client(s) - quick overview of what a client is, then refer to Data Transfer
   
What is a Cluster?
------------------

Each server running a :doc:`../reference/qdbd` is called a node. By itself, a node can provide fast key-value storage for a project where a SQL database might be too slow or impose unwanted design limitations.

However, the real power of a quasardb installation comes when multiple nodes are linked together into a cluster. A cluster is a peer-to-peer distributed hash table based on `Chord <http://pdos.csail.mit.edu/chord/>`_. In a cluster, quasardb nodes self-organize to share data and handle client requests, providing a scalable, concurrent, and fault tolerant database.

.. Expand this section using the definitions of nodes, clusters, and links from a Chord perspective


Stabilization
-------------

Stabilization happens when bootstrapping a cluster, in case of failure, or when adding nodes. It is transparent and does not require any intervention.

As nodes are added to a cluster, the cluster automatically *stabilizes* itself. :term:`Stabilization` is the process during which nodes agree on how and where the data should be distributed. The time it takes to stabilize varies depending on the number of nodes and the amount of data to migrate. A cluster is considered stable when all nodes are ordered in the ring by their respective ids.


.. Periodic Stabilization

In most clusters, the time required to stabilize is extremely short and does not result in any modification of order of nodes in the ring. However, if one or several nodes fail or if new nodes join the cluster, stabilization will migrate data and change the neighbors (see :ref:`data-migration`). Thus the stabilization duration depends on the amount of data to migrate, if any.

The interval length between each stabilization can be anywhere between 1 (one) second and 2 (two) minutes.

When the node evaluates its neighbors in the cluster are stable, it will increase the duration between each stabilization check. On the contrary, when its neighbors are deemed *unstable*, the duration between stabilization checks will be reduced.

Adding a Node to a Cluster
--------------------------

.. figure:: qdb_add_node_process/01_qdb_cluster_at_start.png
   :scale: 50%
   
   Four nodes connected in a ring, forming an operational cluster.


.. figure:: qdb_add_node_process/02_qdbd_add_node.png
   :scale: 50%
   
   A fifth node is created and peered to the node at IP address 192.168.1.134. This begins the two-step process of :term:`Stabilization`, where nodes validate their position in the ring, then rearrange how and where data is distributed.
   
   Note that the fifth node assigned itself the unique ID of 4. In a production environment, the IDs are randomized hashes. In the unlikely event that a new node assigns itself an ID that is already taken by another node in the cluster, the new node will abort the join and stabilization process. The cluster remains unchanged.


.. figure:: qdb_add_node_process/03_qdb_peering.png
   :scale: 50%
   
   The fifth node uses the predecessor and successor values of its neighbor nodes to move itself to its appropriate location within the cluster. In this example, it moves until it has a predecessor of 3 and a successor of 0.
   
.. figure:: qdb_add_node_process/04_qdb_data_migration.png
   :scale: 50%
   
   Once the node has a valid predecessor and successor, data is migrated based on the number of nodes and replication factor in order to load balance across the cluster. During this period, some nodes may be unavailable, namely the predecessor, the successor, and the node that was added.
   
   For more information on data migration, see :ref:`data-migration`.

.. figure:: qdb_add_node_process/05_qdb_cluster_at_end.png
   :scale: 50%
   
   Once data migration is complete, stabilization is complete and the finished cluster has five nodes.

.. tip::
    Add nodes when the traffic is at its lowest point.


Removing a Node from a Cluster
------------------------------

Removing nodes does not cause data migration. Removing nodes results in inaccessible entries, unless data replication is in place (see :ref:`data-replication`).


Recovering from Node Failure
----------------------------

If a node fails and replication is disabled, the data the node was responsible for will not be available. If a node fails and replication is enabled, other nodes with duplicate data will respond to client requests. In both cases, the cluster will detect the failure, re-stabilize itself automatically, and remain available.

When a node recovers from failure, it needs to reference a peer within the existing ring to properly rejoin. The first node in a ring generally does not reference any other, thus, if the first node of the ring fails, it needs to be restarted with a reference to a peer within the existing ring.

If following a major network failure, a ring forms two disjointed rings, the two rings will be able to unite again once the underlying failure is resolved. This is because each node "remembers" past topologies.




What is a Client?
-----------------

A client is any piece of software using the quasardb API to create, read, update, or delete data on a quasardb cluster. Clients that are bundled with the quasardb daemon include qdbsh, qdb_httpd, qdb_dbtool, and qdb_comparison. You can also create your own custom clients using the C, Java, or Python API documentation.

Clients communicate to the cluster using the __ framework blah blah blah

.. Expand this section using the definitions of clients from a Chord perspective




Multithreading
--------------

The server is actually organized in a network of mini-daemons that exchange messages. This is done in such a way that it preserves low-latency while increasing parallelism.

Multithreading generally implies locking. Locking has been reduced to the minimum with the use of lock-free structures and transactional memory.

Resource management
-------------------

quasardb is developed in C++11 and assembly with performance in mind.

quasardb uses custom memory allocators that are multithread-friendly. Whenever possible, quasardb allocates memory on the stack rather than on the heap. If a heap allocation cannot be avoided, quasardb's zero-copy architecture makes sure no cycle is wasted duplicating data, unless it causes data contention.

Unstable state
^^^^^^^^^^^^^^

When a node fails, a segment of the ring will become unstable. When a ring's segment is unstable, requests might fail. This happens when:

    1. The requested node's :term:`predecessor` or :term:`successor` is unavailable **and**
    2. The requested node is currently looking for a valid :term:`predecessor` or :term:`successor`

In this context the node choses to answer to the client with an "unstable" error status. The client will then look for another node on the ring able to answer its query. If it fails to do so, the client will return an error to the user.

When a node joins a ring, it is in an unstable state until the join is complete.

That means that although a ring's segment may be unable to serve requests for a short period of time, the rest of the ring remains unaffected.

In a production environment, cluster segments may become unstable for a short period of time after a node fails. This temporary instability does not require human intervention to be resolved. 

.. tip::
    When a cluster's segment is unstable requests *might* temporarily fail. The probability for failure is exponentially correlated with the number of simultaneous failures.

Minimum number of working nodes required
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A cluster can successfully operate with a single node; however, the single node may not be able to handle all the load of the ring by itself. Additionally, managing node failures implies extra work for the nodes. Frequent failures will severely impact performances.

.. tip::
    A cluster operates best when more than 90% of the nodes are fully functional. Anticipate traffic growth and add nodes before the cluster is saturated.


