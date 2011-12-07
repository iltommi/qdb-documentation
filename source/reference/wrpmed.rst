wrpme daemon
****************

Introduction
============

The wrpme daemon is a data repository that handles local and distant requests from multiple clients. The data is stored in memory and persisted on disk.

The wrpme daemon is highly scalable and can be distributed on several nodes to form a :term:`cluster` .

The persistence layer is based on `LevelDB <http://code.google.com/p/leveldb/>`_ (c) LevelDB authors. All rights reserved.

Network configuration
=====================

Basic configuration
-------------------

By default wrpmed listens on all available IPv4 interfaces and on the port 5909. This can be changed at runtime, see :ref:`wrpmed-parameters-reference`

Distribution
------------

wrpmed distribution is peer-to-peer. This means:

 * Adding a server does not require any modification on the client and can be done without service interruption (hot plug'n'play)
 * The unavailability of one :term:`server` does not compromise the whole :term:`ring`
 * The memory load is distributed amongst all instances within a ring without any user intervention

Each server within one ring needs:

 * An unique address on which to listen (you cannot use the *any* address)
 * At least one node within the ring to contact

Assuming you have two machines (192.168.1.1 and 192.168.1.2), to build a ring of two instances, you would do the following:

On the machine 192.168.1.1::

    ./wrpmed -a 192.168.1.1:5909

On a machine 192.168.1.2::

    ./wrpmed -a 192.168.1.2:5909 --peer=192.168.1.2:5909

.. note::

    It's counter-productive to run several instances on the same :term:`node`.
    wrpmed is hyper-scalar and will be able to use all the memory and processors of your server.

Logging
=======

The daemon can log to the console, to a file or to the syslog (on Unix).

By default, all logging is disabled. To enable logging, see :ref:`wrpmed-parameters-reference`

Eviction
========

The daemon is able to handle more data than the amount of physical memory available on a single node. To do so, it must evict entries no longer acceded from memory.

Thresholds
----------

Eviction happens when the entries count or the size of data in memory exceeds a configurable threshold. The eviction algorithm will elect an entry, and this entry will be removed from memory.

If the entry is acceded in a future time, it will be loaded from disk and made available.

Two thresholds currently exist:

 #. A maximum entries count
 #. A maximum memory usage. This memory usage includes the alias and content for each entry, but doesn't include bookkeeping, temporary copies or internal structures. Thus, the daemon memory usage may exceed the specified maximum memory usage.

Eviction occurs when any of the thresholds is reached. For example if you have a maximum number of entries set to 10 and a maximum size set to 1 MiB, eviction will happen when you add the eleventh entry or if you exceed 1 MiB of memory usage for all the entries.

It can be configured with runtime parameters, see :ref:`wrpmed-parameters-reference`

Algorithm
---------

The wrpme daemon uses a proprietary *fast monte-carlo* eviction heuristic. It is currently not configurable.

An entry is elected for eviction based on an unspecified number of parameters which change over the lifetime of the cluster.

Persistence
===========

Foreword
--------

As with most mechanisms within the wrpme daemon, persistence is asynchronous. That means that when an user request ends, the data may or may not be persisted on the disk. It will be persisted when it's optimal from a performance point of view no latter than the configurable flush interval.

Data is however guaranteed to be consistent at all time and the persistence layers possesses recovery mechanisms in case of hardware or software fault.

You need to keep in mind that very few engines offer the guarantee that data is physically persisted on disk upon request, and those who do, do it at extremely high performance costs.

Purpose
-------

What is the purpose of persistence for an in-memory data repository?

 #. Recoverability. In case of hardware or software failure, the engine is able to resume its state without any user intervention.
 #. Performance. Less frequently acceded entries are removed from the RAM and left on the disk, reserving RAM usage for the most frequently acceded entries.
 #. Practicably. The server can manage more data than the available physical memory would permit.

Location
--------

By default data is persisted in the directory from which the daemon is run. The data location can be changed with the :option:`-r` parameter.

Disabling persistence
---------------------

Persistence can be disabled in specifying a zero flush interval as such: :option:`--flush-interval`

In this mode the wrpme daemon is said to be :term:`transient`. Evicted entries are not persisted but lost. A transient daemon is potentially faster and may use less memory.

Operating limits
================

Theoretical limits
------------------

Entry size
    An entry cannot be larger than the amount of virtual memory available on a single node. This ranges from several megabytes to several gigabytes depending on the amount of physical memory available on the system. It is recommended to keep entries' size well below the amount of available physical memory.

Memory per instance
    Each instance is limited by the amount of memory the operating system is able to handle

Key size
    A key cannot be larger than 4 KiB

Number of nodes in a grid
    The maximum number of nodes is 8 EiB

Number of entries on a single grid
    The maximum number of entries is 8 EiB

