Operations
==========

Monitoring
-----------

Monitoring can be done through the administration console. The administration console requires to deploy a web bridge per node (see :doc:`../reference/qdb_httpd`). Once this is done, you connect to the administration console via a HTML5 capable web browser.

It is also possible to get the status in JSON format through a RESTful API.

Last but not least, thanks to the Python API it is possible to write your own monitoring scripts without any need for a web bridge (see :doc:`../api/python`).

The important things to monitor are:

    * Memory usage
    * Disk usage
    * Node failures

Graceful shutdown
------------------

On UNIX, a node can be gracefully stopped in sending the QUIT signal to the daemon. On Windows, hitting CTRL-C in the console will also imply a graceful shutdown.

Logs
----

Each daemon can log to the console, to one or several files and to the syslog (if available) (see :doc:`../reference/qdbd`). Logging is asynchronous, however, in case of a severe failure such as a memory access violation, a synchronous dump to a file of the state of the program is done before any attempt of recovery is done.

By default, logging is disabled. In production environment, it is recommended to log to a file at least with an "information" log level. 

Generally speaking, when the application logs to the dump file, this means a severe bug has been encountered and you should report the problem to quasardb support with the corresponding dump file (see :doc:`../contact`).

Database
--------

The database should be stored in a dedicated partition. The path to the database is configurable (see :doc:`../reference/qdbd`). Tasks such a repair, dump and backup can be done offline with a provided tool (see :doc:`../reference/qdb_dbtool`). It is currently not possible to backup a node that is up. 

The database is designed in such a way that even in case of failure data loss is limited. Nevertheless, it is strongly advised to store the database on RAID 1 or RAID 5 partitions to minimize the impact of hardware failures.

Expanding the cluster
---------------------

Expanding the cluster can be done at any time by adding a node with another node within the system as peer (see :doc:`../reference/qdbd`). For safety reasons, it is however best to do it when the traffic is low.

Upgrade
-------

We strongly recommend to have your quasardb cluster upgraded by a Bureau 14 consultant.



