Cluster Organization
====================

.. ### "Cluster Organization" Content Plan
   - Definition of the Cluster (show web bridge?)
   - Definition of a node (show node details from web bridge?)
   - Links between nodes, concepts of predecessor and successor
   - Stabilization, reorganization into a ring (explain what happens for both adding and removing a node)
   - Talk about cluster efficiency and performance
   - The Client(s) - quick overview of what a client is, then refer to Data Transfer
   
What is a Cluster?
------------------

A cluster is one or more nodes that communicate with each other to share and serve data. A node is any computer running qdbd, the quasardb daemon.

.. Expand this section using the definitions of nodes, clusters, and links from a Chord perspective


Adding a Node to a Cluster
--------------------------

.. figure:: qdb_add_node_process/01_qdb_cluster_at_start.png
   :scale: 50%
   
   Four nodes connected in a ring, forming an operational cluster.


.. figure:: qdb_add_node_process/02_qdbd_add_node.png
   :scale: 50%
   
   A fifth node is created and peered to the node at IP address 192.168.1.134. This begins the process of stabilization.


.. figure:: qdb_add_node_process/03_qdb_id_assignment.png
   :scale: 50%
   
   The fifth node receives a unique ID from the cluster, in this example, 4. In a production environment, the IDs will be randomized hashes and a node may be given an ID anywhere in the ring rather than at the end.
   
   In the unlikely event that a new node is assigned an ID that has already been assigned to another node in the cluster, the new node will abort the join process. The cluster will remain unchanged.


.. figure:: qdb_add_node_process/04_qdb_data_migration.png
   :scale: 50%
   
   The fifth node uses the predecessor and successor values of its neighbor nodes to move itself to its appropriate location within the cluster. In this example, it moves until it has a predecessor of 3 and a successor of 0. Then, the data is migrated based on the number of nodes and replication factor, in order to load balance across the cluster. During this period data is still accessible but the cluster may have degraded performance.


.. figure:: qdb_add_node_process/05_qdb_cluster_at_end.png
   :scale: 50%
   
   Once the data migration is complete, stabilization is complete and the finished cluster has five nodes.