Total amount of data
    The total amount of data a single grid may handle is 16 EiB (that's 18,446,744,073,709,551,616 bytes)

Practical limits
----------------

Entry size
^^^^^^^^^^

Very small entries (below 512 bytes) do not offer a very good throughput because the network overhead is larger than the payload.

Large entries (entries larger than 10% of the node RAM) impact performance negatively and are probably not optimal to store on a wrpme cluster "as is". It is generally recommended to slice large entries in smaller entries and handle reassembly in the client program.

If you have a lot of RAM (several gigabytes per node) do not be afraid to add large entries to a wrpme cluster! Every wrpme build is tested with entries up to 200 MiB.

Entry count
-----------

There is no practical limits to the number of entries you can add to a wrpme instance. For optimal performance, it's better if the "hot data" - the data that is frequently acceded - can fit in RAM.

Simultaneous clients
--------------------

Our tests routinely demonstrate that a single instance can serve more than a thousands clients simultaneously. The actual limit is the network bandwidth, not the server.

Performances
============

This part of the documentation is currently being redacted. We apologize for the inconvenience.

.. _wrpmed-parameters-reference:

Parameters reference
====================

Parameters can be supplied in any order and are prefixed with ``--``. The arguments format is parameter dependent.

.. program:: wrpmed

.. option:: -h, --help

    Displays basic usage information.

    Example
        To display the online help, type: ::

            wrpmed --help

.. option:: -a <address>:<port>, --address=<address>:<port>

    Specifies the address and port on which the server will listen.

    Argument
        A string representing one address the server listens on and a port. The string can be a host name or an IP address.

    Default value
        127.0.0.1:5909, the IPv4 localhost and the port 5909

    Example
        Listen on localhost and the port 5910::

            wrpmed --address=localhost:5910

.. note::
    The unspecified address (0.0.0.0 for IPv4, :: for IPv6) is not allowed.

.. option:: -s <count>, --sessions=<count>

    Specifies the number of simultaneous sessions.

    Argument
        A number greater or equal to fifty (50) representing the number of allowed simultaneous sessions.

    Default value
        200

    Example
        Allow 2,000 simultaneous session

            wrpmed --sessions=2000

.. note::
    The sessions count determines the number of simultaneous clients the server may handle at any given time. Increasing the value increases the memory load.
    Values below 50 are ignored.

.. option:: -r <path>, --root=<path>

    Specifies the directory where data will be persisted.

    Argument
        A string representing a full path to the directory where data will be persisted.

    Default value
        The "db" subdirectory relative to the launch path.

    Example
        Persist data in /var/wrpme/db ::

            wrpmed --root=/var/wrpme/db

.. option:: --peer=<address>:<port>

    The address and port of a peer to which to connect within the ring. It can be any server belonging to the ring.

    Argument
        The address and port of a machines where a wrpme daemon is running.

    Default value
        None

    Example
        Join a ring where the machine 192.168.1.1 listening on the port 5909 is already connected::

            wrpmed --peer=192.168.1.1:5909

.. option:: --flush-interval=<delay>

    How often entries are persisted to disk. If this value is zero, persistence is disabled.

    Argument
        An integer representing the number of seconds between each flush.

    Default value
        10

    Example
        Disable persistence altogether: ::

            wrpmed --flush-interval=0

        Flush the data every minute: ::

            wrpmed --flush-interval=60

.. option:: --transient

    Disable persistence. Equivalent to --flush-interval=0. Evicted data is lost when wrpmed is transient.

.. option:: --accept-threads=<count>

    The number of threads to handle incoming connections.

    Argument
        An integer representing the number of threads to use to handle incoming connections.

    Default value
        Platform dependent.

    Example
        Use two threads to handle incoming connections::

            wrpmed --accept-threads=2

.. option:: --io-threads=<count>

    The number of threads allocated to asynchronous I/O.

    Argument
        An integer representing the number of threads to use for asynchronous I/O.

    Default value
        Platform dependent.

    Example
        Use four threads for asynchronous I/O processing::

            wrpmed --io-threads=4

.. option:: --limiter-max-entries-count=<count>

    The maximum number of entries allowed in memory. Entries will be evicted as needed to enforce this limit.

    Argument
        An integer representing the maximum number of entries allowed in memory.

    Default value
        1,000

    Example
        To keep the number of entries in memory below 101::

            wrpmed --limiter-max-entries=100

.. note::
    Setting this value too low may cause the daemon to spend more time evicting entries than processing requests.

.. option:: --limiter-max-bytes=<value>

   The maximum usable memory by entries, in bytes. Entries will be evicted as needed to enforce this limit. The alias length as well
   as the content size are both accounted to measure the actual size of entries in memory.

   The daemon may use more than the specified amount of memory because of internal data structures and temporary copies.

   Argument
        An integer representing the maximum size, in bytes, of the entries in memory.

   Default value
        1,073,741,824 (1 GiB)

   Example
       To allow only 100 kiB of entries::

            wrpmed --limiter-max-bytes=102400

       To allow up to 8 GiB::

            wrpmed --limiter-max-bytes=8589934592

.. note::
    Setting this value too high may lead to `trashing <http://en.wikipedia.org/wiki/Thrashing_%28computer_science%29>`_.

.. option:: -o, --log-console

    Activates logging on the console.

.. option:: -l <path>, --log-file=<path>

    Activates logging to one or several files.

    Argument
        A string representing one (or several) path(s) to the log file(s).

    Example
        Log in /var/log/wrpmed.log: ::

            wrpmed --log-file=/var/log/wrpmed.log

.. option:: --log-level=<value>

    Specifies the log verbosity.

    Argument
        A string representing the amount of logging required. Must be one of:

        * detailed (most output)
        * debug
        * info
        * warning
        * error
        * panic (least output)

    Default value
        info

    Example
        Request a debug level logging: ::

            wrpmed --log-level=debug

.. option:: --log-flush-interval=<delay>

    How frequently log messages are flushed to output, in seconds.

    Argument
        An integer representing the number of seconds between each flush.

    Default value
        3

    Example
        Flush the log every minute: ::

            wrpmed --log-flush-interval=60

