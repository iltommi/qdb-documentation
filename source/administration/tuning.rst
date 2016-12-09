Performance tuning
==================

Testing cluster connectivity
----------------------------

The most frequent cause of failure is the improprer configuration of the operating system which prevents quasardb from opening enough sockets.

The qdb_max_conn command line tool available in the tools package will tell you exactly how much connections can be opened to a quasardb cluster.

For example, to test how many connections you can open to a cluster listening on 192.168.1.1:2836::

    qdb_max_conn qdb://192.168.1.1:2836

If you cannot generate at least 1,000 connections you have a serious operating system configuration. A properly configured quasardb cluster should easily handle tens of thousands of connections.

Measuring performance
---------------------

The best way to test the performance of your cluster is to use our open source benchmarking tool (see :doc:`../reference/qdb_bench`).


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

OS X Recommendations
--------------------

 #. Run ``ulimit -n`` as a regular user. If the value is less than 65000, you should update the values. For example, to set it to 65535::

         sudo launchctl limit maxfiles 65535 65535

Linux Recommendations
----------------------

 #. Disable system swappiness in ``/etc/sysctl.conf`` (requires reboot)::

         vm.swappiness=0

    For kernel version 3.5 and over, as well as Red Hat kernel version 2.6.32-303::

         vm.swappiness=1

 #. (Alternatively) You can use sysctl to disable system swappiness without rebooting::

        sysctl -w vm.swappiness=0

    For kernel version 3.5 and over, as well as Red Hat kernel version 2.6.32-303::

        sysctl -w vm.swappiness=1

 #. Disable Transparent Huge Pages by adding the following to ``/etc/rc.local``::

         if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
           echo never > /sys/kernel/mm/transparent_hugepage/enabled
         fi

         if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
            echo never > /sys/kernel/mm/transparent_hugepage/defrag
         fi

 #. If using a Gigabit Ethernet connection, edit ``/etc/sysctl.conf`` and set the following values::

         net.core.somaxconn=8192
         net.ipv4.tcp_max_syn_backlog=8192
         net.core.rmem_max=16777216
         net.core.wmem_max=16777216

 #. (Optional) If running Linux 3.11 or later, you can benefit from busy polling::

        sysctl.net.core.busy_read=50
        sysctl.net.core.busy_poll=50

 #. Run ``ulimit -n`` as a regular user. If the value is less than 65000, add the following line to ``/etc/security/limits.conf``::

         qdb    soft    nofile    65536
         qdb    hard    nofile    65536

 #. We recommend storing quasardb on a dedicated EXT4 partition with the following parameters:

        * ``delalloc``: Delayed allocation. This is normally the default.
        * ``data=ordered``: Data is written before metadata is updated, preventing inconsistencies. This is normally the default.
        * ``discard``: Enables `Trim <https://en.wikipedia.org/wiki/Trim_(computing)>`_ for SSD drives. Use only for SSD. Ensure the driver of your SSD supports this correctly. This is not enabled by default.

    The partition should be mounted with the following parameters:

        * ``async``: important for SSD lifetime as I/O will be asynchronous.
        * ``noatime``: quasardb doesn't need access time information

    It is paramount to check that partition alignment is ideal for the drive you are using. Modern partition tools do that automatically but improper
    alignment can destroy performances.

