Change log
**********

1.1.0 - "Pythagoras" - 09/16/2013
=================================

About
-----

From `Wikipedia <http://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

   `Pythagoras of Samos <http://en.wikipedia.org/wiki/Pythagoras>`_ was an Ionian Greek philosopher, mathematician, and founder of the religious movement called Pythagoreanism. [...] Pythagoras made influential contributions to philosophy and religious teaching in the late 6th century BC. He is often revered as a great mathematician, mystic and scientist, but he is best known for the Pythagorean theorem which bears his name.

This release brings major new features. quasardb now support prefix based research, configurable expiration and batch operations. These features are brought to you without compromising on performance or reliability.

Changes in this version
-----------------------

    * Protocol version: 14
    * API: Support for prefix-based research
    * API: Support for configurable expiration
    * API: Support for batch operations (C/C++ only)
    * API: Deprecated streaming API
    * Upgraded to LevelDB 1.13

1.0.1 SR1 - "Zeno" - 09/11/2013
===============================

About
-----

This version is 100 % compatible with quasardb 1.0.1 "Zeno" and only includes important fixes. 

Changes in this version
-----------------------

    * Windows API: *reliability fix* The unability to securely generate an unique path could result in an ungraceful failure of qdb_open
    * Daemon: Clarified many error messages
    * Daemon, web bridge: Daemonization command switch on UNIXes
    * Daemon, web bridge: The HUP signal is now ignored on UNIXes
    * FreeBSD: upgraded to Clang 3.3
    * Upgraded to Boost 1.54.0


1.0.1 - "Zeno" - 07/08/2013
===========================

About
-----

**This maintenance release includes an important security fix.**

No new functionnality has been added.

Changes in this version
-----------------------

    * Protocol version: 13
    * Daemon: **security fix** Carefully crafted messages could cause the server to allocate an excessive amount of memory resulting in a denial of service
    * Console: Fixed glitches introduced in 1.0.0
    * API: The reported persisted size is now much more accurate
    * Daemon: Greatly improved performance for all status APIs
    * Daemon: Reworded some network error messages for clarity
    * Daemon: Minor performance improvement (less than 5%) for requests smaller than 1 kiB
    * Upgraded to Visual Studio 2012 Update 3
    * Upgraded to TBB 4.1 update 4
    * Upgraded to LevelDB 1.12

1.0.0 - "Zeno" - 06/10/2013
===========================

About
-----

From `Wikipedia <http://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

   `Zeno of Citium <http://en.wikipedia.org/wiki/Zeno_of_Citium>`_ was the founder of the `Stoic <http://en.wikipedia.org/wiki/Stoicism>`_ school of philosophy, which he taught in Athens from about 300 BC. [...] Stoicism laid great emphasis on goodness and peace of mind gained from living a life of Virtue in accordance with Nature.

After years of research and developement it is an overwhelming pleasure to annonce the availability of version 1.0.0. The last eighteen months have been dedicated to the everlasting quest of performance and stability. It is now time for the version number to reflect the level of quality and trustworthiness that quasardb delivers.

A big *thank you* to all our families, friends, partners and customers for their continued support that helped make quasardb a reality.

Changes in this version
-----------------------

    * Protocol version: 12
    * API: New atomical conditional remove (remove_if) operation
    * API: New atomical get and remove (get_remove) operation
    * API: Can now iterate on entries
    * Daemon: Replica do not stay hot in memory to reduce memory usage
    * Daemon: Timeout for inter-node communications is now properly accounted on all platforms
    * Daemon: Fixed a race condition where a session could be freed twice during shutdown
    * Upgraded to TBB 4.1 update 3
    * Upgraded to LevelDB 1.10

0.7.4 - 03/18/2013
==================

