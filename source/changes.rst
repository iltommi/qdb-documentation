Change log
**********

2.5.0 - "Theodosius" - 04/20/2018
=================================

From `Wikipedia <https://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

    `Theodosius of Bithynia <https://en.wikipedia.org/wiki/Theodosius_of_Bithynia>`_ was a Greek astronomer and mathematician who wrote the Sphaerics, a book on the geometry of the sphere.

Changes in this version
-----------------------

    * Protocol version 20
    * [query] A WHERE clause can now have an arbitrary number of columns.
    * [query] The WHERE clause now supports comparisons for blobs.
    * [persistence] Optimized data storage and compression algorithms resulting in significant savings for timeseries with more than three (3) columns.
    * [daemon] Greatly reduced the probability of conflicts during time series insertions.
    * [api] When a cluster is unstable, the API will now wait a configurable amount of time for stabilization.
    * [shell] Added a new command to display the current status of a cluster.
    * [web bridge] The query API is now available through REST.
    * [packaging] New Core2 build. The Core2 build enables you to run quasarDB on older generation of Intel-compatible processors. The default build requires a Westmere or better micro-architecture.
    * [packaging] We successfully built quasardb for the ARM64 architecture. Build available upon request.
    * [licensing] We've updated the licensing system. Previously attributed licenses will no longer work. Contact you quasarDB Solutions Architect for an updated license. This does not change
      the price or the validity of your current license.

2.4.0 - "Aratus" - 03/11/2018
=============================

From `Wikipedia <https://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

    `Aratus <https://en.wikipedia.org/wiki/Aratus>`_ was a Greek didactic poet. His major extant work is his hexameter poem Phenomena, the first half of which is a verse setting of a lost work of the same name by Eudoxus of Cnidus. It describes the constellations and other celestial phenomena. The second half is called the Diosemeia , and is chiefly about weather lore.`

Changes in this version
-----------------------

    * Protocol version 20
    * [query] Support for arithmetic expressions in SELECT statements
    * [query] Support for multiple ranges in SELECT statements
    * [query] Initial support for WHERE clause - only single column queries are currently supported
    * [persistence] Greatly improved data compression (up to 5x)
    * [aggregations] Added specific SSE 4.2 optimizations for machines without AVX and AVX2
    * [aggregations] Significantly increased the speed of integer 64-bit aggregations (up to 6x)
    * [aggregations] Significantly increased the speed of sum_of_squares and product aggregations functions (up to 4x)
    * [python] Exposed query API
    * [shell] Fixed a bug where the columns would be displayed in the wrong order for a star SELECT

2.3.0 - "Epictetus" - 02/15/2018
================================

From `Wikipedia <https://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

    `Epictetus <https://en.wikipedia.org/wiki/Epictetus>`_ was a Greek Stoic philosopher. He was born a slave at Hierapolis, Phrygia (present day Pamukkale, Turkey) and lived in Rome until his banishment, when he went to Nicopolis in northwestern Greece for the rest of his life. [...] Epictetus taught that philosophy is a way of life and not just a theoretical discipline. To Epictetus, all external events are beyond our control; we should accept calmly and dispassionately whatever happens. However, individuals are responsible for their own actions, which they can examine and control through rigorous self-discipline.

Changes in this version
-----------------------

    * Protocol version 20
    * Queries can now leverage the result of tag based lookup
    * Fixed a bug where skewness computation could be invalid on very large time series
    * [api] The query language is now available through the API
    * [api] Some asynchronous operations did not properly retry on error, resulting in sporadic network errors popped back to the user
    * [admin] Adding an existing user will fail instead of overwritting the old one
    * [packaging] The libc++ API is now bundled on MacOS and FreeBSD for greater compatibility
    * [kernel] Accross the board performance improvements and memory usage reduction
    * [kernel] Upgraded to Boost 1.66
    * [persistence] Upgraded to RocksDB 5.9.2

2.2.0 - "Chrysippus" - 12/21/2017
=================================

