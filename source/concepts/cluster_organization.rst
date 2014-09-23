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


.. _stabilization:

Stabilization
-------------

Stabilization is the process during which nodes agree on their position in the cluster. Stabilization happens when bootstrapping a cluster, in case of failure, or when adding nodes. It is transparent and does not require any intervention. A cluster is considered stable when all nodes are ordered in the ring by their respective ids.

In most clusters, the time required to stabilize is extremely short and does not result in any modification of order of nodes in the ring. However, if one or several nodes fail or if new nodes join the cluster, stabilization also redistributes the data between the nodes (see :ref:`data-migration`). Thus the stabilization duration can vary depending on the amount of data to migrate, if any.

Nodes periodically verify their location in the cluster to determine if the cluster is stable. This interval can vary anywhere from 1 second up to 2 minutes. When a node determines the cluster is stable, it will increase the duration between each stabilization check. On the contrary, when the cluster is determined to be unstable, the duration between stabilization checks is reduced.


Adding a Node to a Cluster
--------------------------

.. figure:: qdb_add_node_process/01_qdb_cluster_at_start.png
   :scale: 50%
   
   Four nodes connected in a ring, forming an operational cluster.


.. figure:: qdb_add_node_process/02_qdbd_add_node.png
   :scale: 50%
   
   A fifth node is created and peered to the node at IP address 192.168.1.134. The fifth node connects, then downloads the configuration of the cluster, overwriting its global parameters with the cluster's global parameters. This ensures that global parameters are consistent across the cluster, which is important for options like replication and persistence, where disparate parameters between nodes could cause unwanted behavior or data loss.
   
   Once the node has received and applied the global parameters, the cluster begins the two-step process of :term:`Stabilization`, where nodes validate their position in the ring, then rearrange how and where data is distributed.
   
   Note that in this example, the fifth node assigned itself the unique ID of 4. In a production environment, the IDs are randomized hashes. In the unlikely event that a new node assigns itself an ID that is already taken by another node in the cluster, the new node will abort the join and stabilization process. The cluster remains unchanged.


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

When a node is removed through a clean shutdown, it informs the other nodes in the ring on shutdown. The other nodes will immediately re-stabilize the cluster. If data replication is disabled, the entries stored on the node are effectively removed from the database. If data replication is enabled, the nodes with the duplicate data will serve client requests.

When a node is removed due to a node failure, the cluster will detect the failure during the next periodic stabilization check. At that point the other nodes will automatically re-stabilize the cluster. If data replication is disabled, the entries stored on the node are effectively removed from the database. If data replication is enabled, the nodes with the duplicate data will serve client requests.

Entries are not migrated when a node leaves the cluster, only when a node enters the cluster.


Recovering from Node Failure
----------------------------

When a node recovers from failure, it needs to reference a node within the ring to rejoin the cluster. The configuration for the first node in a ring generally does not reference other nodes, thus, if the first node of the ring fails, you may need to adjust its configuration file to refer to an operational node.

If following a major network failure, a cluster forms two disjointed rings, the two rings will be able to unite again once the underlying failure is resolved. This is because each node "remembers" past topologies.

The detection and re-stabilization process surrounding node failures can add a lot of extra work to the affected nodes. Frequent failures will severely impact node performance.

.. tip::
    A cluster operates best when more than 90% of the nodes are fully functional. Anticipate traffic growth and add nodes before the cluster is saturated.


What is a Client?
-----------------

A client is any piece of software using the quasardb API to create, read, update, or delete data on a quasardb cluster. Clients that are bundled with the quasardb daemon include qdbsh, qdb_httpd, qdb_dbtool, and qdb_comparison. You can also create your own custom clients using the C, C++, Java, Python, or .NET APIs.

.. Expand this section using the definitions of clients from a Chord perspective

.. Probably need to refer to data_transfer.rst, as a good chunk of being a client is data transfer.




.. Move these two subsections to Primer? QDBD?

Multithreading
--------------

The server is actually organized in a network of mini-daemons that exchange messages. This is done in such a way that it preserves low-latency while increasing parallelism.

Multithreading generally implies locking. Locking has been reduced to the minimum with the use of lock-free structures and transactional memory.

Resource management
-------------------

quasardb is developed in C++11 and assembly with performance in mind.

quasardb uses custom memory allocators that are multithread-friendly. Whenever possible, quasardb allocates memory on the stack rather than on the heap. If a heap allocation cannot be avoided, quasardb's zero-copy architecture makes sure no cycle is wasted duplicating data, unless it causes data contention.
