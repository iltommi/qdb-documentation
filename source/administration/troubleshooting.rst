Troubleshooting
===============

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
    * The persistence layer is sane (ie no hard-disk failure or corrupted database) and not full
    * You have the latest operating system patches
    * If your quasardb version isn't current, you are not experiencing a bug that has been fixed in later release
    * You are not over-capacity (see :doc:`tuning`)

Generally when failure happens repeatedly on the same node this can be a hardware or system-related error. If the failure occurs on a random node within the cluster this can be a network problem or a quasardb bug.

Although quasardb is extremely fast, it's always possible to have a workload larger than the cluster capabilities. That's why an important thing is to make sure that the system isn't over capacity. When the system is over capacity, this can result in denial of service (DoS) on certain nodes in the cluster, manifesting as random failures. 

Bugs
----

Although we do our best to make sure our software is as reliable as possible, bugs are always possible. If you encounter a bug, please contact support (see :doc:`../contact`).