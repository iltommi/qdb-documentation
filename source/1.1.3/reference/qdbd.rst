quasardb daemon
***************

The quasardb daemon is a highly scalable data :term:`repository` that handles requests from multiple clients.  The data is cached in memory and persisted on disk. It can be distributed on several servers to form a :term:`cluster`.

The persistence layer is based on `LevelDB <http://code.google.com/p/leveldb/>`_ (c) LevelDB authors. All rights reserved.
The network distribution uses the `Chord <http://pdos.csail.mit.edu/chord/>`_ protocol.

The quasardb daemon does not require privileges (unless listening on a port under 1024) and can be launched from the command line. From this command line it can safely be stopped with CTRL-C. On UNIX, CTRL-Z will also result in the daemon being suspended.

.. important::
    A valid license is required to run the daemon (see :doc:`../license`). The path to the license file is specified by the :option:`--license-file` option.

Configuration
=============

.. program:: qdbd

Cheat sheet
-----------

 ===================================== ============================ =================== ============ ==============
                Option                               Usage               Default           Global     Req. Version
 ===================================== ============================ =================== ============ ==============
 :option:`-h`                          display help                                         No       
 :option:`-g`, `--gen-config`          generate default config file                         No        >=1.1.3
 :option:`-c`, `--config-file`         specify config file                                  No        >=1.1.3
 :option:`--license-file`              specify license              qdb_license.txt         No       
 :option:`-d`                          daemonize                                            No       
 :option:`-a`                          address to listen on         127.0.0.1:2836          No       
 :option:`-s`                          max client sessions          2000                    No       
 :option:`--partitions`                number of partitions         Variable                No       
 :option:`-r`                          persistence directory        ./db                    Yes      
 :option:`--id`                        set the node id              generated               No       
 :option:`--replication`               sets the replication factor  1                       Yes      
 :option:`--peer`                      one peer to form a cluster                           No       
 :option:`--transient`                 disable persistence                                  Yes      
 :option:`--sync`                      sync every disk write                                Yes      
 :option:`--limiter-max-entries-count` max entries in cache         100000                  Yes      
 :option:`--limiter-max-bytes`         max bytes in cache           Automatic               Yes      
 :option:`--max-depot-size`            max db size on node          0 (disabled)            Yes       >=1.1.3
 :option:`-o`                          log on console                                       No       
 :option:`-l`                          log on given file                                    No       
 :option:`--log-dump`                  dump file location           qdb_error_dump.txt      No       
 :option:`--log-syslog`                log on syslog                                        No       
 :option:`--log-level`                 change log level             info                    No       
 :option:`--log-flush-interval`        change log flush             3                       No       
 ===================================== ============================ =================== ============ ==============

Global and local options
------------------------

When a node connects to a ring, it will first download the configuration of this ring and overwrite its parameters with the ring's parameters.

This way, you can be sure that parameters are consistent over all the nodes. This is especially important for parameters such as replication where you need all nodes to agree on a single replication factor.

This is also important for persistance as having a mix of transient and non-transient nodes will result in undefined behaviour and unwanted data loss.

However, not all options are taken from the ring. It makes sense to have a heterogenous logging threshold for example, as you may want to analyze the behaviour of a specific part of your cluster.

In addition, some parameters are node specific, such as the listening address or the node ID.

An option that applies cluster-wide is said to be *global* whereas other options are said to be *local*. The value of a global option is set by the first node that creates the ring, all other nodes will copy these parameters. On the other hand, local options are read from the command line as you run the daemon.

Network distribution
--------------------

qdbd distribution is peer-to-peer. This means:

    * The unavailability of one :term:`server` does not compromise the whole :term:`cluster`
    * The memory load is automatically distributed amongst all instances within a :term:`cluster`

Each server within one cluster needs:

    * An unique address on which to listen (you cannot use the *any* address) (:option:`-a`)
    * At least one :term:`node` within the cluster to contact (:option:`--peer`)

.. note::
    It's counter-productive to run several instances on the same :term:`node`.
    qdbd is hyper-scalar and will be able to use all the memory and processors of your server.
    The same remark applies for virtual machines: running quasardb multiple times in multiple virtual machines on a single physical server will not increase the performances.

