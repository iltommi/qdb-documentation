Operations
==========

Monitoring
-----------

There are three ways to monitor the health and activity of your QuasarDB cluster:

 1. Through the HTML5 web interface provided by qdb_httpd. See :doc:`../reference/qdb_httpd`.
 2. Through the JSON and JSONP interfaces provided by qdb_httpd's RESTful API. See :ref:`qdb_httpd-url-reference`.
 3. Writing your own monitoring programs via the language API. See :doc:`../api/index`.

The HTML5 web interface is recommended for most users. It offers both cluster-wide and node specific views of entries, storage operations, as well as disk, memory, and CPU usage.

If using the JSON/JSONP output from qdb_httpd or writing your own monitoring program, the most important statistics to monitor are:

    * Memory usage
    * Disk usage
    * Node failures

.. _shutdown:

Graceful shutdown
------------------

On UNIX, a node can be gracefully stopped in sending the QUIT signal to the daemon. On Windows, hitting CTRL-C in the console will also imply a graceful shutdown. Nodes can also be shut down by issuing the stop_node command using qdbsh or a client built on the quasardb API.

Log and Dump Files
------------------

Log files are created only when a quasardb daemon has been run with the -o (log to console), -l (log to file), or --log-syslog (log to syslog) arguments. If logging is enabled, it is performed asynchronously based on the --log-flush-interval argument, which defaults to 3 seconds.

In a production environment, it is recommended to log to a file at least with an "information" log level. For more detailed information on quasardb logging options, see :doc:`../reference/qdbd`.

Dump files are created in case of a severe failure, such as a memory access violation. At the time of the failure, qdbd will create a synchronous dump of the qdbd daemon state before attempting to recover. Because dump files may represent a severe bug in quasardb, you are encouraged to report any problems to quasardb support along with a copy of the corresponding dump file (see :doc:`../contact`).

Log and Dump files are often very large and should be rotated, archived, or deleted regularly. The quasardb daemon does not keep log and dump files open, so they may be rotated while the quasardb daemon is running.

.. _operations-db-storage:

Database Storage
----------------

In a production environment, the database should always be stored on its own, dedicated partition. The quasardb daemon should be provided the path to the database partition with the --root= command-line argument (see :doc:`../reference/qdbd`).

Enabling data replication of 2 or higher is sufficient to protect against disk failure and subsequent data loss. Production environments should always use data replication if possible. RAID 1 and RAID 5 disk configurations are recommended but not required, as they may minimize the amount of downtime for your administration team.

The amount of hard drive space required for a quasardb database on a given node depends on the number of nodes, the replication factor of the cluster, and the amount of data you expect to maintain across the entire cluster. Specifically, the formula is:

.. math::
    
    \text{Space Required Per Node} = \tfrac{(\text{Total Size of Data in Cluster} \: * \: 3 \: * \: \text{Replication Factor})} {\text{Number of Nodes}}

For example, if you are storing 8 Terabytes of data across 4 nodes with a Replication Factor of 2...

.. math::
    
    \text{Space Required Per Node} &= \tfrac{(\text{8 Terabytes} \: * \: 3 \: * \: \text{Replication Factor of 2})} {\text{4 Nodes}} \\
                                   &= \text{12 Terabytes}


If you are using quasardb 1.1.2 or higher, you may also use the --max-depot-size= command-line argument to forcefully limit the database size at a small performance cost. If enabled, write operations that would overflow the node will return with a qdb_e_system error. However, when using --max-depot-size= you will also need to have a safeguard of 20% more disk space, should meta-data or uncompressed values overflow the setting.

Therefore, when using --max-depot-size and the example above, calculating the Space Required per Node requires one more step:

.. math::
    
    \text{Space Required Per Node} &= \text{12 Terabytes} \: + \: (\text{12 Terabytes} * 0.2) \\
                                   &= \text{12 Terabytes} \: + \: (\text{2.4 Terabytes}) \\
                                   &= \text{14.4 Terabytes}


For more information on --max-depot-size=, see :doc:`../reference/qdbd`.
                                   
Repair, dump, or backup operations on a node's database should be done while the quasardb daemon is stopped, using qdb_dbtool (see :doc:`../reference/qdb_dbtool`). It is currently not possible to backup a database while the quasardb daemon is running.

Expanding the cluster
---------------------

Expanding the cluster can be done at any time by adding a node with another node within the system as peer (see :doc:`../reference/qdbd`). For safety reasons, however, it is best to do so when cluster traffic is low.

Upgrade
-------

We strongly recommend to have your quasardb cluster upgraded by a Bureau 14 consultant.



