Installation
============

Hardware requirements
---------------------

    * An IA32 or AMD64 platform
    * End-to-end ECC memory (motherboard, CPU and memory)
    * At least 1 GiB of RAM (the exact amount depends on your use case)
    * At least 10 GiB of disk space. Calculate your disk requirements using the equation at :ref:`operations-db-storage`.
    * 1 Gbit ethernet port
    
It is strongly advised to have a homogenous hardware configuration within a cluster.

Platform specific instructions
------------------------------

FreeBSD
^^^^^^^^^^^^^^^^

The server comes as a gzipped tar archive. All needed libraries are included. FreeBSD 10 and libc++ v1 are required as of quasardb 1.1.5.

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

By default, quasardb listens to the localhost on the 2836 port. On Windows this may be the IPv6 localhost if IPv6 is installed. This can be confusing during tests. Specifying an explicit address, such as "127.0.0.1:2836", is recommended.

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

.. note::
    On UNIXes it is advised to use the `--daemonize` switch to run the server in the background.

By default, logging is disabled. It is advised to - at the very least - log to a file. The daemon does not keep a lock on the logging file, enabling you to rotate log files as you see fit.

Data is by default persisted to a directory named "db" relative to the run directory. You can change this directory or simply disable persistence altogether.

Only one daemon should be run by node. Running several daemons on the same node will negatively impact performances.

The web bridge
^^^^^^^^^^^^^^^^

The web bridge (see :doc:`../reference/qdb_httpd`) - whose executable name is "qdb_httpd" - allows you to remotely monitor the cluster via HTTP requests and access the monitoring console.

.. note::
    On UNIXes it is advised to use the `--daemonize` switch to run the server in the background.

The web bridge does not need to run on the same node as the daemon. Simply point it at a running node in the cluster. Multiple web bridges can be installed and run simultaneously for redundancy, but only one web bridge is needed to monitor the entire cluster.

The shell
^^^^^^^^^^

A shell (see :doc:`../reference/qdb_httpd`) - whose executable name is "qdbsh" - is provided. 

The shell enables you to run commands on a cluster. The shell can connect to any node within the cluster to run commands.

Stopping quasardb
------------------

The daemon can be stopped in hitting CTRL-C when it is running in the foreground or sending a stop signal if it's running in the background. For a cluster to be stopped, all the nodes within the cluster have to be stopped.

Any node can also be remotely stopped with the shell thanks to the "node_stop" command (see :doc:`../reference/qdb_shell`).

Building a cluster
------------------

A cluster is built organically. Each node is added as needed. All that is needed is to supply the node with the address of a node already in the cluster: a peer (see :doc:`../reference/qdbd`). If a parameter conflicts with a parameter of the cluster (for example, the replication factor), the cluster's parameter takes precedence. If the differences cannot be reconciled with certainty, the new node will exit itself.

As you add a node, the cluster enters a phase known as stabilization. During this phase the nodes agree on the workload to share. During this phase some nodes might refuse to serve requests and return instead the "unstable" error message. Those errors are temporary. Depending on the use case, the client should try again or drop the request.