Changes in this version
-----------------------

    * API: Can now retrieve a remote node's configuration in JSON format
    * API: Can now retrieve a remote node's topology in JSON format
    * API: Can now remotely stop a node
    * C/C++ API: Added a qdb_e_uninitialized value to the error enumeration
    * Python API: Improved documentation and added examples
    * Web bridge: Richer global status information
    * Web bridge: More verbose logging
    * Daemon: In case of a critical error a detailled status will be dumped to a separate file on disk (in addition to previously existing log errors)
    * Daemon: Stabilization is one order of magnitude faster in case of failure
    * Daemon: Improved eviction speed in all cases
    * Daemon: The daemon now exits right away if the listening port is unavailable
    * Daemon: Better and more coherent network log messages
    * Daemon: A node that was started with incoherent parameters will now be forced out of the ring
    * Daemon: Fixed ignored remove_all requests issue
    * FreeBSD: upgraded to clang 3.2 and libc++ 1
    * Upgraded to Boost 1.53.0

0.7.3 - 02/11/2013
==================

Changes in this version
-----------------------

    * New C++ API!
    * C and Java API: Added qdb_error to translate an error code into a meaningful message
    * C/C++ API: Can connect to multiple remote hosts at a time for increased client-side resilience
    * Java API: Added support for get_update and compare_and_swap operations
    * Console: Now display statistics for get_update and compare_and_swap operations
    * Daemon: Fixed invalid replication parameter logging
    * Daemon: Fixed invalid total size reporting
    * Daemon: Improved replication factor documentation

0.7.2 - 01/14/2013
==================

Changes in this version
-----------------------

    * Now officially named quasardb!
    * Daemon: Minimized thread switching to reduce latency
    * Various minor optimizations and improvements
    * Windows: Upgraded to Visual Studio 2012
    * Upgraded to Boost 1.52.0
    * Upgraded to TBB 4.1 SP1
    * Upgraded to LevelDB 1.9

0.7.1 - 10/15/2012
==================

Changes in this version
-----------------------

    * Daemon: Integrated licensing mechanism
    * Daemon: Fixed invalid statistics update
    * Upgraded to Boost 1.51.0

0.7.0 - 09/04/2012
==================

Changes in this version
-----------------------

    * Daemon: Automatic, integrated and distributed replication up to 4 copies
    * Daemon: Support for global configuration
    * Daemon: Fixed bug that could cause a connection reset between two nodes if they were using a half-duplex channel
    * Benchmarking tool: Added Redis support
    * Client API: Fixed bug that prevented the 32-bit Windows API to add entries larger than 4 GiB
    * Java API: Greatly improved performances, up to 100%!
    * Greatly improved the `documentation <http://doc.quasardb.net/>`_
    * Upgraded to Boost 1.50.0
    * Known bug: the eviction, pagein and size counts reported in the administration console are invalid

0.6.66 - 07/02/2012
===================

Changes in this version
-----------------------

    * Client API: New streaming API (C only)
    * Client API: New compare and swap operation (C only)
    * Client API: "remove all" is no longer experimental
    * Daemon: Faster lookup on hives with more than 20 nodes
    * Daemon: Faster stabilization on hives with more than 5 nodes
    * Daemon: Automatically detects the best memory eviction threshold (can be overriden)
    * Daemon: changed the default port from 5909 to 2836 (can be overriden)
    * Java API: Fixed invalid method name (delete instead of remove)
    * Upgraded to LevelDB 1.5

0.6.5 - 06/08/2012
==================

Changes in this version
-----------------------

    * Client API: Major performance increase (up to 100%) for small entries (below 1 kiB)
    * Client API: Added more error codes
    * Client API: Added status query function
    * Client API: Added new, atomic, "get and update" function
    * Client API: Added experimental "remove all" function
    * Daemon: Greatly improved scalability for machines with more than 4 physical cores
    * Daemon: Removed obsolete options
    * Daemon: Improved Windows console logging performance
    * FreeBSD: Now requires FreeBSD 9.0 or later
    * FreeBSD: switched from gcc to Clang
    * Upgraded to LevelDB 1.4
    * Upgraded to Boost 1.49.0
    * Upgraded to TBB 4.0 SP4

