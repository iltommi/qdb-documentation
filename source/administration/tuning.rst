Performance tuning
==================

Generalities
------------

Recommandations
---------------

When to add nodes
-----------------

A quasardb cluster requires little maintenance, however the following should be monitored:

    * Pageins - If you see a lot of pageins, it means you should allocate more physical memory to the daemon 
    * Physical memory usage - If physical memory usage is too high (the node swaps), you will need to either reduce the memory usage of the daemon, add more memory to the node or add more nodes to the cluster
    * Disk usage - If the disk is full, the quasardb node will refuse to serve requests. The disk may be full for two reasons:
        * The database takes too much space: either clean up the database, increase disk space or add more nodes to your cluster. Also ensure that your users don't "forget" to remove entries.
        * The log files take too much space: clean up the log and archive them on a different node.
    * CPU usage - If your cpu usage is too high, you will need to add more nodes to your cluster.
    * Network I/O - If you network bandwidth is saturated on one or several nodes, you will need to add more nodes to your cluster.

Generally speaking, maintaining a quasardb cluster is all about detecting when the cluster should be expanded and making sure all nodes function properly (no hardware or operating system failure). 