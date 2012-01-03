Change log
***************

v0.6.0 - 01/13/2011
-------------------

    * Python API: Brand new Python API!
    * Daemon: new "transient" option
    * Daemon: Improved memory management
    * Daemon: Improved performance for large entries
    * Daemon: Reduced latency
    * Upgraded LevelDB

v0.5.2 - 11/14/2011
-------------------

    * Windows: Digital signatures now include a timestamp.
    * Web bridge: Improved the internal data exchange format.
    * Daemon: When exiting under heavy load, the daemon could deadlock.
    * Daemon: Slight performance increase.
    * Client API: Improved performance on unreliable networks.
    * Upgraded LevelDB
    * Upgraded to TBB 4.0 SP1

v0.5.1 - 10/01/2011
-------------------

    * Java API: Major rework, better and easier than before!
    * Daemon: Added an icon in the Windows binary.
    * Daemon: Properly account the idle session parameter.
    * Daemon: Exit with an appropriate error message when the listening port is unavailable.
    * Client API: Made the connection process more resilient.
    * Upgraded LevelDB

v0.5.0 - 08/01/2011
-------------------

    * Peer-to-peer network distribution
    * Web bridge with JSON/JSONP interfaces
    * Java API
    * New persistence layer based on `LevelDB <http://code.google.com/p/leveldb/>`_ 
    * Lightweight HTML 5 monitoring console
    * Reduced overall memory load
    * Improved performance by 10-20 %
    * Removed legacy code and API
    * `Documentation <http://doc.wrpme.com/>`_!
    * The wrpme shell now handles binary input and output    
    * Upgraded Linux and FreeBSD compilers to gcc 4.6.1
    * Upgraded to Boost 1.47.0

v0.4.2 - 05/26/2011
-------------------

    * Increased reliability
    * Major performance improvements for entries larger than 50 MiB
    * More verbose logging (if requested)
    * Reduced latency under extreme load
    * Reduced memory footprint
    * fix: The 0.4.1 Linux API could not be linked to due to a misconfiguration on our build machine

v0.4.1 - 05/07/2011
-------------------

    * Multiplatform Python API package with installer
    * Fixed FreeBSD invalid rpath
    * wrpmesh can now process standard input and output

v0.4.0 - 04/22/2011
-------------------

    * Python API
    * Improved server network code
    * API and server are now available as two distinct packages
    * Fixed file logging date format
    * Installer for Windows version
    * Upgraded to Boost 1.46.1
    * Upgraded TBB to version 3.0 Update 6
    * Upgraded Windows compiler to Visual Studio 2010 SP1
    * Upgraded Linux and FreeBSD compilers to gcc 4.6.0

v0.3.2 - 02/26/2011
-------------------

    * Windows binaries are now digitally signed.
    * High-performance slab allocator is now used for logging.
    * Fixed a minor memory leak.
    * The Linux and FreeBSD binaries now have a rpath to automatically
      load libraries present in wrpme's lib subdirectory.
    * Upgraded TBB to version 3.0 Update 5

v0.3.1 - 02/22/2011
-------------------

    * Asynchronous standalone TCP (IPv4 and IPv6) server
    * Fast monte carlo eviction
    * New high-performance slab memory allocator
    * Shell client
    * New API
    * May contain up to 1% of awesomeness
    
v0.2.0 - 11/11/2010
-------------------

    * Update and remove now accessible via the C API
    * More efficient logging
    * Improved internal memory model
    * Internal statistics

v0.1.0 - 07/26/2010
-------------------

    * First official beta version!
    * nginx support
    * User may add/generate/query through the C API
    * High performance asynchronous log
    * High performance query
    * Flat-file "trivial" serialization
    * Db maintenance tool