The daemon will automatically launch an appropriate number of threads to handle connection accepts and requests,
depending on the actual hardware configuration of your server.

Replication
-----------

The replication factor (:option:`--replication`) is the number of copies for any given entry within the cluster. Each copy is made on a different node, this implies that a replication factor greater than the number of nodes will be lowered to the actual number of nodes.

The purpose of replication is to increase fault tolerance at the cost of decreased write performance.

For example a cluster of three nodes with a replication factor of four (4) will have an effective replication factor of three (3). If a fourth node is added, effective replication will be increased to four automatically.

By default the replication factor is one (1) which is equivalent to no replication. A replication factor of two (2) means that each entry has got a backup copy. A replication factor of three (3) means that each entry has got two (2) backup copies. The maximum replication factor is four (4).

When adding an entry to a node, the call returns only when the add and all replications have been successful. If a node part or joins the ring, replication and migration occurs automatically as soon as possible.

Replication is a cluster-wide parameter.

Logging
-------

By default, all logging is disabled.

The daemon can log to the console (:option:`-o`), to a file (:option:`-l`) or to the syslog (:option:`--log-syslog`) on Unix.

There are six different log levels: `detailed`, `debug`, `info`, `warning`, `error` and `panic`. You can change the log level (:option:`--log-level`), it defaults to `info`.

You can also change the log flush interval (:option:`--log-flush-interval`), which defaults to three (3) seconds.

Persistence
-----------

.. note::
    Persistence options are global for any given ring.

Data is persisted on disk, by default in a `db` directory under the current working directory. You can change this to any directory you want using the :option:`-r` option. All nodes will use the same directory as this is a global parameter.

.. caution::
    Never operate directly on files in the persistence directory, use the provided tools (see :doc:`qdb_dbtool`). Never save any other file in this directory, it might be deleted or modified by the daemon.

Data persistence on disk is buffered: when an user requests ends, the data may or may not be persisted on the disk yet. Still, the persistence layer guarantees the data is consistent at all time, even in case of hardware or software failure.

Should you need every write to be synced to disk, you can do so with the :option:`--sync` option. Syncing every write do disk negatively impacts performances while slightly increasing reliability.

You can also disable the persistence altogether (:option:`--transient`), making quasardb a pure in-memory :term:`repository`.

.. caution::
    If you disable the persistence, evicted entries are lost.

Partitions
----------

A partition can be seen as a worker thread. The more partitions, the more work can be done in parallel. However if the number of partitions is too high relative to your server capabilities to actually do parallel work, performance will decrease.

quasardb is highly scalable and partitions do not interfere with each other. The daemon's scheduler will assign incoming requests to the partition
with the least workload.

The ideal number of partitions is close to the number of physical cores your server has. By default the daemon chooses the best compromise it can. If this value is not satisfactory, you can use the :option:`--partitions` options to set the value manually.

.. note::
    Unless a performance issue is identified, it is best to let the daemon compute the partition count.

Cache
-----

In order to achieve high performances, the daemon keeps as much data as possible in memory. However, the physical memory available for a node may not suffice.

Therefore, entries are evicted from the cache when the entries count or the size of data in memory exceeds a configurable threshold.
Use :option:`--limiter-max-entries-count` (defaults to 100,000) and :option:`--limiter-max-bytes` (defaults to a half the available physical memory) options to configure these thresholds.

.. note::
    The memory usage (bytes) limit includes the alias and content for each entry, but doesn't include bookkeeping, temporary copies or internal structures. Thus, the daemon memory usage may slightly exceed the specified maximum memory usage.

The quasardb daemon uses a proprietary *fast monte-carlo* eviction heuristic. This algorithm is currently not configurable.

Operating limits
================

Theoretical limits
------------------

**Entry size**
    An :term:`entry` cannot be larger than the amount of virtual memory available on a single :term:`node`. This ranges from several megabytes to several gigabytes depending on the amount of physical memory available on the system. It is recommended to keep entries size well below the amount of available physical memory.

**Key size**
    As it is the case for entries, a key cannot be larger than the amount of virtual memory available on a single :term:`node`.

**Number of nodes in a grid**
    The maximum number of nodes is :math:`2^{63}` (9,223,372,036,854,775,808)