From `Wikipedia <https://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

    `Chrysippus of Soli <https://en.wikipedia.org/wiki/Chrysippus>`_ was a Greek Stoic philosopher. He was a native of Soli, Cilicia, but moved to Athens as a young man, where he became a pupil of Cleanthes in the Stoic school. When Cleanthes died, around 230 BC, Chrysippus became the third head of the school. A prolific writer, Chrysippus expanded the fundamental doctrines of Zeno of Citium, the founder of the school, which earned him the title of Second Founder of Stoicism.

Changes in this version
-----------------------

    * Protocol version 20
    * Brand new query language! Available as a preview in the shell. Try ``select arithmetic_mean(volume) from stocks in range(now(), -1d) group by hour`` now! :-)
    * Two new timeseries column types are supported: signed 64-bit integers and nanosecond timestamps
    * Increased memory limit of the community edition from 2 GiB to 4 GiB
    * Greatly improved timeseries insertion speed when data is interleaved
    * Fixed bug in kurtosis computation
    * Fixed a bug where erasing an empty range could result in an uncommitted transaction
    * [api] Support for row-level bulk get and insertion
    * [api] Transparently retry connection on asynchronous requests
    * [api] Make it possible to query the currently configured timeout
    * [shell] Persists command history
    * [shell] Support for syntax highlighting and better completion
    * [shell] Added command for suffix get
    * [persistence] Mounting a Helium volume will now be significantly faster on Windows


2.1.0 - "Cleanthes" - 11/01/2017
================================

From `Wikipedia <https://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

    `Cleanthes, of Assos, <https://en.wikipedia.org/wiki/Cleanthes>`_ was a Greek Stoic philosopher and successor to Zeno of Citium as the second head (scholarch) of the Stoic school in Athens. Originally a boxer, he came to Athens where he took up philosophy, listening to Zeno's lectures. He supported himself by working as a water-carrier at night. [...] He originated new ideas in Stoic physics, and developed Stoicism in accordance with the principles of materialism and pantheism.

Changes in this version
-----------------------

    * Protocol version 20
    * This build now targets the Westmere micro-architecture
    * Native support for distributed time series and server-side aggregation (with AVX support when available)
    * Cryptographically strong authentication (enabled by default)
    * Full network traffic encryption using AES GCM 256 (disabled by default)
    * Levyx Helium persistence layer for high performance storage
    * New querying language with support for distributed joins over tags
    * New API to count prefixes and suffixes
    * Empty entries are now allowed in deques
    * C API: Unified memory management functions for more convenience
    * Improved web bridge error messages logging
    * Improved performance for blob read operations
    * Reduced the impact on cluster performance when a node joins the ring
    * Improved eviction and trimming performance
    * The qdbsh output is colored on terminals that support it
    * New API calls: cluster_purge_cache and cluster_wait_for_stabilization

2.0.0 - "Aristotle" - 01/17/2017
================================

From `Wikipedia <https://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

   `Aristotle <https://en.wikipedia.org/wiki/Aristotle>`_ was a Greek philosopher and scientist born in the city of Stagira, Chalkidice, on the northern periphery of Classical Greece. [...] His writings cover many subjects – including physics, biology, zoology, metaphysics, logic, ethics, aesthetics, poetry, theater, music, rhetoric, linguistics, politics and government –
   and constitute the first comprehensive system of Western philosophy

Building on the solid foundation of quasardb 1.2, quasardb 2.0 is now fully transactional and support distributed secondary indexes while managing to push the performance limits even further.

Changes in this version
-----------------------

    * Protocol version 20
    * Distributed ACID transactions
    * Distributed secondary-indexes (tags)
    * Distributed double-ended queues (deques)
    * Native atomic signed 64-bit integers operations
    * Native support for Mac OS X
    * Many usability improvements in all tools
    * Switched from LevelDB to a customized RocksDB persistence layer
    * New APIs: Node.js and PHP
    * Greatly improved .NET and Java APIs
    * Performance level: ludicrous
    * And so much more!

Changes in the version
----------------------

1.2.1 - "Anaximander" - 05/05/2015
==================================

This release is our most scalable release ever and has been tested with up to 25,000 concurrent connections on a single node running on an entry-level dedicated server.

