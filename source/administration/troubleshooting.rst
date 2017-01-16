Troubleshooting
===============

Excessive transactions conflicts
--------------------------------

Excessive transactions conflicts may be caused by nodes being not properly time synchronized. When a node joins a cluster it will attempt to evaluate its time difference with other nodes and log a warning if it is found to be too important (For more information: :doc:`../concepts/transactions`).

Performance drop
----------------

Performance drops can be caused by:

    * Node failures -- If you lost nodes (network issues, hardware failure, maintenance...) the remaining nodes will have more load to handle which may result in a performance drop. Make sure all nodes are accounted for when you have a severe performance drop.
    * Usage increase -- If the usage increase, there is a point where performance will drop. This becomes a tuning problem (see :doc:`tuning`).
    * Node over capacity -- By (lack of) chance, it is possible that most user request end up on the same node. If which case you can either add a node a reconfigure several nodes to have ids that will produce a better load balance.

Failures
--------

If you are experiencing a failure, make sure that:

    * You are running quasardb on an ECC-memory server
    * The persistence layer is sane (ie no hard-disk failure or corrupted database)
    * You have the latest operating system patches
    * If your quasardb version isn't current, you are not experiencing a bug that has been fixed in later release
    * You are not over-capacity (see :doc:`tuning`)
    * The hard disk is not full (see :ref:`troubleshooting-disk-full`, :ref:`operations-db-storage`, and :doc:`tuning`.)

Generally when failure happens repeatedly on the same node this can be a hardware or system-related error. If the failure occurs on a random node within the cluster this can be a network problem or a quasardb bug.

Although quasardb is extremely fast, it's always possible to have a workload larger than the cluster capabilities. That's why an important thing is to make sure that the system isn't over capacity. When the system is over capacity, this can result in denial of service (DoS) on certain nodes in the cluster, manifesting as random failures.

.. _troubleshooting-disk-full:

Disk Full
---------

For versions of quasardb prior to 1.1.2, when a disk on a node becomes full, quasardb will act in accordance with the host operating system. This may include crashes or other undefined behaviour due to write errors.

As of version 1.1.2, when a disk on a node becomes full, quasardb will attempt to enter a read-only mode. All write operations to that node will return with a qdb_e_system error stating "disk full".

In either case, other nodes should continue to function normally. However, if the problem is quasardb database size, other nodes are also likely to be at or nearing capacity. New nodes can be added to lower the db filesize per node, but if most nodes are near capacity, a full audit of your data storage requirements is in order.

To resolve a single node at disk capacity, shut the quasardb server down normally and audit the node. Once sufficient file system space has been cleared, restart the quasardb server and it should rejoin the network again in read-write mode.

You may also want to enable the global :option:`qdbd --max-depot-size` parameter for your cluster, which will limit the size of the quasardb database. For more information, see :doc:`../reference/qdbd`.




Bugs
----

Although we do our best to make sure our software is as reliable as possible, bugs are always possible. If you encounter a bug, :doc:`please contact support </contact>`.