**Number of entries on a single grid**
    The maximum number of entries is :math:`2^{63}` (9,223,372,036,854,775,808)

**Node maximum capacity**
    The node capacity depends on the available disk space on a given node.

**Total amount of data**
    The total amount of data a single :term:`grid` may handle is 16 EiB (that's 18,446,744,073,709,551,616 bytes)

Practical limits
----------------

**Entry size**
    Very small entries (below a hundred bytes) do not offer a very good throughput because the network overhead is larger than the payload. This is a limitation of TCP.
    Very large entries (larger than 10% of the node RAM) impact performance negatively and are probably not optimal to store on a quasardb :term:`cluster` "as is". It is generally recommended to slice very large entries in smaller entries and handle reassembly in the client program.
    If you have a lot of RAM (several gigabytes per :term:`node`) do not be afraid to add large entries to a quasardb :term:`cluster`.
    For optimal performance, it's better if the "hot data" - the data that is frequently acceded - can fit in RAM.

**Simultaneous clients**
    A single instance can serve thousands of clients simultaneously.
    The actual limit is the network bandwidth, not the server.
    You can set the :option:`-s` to a higher number to handle more simultaneous clients per :term:`node`.
    Also you should make sure the clients connects to the nodes of the cluster in a load-balanced fashion.

.. _qdbd-parameters-reference:

Parameters reference
====================

Parameters can be supplied in any order and are prefixed with ``--``.
The arguments format is parameter dependent.

Instance specific parameters only apply to the instance, while global parameters are for the whole ring. Global parameters are applied when the first instance of a ring is launched.

Instance specific
--------------------

.. option:: -h, --help

    Displays basic usage information.

    Example
        To display the online help, type: ::

            qdbd --help

.. option:: -g, --gen-config

    Generates a JSON configuration file with default values and prints it to STDOUT.

    Example
        To create a new config file with the name "qdbd_default_config.json", type: ::

            qdbd --gen-config > qdbd_default_config.json

.. note::
     The --gen-config argument is only available with QuasarDB 1.1.3 or higher.



.. option:: -c, --config-file

    Specifies a configuration file to use. See :ref:`qdbd-config-file-reference`.
    
        * Any other command-line options will be ignored.
        * If an option is omitted in the config file, the default will be used.
        * If an option is malformed in the config file, it will be ignored.
    
    Argument
        The path to a valid configuration file.

    Example
        To use a configuration file named "qdbd_default_config.json", type: ::

            qdbd --config-file=qdbd_default_config.json

.. note::
     The --config-file argument is only available with QuasarDB 1.1.3 or higher.



.. option:: --license-file

    Specifies the location of the license file. A valid license is required to run the daemon (see :doc:`../license`).

    Argument
        The path to a valid license file.

    Default value
        qdb_license.txt

    Example
        Load the license from license.txt::

            qdbd --license-file=license.txt

.. option:: -d, --daemonize

    Runs the server as a daemon (UNIX only). In this mode, the process will fork and prevent console interactions. This is the recommended running mode for UNIX environments.

    Example
        To run as a daemon::

            qdbd -d

.. note::
    Logging to the console is not allowed when running as a daemon.

.. option:: -a <address>:<port>, --address=<address>:<port>

    Specifies the address and port on which the :term:`server` will listen.

    Argument
        A string representing one address the :term:`server` listens on and a port. The address string can be a host name or an IP address.

    Default value
        127.0.0.1:2836, the IPv4 localhost and the port 2836

    Example
        Listen on localhost and the port 5910::

            qdbd --address=localhost:5910

.. note::
    The unspecified address (0.0.0.0 for IPv4, :: for IPv6) is not allowed.

.. option:: -s <count>, --sessions=<count>

    Specifies the number of simultaneous sessions per partition.

    Argument
        A number greater or equal to fifty (50) representing the number of allowed simultaneous sessions.

    Default value
        2,000

    Example
        Allow 10,000 simultaneous session::

            qdbd --sessions=10000

.. note::
    The sessions count determines the number of simultaneous clients the server may handle at any given time.
    Increasing the value increases the memory load. This value may be limited by your license.

.. option:: --partitions=<count>

    Specifies the number of partitions.

    Argument
        A number greater or equal to one (1) representing the number of partitions.

    Default value
        Hardware dependant. Cannot be less than 1.

    Example
        Have 10 partitions::

            qdbd --partitions=10

.. note::
    This value should be changed only in case of performance problems.

.. option:: --idle-duration=<duration>

    Sets the timeout after which inactive sessions will be considered for termination.

    Argument
        An integer representing the number of seconds after which an idle session will be considered for termination.

    Default value
        300 (300 seconds, 5 minutes)

    Example
        Set the timeout to one minute::

            qdbd --idle-duration=60

.. option:: --request-timeout=<timeout>

    Sets the timeout after which a request from the server to another server must be considered to have timed out.

    Argument
        An integer representing the number of seconds after which a request must be considered to have timed out.

    Default value
        60 (60 seconds, 1 minute)

    Example
        Set the timeout to two minutes::

            qdbd --request-timeout=120

.. option:: --id=<id string>

    Sets the node ID.

    Argument
        A string in the form hex-hex-hex-hex, where hex is an hexadecimal number lower than 2^64, representing
        the 256-bit ID to use. This value may not be zero (0-0-0-0).

    Default value
        Unique random value.

    Example
        Set the node ID to 1-a-2-b::

            qdbd --id=1-a-2-b

.. note::
    Having two nodes with the same ID on the ring leads to undefined behaviour. By default the daemon generates
    an ID that is guaranteed to be unique on any given ring. This function's purpose is to modify the topology of
    the ring, should the topology be unsatisfactory.

.. option:: --peer=<address>:<port>

    The address and port of a peer to which to connect within the :term:`cluster`. It can be any :term:`server` belonging to the :term:`cluster`.

    Argument
        The address and port of a machines where a quasardb daemon is running. The address string can be a host name or an IP address.

    Default value
        None

    Example
        Join a :term:`cluster` where the machine 192.168.1.1 listening on the port 2836 is already connected::

            qdbd --peer=192.168.1.1:2836

.. option:: --log-dump

    Specifies the dump file location. The dump file is a text file that is written to when quasardb detects a critical error.

    Argument
        A string representing a path to a dump file.

    Default
        qdb_error_dump.txt

    Example
        Dump to /var/log/qdb_error_dump.log::

            qdb --log-dump=/var/log/qdb_error_dump.log

.. option:: -o, --log-console

    Activates logging on the console.

.. option:: -l <path>, --log-file=<path>

    Activates logging to one or several files.

    Argument
        A string representing one (or several) path(s) to the log file(s).

    Example
        Log in /var/log/qdbd.log: ::

            qdbd --log-file=/var/log/qdbd.log

.. option:: --log-syslog

    *UNIX only*, activates logging to syslog.

.. option:: --log-level=<value>

    Specifies the log verbosity.

    Argument
        A string representing the amount of logging required. Must be one of:

        * `detailed` (most output)
        * `debug`
        * `info`
        * `warning`
        * `error`
        * `panic` (least output)

    Default value
        `info`

    Example
        Request a `debug` level logging::

            qdbd --log-level=debug

.. option:: --log-flush-interval=<delay>

    How frequently log messages are flushed to output, in seconds.

    Argument
        An integer representing the number of seconds between each flush.

    Default value
        3

    Example
        Flush the log every minute::

            qdbd --log-flush-interval=60



Global
----------


.. option:: --replication=<factor>

    Specifies the replication factor (global parameter).

    Argument
        A positive integer between 1 and 4 (inclusive) specifying the replication factor

    Default value
        1 (replication disabled)

    Example
        Have one copy of every entry in the cluster::

            qdbd --replication=2

.. option:: --transient

    Disable persistence. Evicted data is lost when qdbd is :term:`transient`.

.. option:: -r <path>, --root=<path>

    Specifies the directory where data will be persisted for the node where the process has been launched.

    Argument
        A string representing a full path to the directory where data will be persisted.

    Default value
        The "db" subdirectory relative to the current working directory.

    Example
        Persist data in /var/quasardb/db ::

            qdbd --root=/var/quasardb/db

.. note::
    Although this parameter is global, the directory refers to the local node of each instance.

.. option:: --sync

    Sync every disk write. By default, disk writes are buffered. This option disables the buffering and makes sure every write is synced to disk. (global parameter)

.. note::
    This option increases reliability at the cost of performances.


.. option:: --limiter-max-bytes=<value>

   The maximum usable memory by entries, in bytes. Entries will be evicted as needed to enforce this limit. The alias length as well
   as the content size are both accounted to measure the actual size of entries in memory.
   The :term:`server` may use more than the specified amount of memory because of internal data structures and temporary copies. (global parameter)

   Argument
        An integer representing the maximum size, in bytes, of the entries in memory.

   Default value
        0 (automatic, half the available physical memory).

   Example
       To allow only 100 kiB of entries::

            qdbd --limiter-max-bytes=102400

       To allow up to 8 GiB::

            qdbd --limiter-max-bytes=8589934592

.. note::
    Setting this value too high may lead to `thrashing <http://en.wikipedia.org/wiki/Thrashing_%28computer_science%29>`_.


.. option:: --limiter-max-entries-count=<count>

    The maximum number of entries allowed in memory. Entries will be evicted as needed to enforce this limit.

    Argument
        An integer representing the maximum number of entries allowed in memory.

    Default value
        100,000

    Example
        To keep the number of entries in memory below 101::

            qdbd --limiter-max-entries=100

.. note::
    Setting this value too low may cause the :term:`server` to spend more time evicting entries than processing requests.



.. option:: --max-depot-size=<size-in-bytes>

    Sets the maximum amount of disk usage for each node's database in bytes. Any write operations that would overflow the database will return a qdb_e_system error stating "disk full".
    
    Due to excessive meta-data or uncompressed db entries, the actual database size may exceed this set value by up to 20%.
    
    Argument
        An integer representing the maximum size of the database on disk in bytes.
    
    Default value
        0 (disabled)
    
    Example A
        To limit the database size on each node to 12 Terabytes:
        
        .. math::
            
            \text{Max Depot Size Value} &= \text{12 Terabytes} \: * \: \frac{1024^4 \: \text{Bytes}}{\text{1 Terabyte}}\\
                                        &= \text{13194139533312 Bytes}
        
        And thus the command: ::
        
            qdbd --max-depot-size=13194139533312
        
        This database may expand out to approximately 14.4 Terabytes due to meta-data and uncompressed db entries.
            
    Example B
        This example will limit the database size to ensure it fits within 1 Terabyte of free space. Since limiting to a specific overhead is important in this example, the filesystem cluster size is also taken into account; the default for most filesystems is 4096 bytes.
        
        .. math::
            
            \text{Max Depot Size Value} &= \text{1099511627776 Bytes} - \text{(1099511627776 Bytes} \: * \: 0.2 \text{)} - \text{Cluster Size of 4096} \\
                                        &= \text{1099511627776 Bytes} - \text{219902325555.2 Bytes} - \text{4096 Bytes} \\
                                        &= \text{879609298124.8 Bytes}
        
        And thus the command, truncating down to an integer: ::
        
            qdbd --max-depot-size=879609298124
        
        This database should not exceed 1 Terabyte.
    
.. note::
     The --max-depot-size argument is only available with QuasarDB 1.1.2 or higher.

.. note::
     Using a max depot size may cause a slight performance penalty on writes.


.. _qdbd-config-file-reference:

Config File Reference
=====================

As of QuasarDB version 1.1.3, the qdbd daemon can read its parameters from a JSON configuration file provided by the :option:`-c` command-line argument. Using a configuration file is recommended.

Some things to note when working with a configuration file:

 * If a configuration file is specified, all other command-line options will be ignored. Only values from the configuration file will be used.
 * The configuration file must be valid JSON in ASCII format.
 * If a key or value is missing from the configuration file or malformed, the default value will be used.
 * If a key or value is unknown, it will be ignored.

The default configuration file is shown below::

    {
       "global":
       {
           "depot":
           {
               "max_bytes": 0,
               "replication_factor": 2,
               "root": "db",
               "sync": false,
               "transient": false
           },
           "limiter":
           {
               "max_bytes": 0,
               "max_in_entries_count": 100000
           }
       },
       "local":
        {
            "chord":
            {
                "bootstrapping_peers": [  ],
                "no_stabilization": false,
                "node_id": "0-0-0-0"
            },
            "logger":
            {
                "dump_file": "qdb_error_dump.txt",
                "flush_interval": 3,
                "log_files": ["/var/log/qdbd.log"],
                "log_level": 2,
                "log_to_console": false,
                "log_to_syslog": false
            },
            "network":
            {
                "client_timeout": 60,
                "idle_timeout": 600,
                "listen_on": "192.168.1.1:2836",
                "partitions_count": 10,
                "server_sessions": 2000
            },
            "user":
            {
                "daemon": false,
                "license_file": "qdb_license.txt"
            }
        }
    }

.. describe:: global::depot::max_bytes

    An integer representing the maximum amount of disk usage for each node's database in bytes. Any write operations that would overflow the database will return a qdb_e_system error stating "disk full".
    
    Due to excessive meta-data or uncompressed db entries, the actual database size may exceed this set value by up to 20%.
    
    See :option:`--max-depot-size` for more details and examples to calculate the max_bytes value.

.. describe:: global::depot::replication_factor

    An integer between 1 and 4 (inclusive) specifying the replication factor for the cluster. A higher value indicates more copies of data on each node.

.. describe:: global::depot::root

    A string representing the relative or absolute path to the directory where data will be stored.

.. describe:: global::depot::sync

    A boolean representing whether or not the node should sync to the underlying filesystem for each write command.

.. describe:: global::depot::transient

    A boolean representing whether or not to persist data on the hard drive. If true, all data will be stored in memory.

.. describe:: global::limiter::max_bytes

    An integer representing the maximum number of bytes that can be allocated for a single entry.

.. describe:: global::limiter::max_in_entries_count

    An integer representing the maximum number of entries that can be stored in the cluster.
    
.. describe:: local::chord::bootstrapping_peers

    An array of strings representing other nodes in the cluster which will bootstrap this node upon startup. The string can be a host name or an IP address. Must have name or IP separated from port with a colon.

.. describe:: local::chord::no_stabilization

    A boolean value representing whether or not this node should stabilize upon startup. **Contact a QuasarDB representative before editing this value.**

.. describe:: local::chord::node_id

    A string in the form hex-hex-hex-hex, where hex is an hexadecimal number lower than 2^64, representing the 256-bit ID to use. If left at the default of 0-0-0-0, the daemon will assign a random node ID at startup.

.. describe:: local::logger::dump_file

    A string representing the relative or absolute path to the system error dump file.

.. describe:: local::logger::flush_interval

    An integer representing how frequently quasardb log messages should be flushed to the log locations, in seconds.

.. describe:: local::logger::log_files

    An array of strings representing the relative or absolute paths to the quasardb log files.
    
.. describe:: local::logger::log_level

    An integer representing the verbosity of the log output. Acceptable values are::
    
        0 = detailed (most output)
        1 = debug
        2 = info (default)
        3 = warning
        4 = error
        5 = panic (least output)
    
.. describe:: local::logger::log_to_console

    A boolean value representing whether or not the quasardb daemon should log to the console it was spawned from.

.. describe:: local::logger::log_to_syslog

    A boolean value representing whether or not the quasardb daemon should log to the syslog.

.. describe:: local::network::client_timeout

    An integer representing the number of seconds after which a client session will be considered for termination.

.. describe:: local::network::idle_timeout

    An integer representing the number of seconds after which an inactive session will be considered for termination.

.. describe:: local::network::listen_on

    A string representing an address and port the web server should listen on. The string can be a host name or an IP address. Must have name or IP separated from port with a colon.

.. describe:: local::network::partitions_count

    An integer representing the number of partitions, or worker threads, quasardb can spawn to perform operations. The ideal number of partitions is close to the number of physical cores your server has. If left to its default value of 0, the daemon will choose the best compromise it can.

.. describe:: local::network::server_sessions

    An integer representing the number of server sessions the quasardb daemon can provide.

.. describe:: local::user::daemon

    A boolean value representing whether or not the quasardb daemon should daemonize on launch.

.. describe:: local::user::license_file

    A string representing the relative or absolute path to the license file.
