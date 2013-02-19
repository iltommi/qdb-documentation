Installation
============

Platform specific instructions
------------------------------

FreeBSD
^^^^^^^^^^^^^^^^

The server comes as a gzipped tar archive. All needed libraries are included. FreeBSD 9 and libc++ v1 are required as quasardb.

To install libc++ v1, the most straightforward is to install the sources and clang 3.2 (from the ports for example), and then do the following::

    cd /usr/src/lib/libcxxrt
    make
    make install
    cd ../libc++
    make CXX=clang++
    make install

Once you have this setup, quasardb runs out of the box.

Linux
^^^^^^^^^^^^^^^^

All required libraries are included in gzipped tar archive. You will need the libc version 2.5 or later to run quasardb.

Windows
^^^^^^^^^^^^^^^^

Windows XP SP3 or later is required to run quasardb. The setup program ensures all required libraries are installed. There is one setup program for Windows x86 and Windows x64, the setup will install the appropriate version.

Important defaults to know
---------------------------

    * By default, replication is disabled.
    * By default, the quasardb daemon does not log anything.
    * By default, the quasardb daemon listens on the port 2836 on the local address.
    * By default, the quasardb web bridge does not log anything.
    * By default, the quasardb web bridge listens on the port 8080 on the local address.

Running quasardb
-----------------

The daemon
^^^^^^^^^^^^

The heart of quasardb is the daemon (see :doc:`../reference/qdbd`) whose executable name is "qdbd" . This executable does not require any privilege to function. Starting up quasardb is merely a matter of running the daemon.

By default, logging is disabled. It is advised to, at least, log to a file. The daemon does not keep a lock on the logging file, enabling you to rotate log files as you see fit.

Only one daemon should be run by node. Running several daemons on the same node will negatively impact performances.

The web bridge
^^^^^^^^^^^^^^^^

The web bridge (see :doc:`../reference/qdb_httpd`) - whose executable name is "qdb_httpd" - enables you to remotely monitor the node via HTTP requests and access the monitoring console.

One web bridge  should be run by daemon. The web bridge does not need to run on the same node than the daemon, however, a bridge can only be bound to one daemon at the time.

The shell
^^^^^^^^^^

A shell (see :doc:`../reference/qdb_httpd`) - whose executable name is "qdbsh" - is provided. 

The shell enables you to run commands on a cluster. You can connect the shell to any node within the cluster to run commands on the whole cluster.

Stopping quasardb
------------------

The daemon can be stopped in hitting CTRL-C when it is running in the foreground or sending a stop signal if it's running in the background. For a cluster to be stopped, all the nodes within the cluster have to be stopped.

Building a cluster
------------------

A cluster is built organically. Each node is added as needed. All that is needed is to supply the node with the address of a node already in the cluster: a peer (see :doc:`../reference/qdbd`). If a parameter conflicts with a parameter of the cluster (for example, the replication factor), the cluster's parameter takes precedence. If the differences can not be reonciliated with certainty, the new node will exit itself.

As you add a node, the cluster enters a phase known as stabilization. During this phase the nodes agree on the workload to share and some nodes might refuse to serve requests and return instead the "unstable" error message. Those errors are transient. Depending on the use case, the client may try again or drop the request.

It is strongly advised to have an homogenous hardware configuration within a cluster.

Maintainning a cluster
-----------------------

A quasardb cluster requires little maintenance, however the following should be monitored:

    * Pageins - If you see a lot of pageins, it means you should allocate more physical memory to the daemon 
    * Physical memory usage - If physical memory usage is too high (the node swaps), you will need to either reduce the memory usage of the daemon, add more memory to the node or add more nodes to the cluster
    * Disk usage - If the disk is full, the quasardb node will refuse to serve requests. The disk may be full for two reasons:
        * The database takes too much space: either clean up the database, increase disk space or add more nodes to your cluster. Also ensure that your users don't "forget" to remove entries.
        * The log files take too much space: clean up the log and archive them on a different node.
    * CPU usage - If your cpu usage is too high, you will need to add more nodes to your cluster.
    * Network I/O - If you network bandwidth is saturated on one or several nodes, you will need to add more nodes to your cluster.

Generally speaking, maintaining a quasardb cluster is all about detecting when the cluster should be expanded and making sure all nodes function properly (no hardware or operating system failure). 