0.6.0 - 01/16/2012
==================

Changes in this version
-----------------------

    * Python API: Brand new Python API!
    * Daemon: new "transient" option
    * Daemon: Improved memory management
    * Daemon: Improved performance for large entries
    * Daemon: Reduced latency
    * Upgraded LevelDB

0.5.2 - 11/14/2011
==================

Changes in this version
-----------------------

    * Windows: Digital signatures now include a timestamp.
    * Web bridge: Improved the internal data exchange format.
    * Daemon: When exiting under heavy load, the daemon could deadlock.
    * Daemon: Slight performance increase.
    * Client API: Improved performance on unreliable networks.
    * Upgraded LevelDB
    * Upgraded to TBB 4.0 SP1

0.5.1 - 10/01/2011
==================

Changes in this version
-----------------------

    * Java API: Major rework, better and easier than before!
    * Daemon: Added an icon in the Windows binary.
    * Daemon: Properly account the idle session parameter.
    * Daemon: Exit with an appropriate error message when the listening port is unavailable.
    * Client API: Made the connection process more resilient.
    * Upgraded LevelDB

0.5.0 - 08/01/2011
==================

Changes in this version
-----------------------

    * Peer-to-peer network distribution
    * Web bridge with JSON/JSONP interfaces
    * Java API
    * New persistence layer based on `LevelDB <http://code.google.com/p/leveldb/>`_
    * Lightweight HTML 5 monitoring console
    * Reduced overall memory load
    * Improved performance by 10-20 %
    * Removed legacy code and API
    * `Documentation <http://doc.quasardb.net/>`_!
    * The quasardb shell now handles binary input and output
    * Upgraded Linux and FreeBSD compilers to gcc 4.6.1
    * Upgraded to Boost 1.47.0

0.4.2 - 05/26/2011
==================

Changes in this version
-----------------------

    * Increased reliability
    * Major performance improvements for entries larger than 50 MiB
    * More verbose logging (if requested)
    * Reduced latency under extreme load
    * Reduced memory footprint
    * fix: The 0.4.1 Linux API could not be linked to due to a misconfiguration on our build machine

0.4.1 - 05/07/2011
==================

Changes in this version
-----------------------

    * Multiplatform Python API package with installer
    * Fixed FreeBSD invalid rpath
    * qdbsh can now process standard input and output

0.4.0 - 04/22/2011
==================

Changes in this version
-----------------------

    * Python API
    * Improved server network code
    * API and server are now available as two distinct packages
    * Fixed file logging date format
    * Installer for Windows version
    * Upgraded to Boost 1.46.1
    * Upgraded TBB to version 3.0 Update 6
    * Upgraded Windows compiler to Visual Studio 2010 SP1
    * Upgraded Linux and FreeBSD compilers to gcc 4.6.0

0.3.2 - 02/26/2011
==================

Changes in this version
-----------------------

    * Windows binaries are now digitally signed.
    * High-performance slab allocator is now used for logging.
    * Fixed a minor memory leak.
    * The Linux and FreeBSD binaries now have a rpath to automatically
      load libraries present in quasardb's lib subdirectory.
    * Upgraded TBB to version 3.0 Update 5

0.3.1 - 02/22/2011
==================

Changes in this version
-----------------------

    * Asynchronous standalone TCP (IPv4 and IPv6) server
    * Fast monte carlo eviction
    * New high-performance slab memory allocator
    * Shell client
    * New API
    * May contain up to 1% of awesomeness

0.2.0 - 11/11/2010
==================

Changes in this version
-----------------------

    * Update and remove now accessible via the C API
    * More efficient logging
    * Improved internal memory model
    * Internal statistics

0.1.0 - 07/26/2010
==================

Changes in this version
-----------------------

    * First official beta version!
    * nginx support
    * User may add/generate/query through the C API
    * High performance asynchronous log
    * High performance query
    * Flat-file "trivial" serialization
    * Db maintenance tool