This release is fully compatible with 1.2.0 and the whole 1.1.x "Pythagoras" line.

Changes in this version
-----------------------

    * Protocol version: 14
    * Increased default TCP listen queue to 16,384 on all platforms
    * Stabilization is now less agressive in case of node failures, delivering an even better availability
    * Multi-connect is now done in a random order
    * Removed network usage graphs from the administration console
    * Fixed minor bugs in the configuration generation tool (https://www.quasardb.net/confgen)

1.2.0 - "Anaximander" - 02/09/2015
==================================

From `Wikipedia <https://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

   `Anaximander <https://en.wikipedia.org/wiki/Anaximander>`_ was a pre-Socratic Greek philosopher who lived in Miletus,[3] a city of Ionia (in modern-day Turkey). [...] He was an early proponent of science and tried to observe and explain different aspects of the universe, with a particular interest in its origins, claiming that nature is ruled by laws, just like human societies, and anything that disturbs the balance of nature does not last long.

This release unlocks even more performance with a brand new load-balancing algorithm. Without any configuration, reads will be done on the nearest, most available replica, resulting is better network usage and reduced latency.

We are also pleased to announce a brand new PHP API. Millions of websites accross the world can now benefit from quasardb unrivaled performance.

This release is fully compatible with the 1.1.x "Pythagoras" line.

Changes in this version
-----------------------

    * Protocol version: 14
    * New API: PHP
    * Reads are now automatically balanced, taking distance and load into account
    * When no licence is available, quasardb now runs in "free" mode for evaluation purposes
    * Fixed several glitches in the administration console and improved overall responsiveness
    * Fixed a condition where an invalid time stamp could be displayed in the log file
    * Web bridge: added an error message when the listening port isn't available

1.1.5 - "Pythagoras" - 12/15/2014
=================================

The release features significant improvements to the administration console and now persists the statistics.

This release is fully compatible with 1.1.0, 1.1.1, 1.1.2, 1.1.3 and 1.1.4.

Changes in this version
-----------------------

    * Protocol version: 14
    * Major improvements to the administration console
    * Statistics are now persisted within quasardb
    * Fixed a retro-compatibility  issue where 1.1.3 clients requests could be misunderstood by 1.1.4+ servers
    * Fixed a reconciliation issue where a partitioned node rejoining a cluster could not correctly propagate an update
    * The shell now displays a meaningful error message when no remote daemon is available
    * All binaries and all platforms except FreeBSD now statically link against the libc++1 library for convenience
    * A warning is now emitted when a node reaches 90% of its quota
    * Java API : the multi-connect feature is now supported
    * FreeBSD installations now require FreeBSD 10 and Clang 3.5.
    * Windows clients now require Visual Studio 2013 Update 4.
    * Upgraded to Intel TBB
    * Upgraded to Boost 1.57.0
    * Upgraded to LevelDB 1.18


1.1.4 - "Pythagoras" - 06/30/2014
=================================

This release features a brand new .NET API and various improvements to the administration interface.

This release is fully compatible with 1.1.0, 1.1.1, 1.1.2 and 1.1.3.

Changes in this version
-----------------------

    * Protocol version: 14
    * Reduced the dependencies of all binaries through static linking on all platforms
    * .NET API: Fully functionnal .NET 4.0 API
    * Administration console: added more information, fixed numerous glitches and greatly reduced memory usage
    * Daemon: greatly reduced inter-node traffic in a stable cluster
    * Shell: greatly improved online help
    * Linux: upgraded to gcc 4.8.2
    * Upgraded to Intel TBB 4.2 Update 4
    * Upgraded to LevelDB 1.17

1.1.3 - "Pythagoras" - 04/29/2014
=================================

This maintenance release features a brand new administration interface, enabling users to monitor small to large clusters in just a couple of clicks!

This release is fully compatible with 1.1.0, 1.1.1 and 1.1.2.

Changes in this version
-----------------------

    * Protocol version: 14
    * Administration console: brand new administration console with many exciting features
    * Daemon and web bridge: support for file based configuration
    * Daemon: fixed a race condition where an error could be returned to successful long standing batch operations
    * Web bridge: added CPU, disk and memory usage information
    * Java API: it is now possible to specify an expiry for all write operations
    * Comparison tool: fixed progress display
    * Upgraded to LevelDB 1.16

1.1.2 - "Pythagoras" - 02/03/2014
=================================

About
-----

This maintenance release focuses on disk usage control. It is now possible to limit the persisted size. When the limit is reached, any operation which would result in a size increase will be aborted and an error will be returned.

This release is fully compatible with 1.1.0 and 1.1.1.

Changes in this version
-----------------------

    * Protocol version: 14
    * Daemon: added option to limit the persisted size
    * Daemon: fixed long log paths parsing
    * Web bridge: added network usage information
    * Comparison tool: new ``put`` (only) command
    * Comparison tool: added progress bar
    * Shell: fixed space related parsing bug
    * Upgraded to LevelDB 1.15

1.1.1 - "Pythagoras" - 01/07/2014
=================================

About
-----

This maintenance release comes with many new features and performance improvements. It is fully compatible with release 1.1.0.

Changes in this version
-----------------------

    * Protocol version: 14
    * Daemon: various optimizations to reduce latency
    * Comparison tool: support for multithreaded benchmarks
    * C/C++ API: Added client-side logging
    * C++ API: Batch and prefix operations can now be chained
    * Java API: Support for batch operations
    * Java API: Support for expiry
    * Python API: Support for batch operations
    * Upgraded to LevelDB 1.14
    * Upgraded to TBB 4.2
    * Upgraded to Boost 1.55.0

1.1.0 - "Pythagoras" - 09/16/2013
=================================

About
-----

From `Wikipedia <https://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

   `Pythagoras of Samos <https://en.wikipedia.org/wiki/Pythagoras>`_ was an Ionian Greek philosopher, mathematician, and founder of the religious movement called Pythagoreanism. [...] Pythagoras made influential contributions to philosophy and religious teaching in the late 6th century BC. He is often revered as a great mathematician, mystic and scientist, but he is best known for the Pythagorean theorem which bears his name.

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

    * Protocol version: 13
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
    * Daemon: Minor performance improvement (less than 5%) for requests smaller than 1 KiB
    * Upgraded to Visual Studio 2012 Update 3
    * Upgraded to TBB 4.1 update 4
    * Upgraded to LevelDB 1.12

1.0.0 - "Zeno" - 06/10/2013
===========================

About
-----

From `Wikipedia <https://en.wikipedia.org/wiki/Main_Page>`_, the free encyclopedia:

   `Zeno of Citium <https://en.wikipedia.org/wiki/Zeno_of_Citium>`_ was the founder of the `Stoic <https://en.wikipedia.org/wiki/Stoicism>`_ school of philosophy, which he taught in Athens from about 300 BC. [...] Stoicism laid great emphasis on goodness and peace of mind gained from living a life of Virtue in accordance with Nature.

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
    * Java API: Added support for ``get_update`` and ``compare_and_swap`` operations
    * Console: Now display statistics for ``get_update`` and ``compare_and_swap`` operations
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
    * Client API: ``remove_all`` is no longer experimental
    * Daemon: Faster lookup on clusters with more than 20 nodes
    * Daemon: Faster stabilization on clusters with more than 5 nodes
    * Daemon: Automatically detects the best memory eviction threshold (can be overriden)
    * Daemon: changed the default port from 5909 to 2836 (can be overriden)
    * Java API: Fixed invalid method name (delete instead of remove)
    * Upgraded to LevelDB 1.5

0.6.5 - 06/08/2012
==================

Changes in this version
-----------------------

    * Client API: Major performance increase (up to 100%) for small entries (below 1 KiB)
    * Client API: Added more error codes
    * Client API: Added status query function
    * Client API: Added new, atomic, ``get_and_update`` function
    * Client API: Added experimental ``remove_all`` function
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
    * New persistence layer based on `LevelDB <https://github.com/google/leveldb>`_
    * Lightweight HTML5 monitoring console
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
