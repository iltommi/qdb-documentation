quasardb configuration generator
********************************

.. highlight:: js

Introduction
============

The quasardb configuration generator, confgen, can provide configuration files for your entire cluster at once.

It is available from the following locations:
  * On the quasardb website at https://confgen.quasardb.net/

If a single hostname or IP address is given, the configuration generator produces a single configuration file. If multiple hostnames or IP addresses are given, the configuration generator produces multiple configuration files in a .zip archive.

Configuration Options
=====================

About the Hardware
^^^^^^^^^^^^^^^^^^

This section configures the hardware parameters for the cluster. If the node hardware is not identical, enter values that are suitable for the least powerful node in the cluster.

.. option:: Available RAM
    
    Sets the maximum amount of RAM available to quasardb. Once this value is reached, the quasardb daemon will evict entries from memory to ensure it stays below the limit. See **global::limiter::max_bytes** in the qdbd :ref:`qdbd-config-file-reference`.

.. option:: Disk Allocation
    
    Sets the maximum amount of hard disk space available to quasardb. Any write operations that would overflow the database will return a qdb_e_system error stating “disk full”. See **global::depot::max_bytes** in the qdbd :ref:`qdbd-config-file-reference`.

.. option:: Number of Cores
    
    Sets the number of partitions quasardb should use during operation. See **local::network::partitions_count** in the qdbd :ref:`qdbd-config-file-reference`.

About the Machines
^^^^^^^^^^^^^^^^^^

.. option:: Hostname / IP
    
    Sets the Hostname or IP address for nodes in the cluster. If generating configuration files for multiple nodes at once, click the "Click here to add another machine" link below the Hostname/IP field. All added Hostnames / IPs will receive a custom config file with their listen address and bootstrapping peers preconfigured.
    
    See **local::chord::bootstrapping_peers** and `local::network::listen_on` in the qdbd :ref:`qdbd-config-file-reference`.
    
.. option:: Replication Factor
    
    Sets the amount of times each entry should be replicated on another node. See :ref:`data-replication` and **global::depot::replication_factor** in the qdbd :ref:`qdbd-config-file-reference`.
    
.. option:: Low Level Synchronized Disk Writes
    
    Sets whether the daemon should sync all writes to the underlying disk filesystem. Provides extra reliability at a small performance cost. See **global::depot::sync** in the qdbd :ref:`qdbd-config-file-reference`.

.. option:: Data Persistence
    
    Sets whether the database should store memory in RAM or store it on disk. Data is stored on disk by default. Only enable this if you are sure you do not want data persisted to disk. See **global::depot::transient** in the qdbd :ref:`qdbd-config-file-reference`.

.. option:: Log Level
    
    Sets the log level for the quasardb daemon. See **local::logger::log_level** in the qdbd :ref:`qdbd-config-file-reference`.

.. option:: Allowed Simultaneous Connections
    
    Sets the number of simultaneous connections the quasardb daemon can service. See **local::network::server_sessions** in the qdbd :ref:`qdbd-config-file-reference`.

