Performance tuning
==================

Measuring performance
---------------------

The best way to test the performance of your cluster is to use the :doc:`../reference/qdb_bench`. It comes with a wide range of test scenarii and it understands quasardb, memchached, and redis protocols.


Rules of thumb
--------------

    * Pageins - If you see a lot of pageins, it means you should allocate more physical memory to the daemon (see :doc:`../reference/qdbd`).
    * Physical memory usage - If physical memory usage is too high (the node swaps), you will need to either reduce the memory usage of the daemon, add more memory to the node or add more nodes to the cluster.
    * Disk usage - If the disk is full, the quasardb node will refuse to serve requests resulting in failures and performance drop. The disk may be full for two reasons:
        * The database takes up too much space: either clean up the database, increase disk space or add more nodes to your cluster. Also ensure that your users don't "forget" to remove entries.
        * The log files take too much space: clean up the log and archive them on a different node.
    * CPU usage - If your cpu usage is too high, you will need to add more nodes to your cluster.
    * Network I/O - If your network bandwidth is saturated on one or several nodes, you will need to add more nodes to your cluster.

Recommendations
---------------

    * The more RAM the better. For small clusters, it's less expensive to add RAM to every node than to add new nodes.
    * Homogenous node configurations make it easier to diagnose performance issues.
    * A quasardb cluster can be very network intensive. Make sure you have the network infrastructure the handle the load.
    * Don't be afraid to add nodes. It's simple and safe.

