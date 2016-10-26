FAQ
***

.. |ContactUs| replace:: :doc:`Contact us for more information <contact>`.
..

Does quasardb support IPv6?
============================

Yes.

Which platform does quasardb support?
=====================================

FreeBSD, Linux, OS X and Windows.

What is the best platform to use quasardb?
==========================================

All platforms are equally supported.

Does quasardb support multi-core and/or multi-processor computers?
==================================================================

Yes, quasardb has been *designed for* such architectures.

How is data transmitted on the network?
=======================================

quasardb uses a proprietary low-overhead binary protocol.

How fast is quasardb?
=====================

In terms of requests per second, a Core i7 desktop computer can serve more than 1,000,000 (one million) requests per second.

In terms of bandwidth, the same computer easily saturates a ten-gigabit network. Your maximum bandwidth will depend on the size and the type of your data and your network capability.

Is quasardb faster than... ?
============================

quasardb is not only faster but also more frugal: it will consume less memory, less disk space and less CPU while achieving a higher level of performance.

Nevertheless, keep in mind that what matters is *your usage scenario*. We will be happy to help you answer this question. |ContactUs|

Does quasardb support 32-bit operating systems?
===============================================

Only the Windows port is available for Windows 32-bit and Windows 64-bit. Linux and FreeBSD are 64-bit only.

What is the largest possible size for an entry?
===============================================

Unless otherwise configured, an entry cannot be larger than the largest contiguous amount of memory the operating system may allocate.

On most operating systems, this is close to the amount of physical memory (RAM) available on the server.

What is the maximum entries count?
==================================

The maximum entries count depends on the physical capabilities of your cluster and the size of the entries.

How much RAM can quasardb handle?
=================================

As much as the operating system can.

How can one administrate a quasardb cluster?
============================================

A web bridge enables the user to monitor a node with a HTML5 interface. The bridge also offers JSON/JSONP interfaces to access data and statistics.

See :doc:`../reference/qdb_httpd` for more information.

Is quasardb free of charge?
===========================

quasardb requires a :doc:`license`.

Non-profit organizations and non-commercial usage are eligible for free licenses.

|ContactUs| Take a look as well at :doc:`licensing information <license>`.

Can I embed the quasardb technology in my hardware/software?
============================================================

Yes, we have a special license for this case. |ContactUs|

Do I need a license to write a client?
======================================

No license is required to write a quasardb client, but the software's documentation and credits must state the following "This software features quasardb, a quasardb SAS technology. All rights reserved.".

A client is software that connects to a remote or local quasardb server running as a separate instance. If your product needs to include the server as well, a license is required. |ContactUs|

What happens when my license expires?
=====================================

See :ref:`license_expiration`.

I deleted data, but my disk remains full
========================================

quasardb uses Multi Version Concurrency Control (MVCC). Deleted data is not immediately removed from disk. You can learn more in :doc:`../concepts/data_storage`.

My quasardb cluster doesn't scale in performance
================================================

By default, quasardb will use a random ID for each node. It is recommended to use the indexed ID notation for maximum scalability. More information in :doc:`../concepts/cluster_organization`.


How long are versions compatible?
=================================

quasardb is versioned using a MAJOR.MINOR.PATCH system. All patch notes can be found at :doc:`changes`.

Changes in patch level, such as 1.1.0 to 1.1.1, are maintenance releases. The database and client API are 100% backwards compatible with previous versions.

Changes in minor level, such as 1.0.0 to 1.1.0, add features to quasardb. The database and client API are 100% backwards compatible with previous versions.

Changes in major level, such as 1.0.0 to 2.0.0, add significant features to quasardb. The database and client API may not be backwards compatible. Upgrades may require manual intervention. :doc:`Contact us for assistance <contact>`.

In what language is quasardb written?
=====================================

The core quasardb engine (that we also call kernel) is written in C++ 14 and assembly. It makes an intensive usage of template metaprogramming, the standard library and the `Boost C++ Libraries <http://www.boost.org/>`_.

The administration interface is written in HTML5/JavaScript.

Is quasardb open source?
========================

quasardb core isn't open source, however many components and APIs are fully open-sourced under a three-clauses BSD license.

You will find all our open sourced components and API on our `GitHub account <https://github.com/bureau14/>`_ .

Does quasardb use open source libraries?
========================================

Yes it does! Here is the list:

* `Arduino JSON <https://github.com/bblanchon/ArduinoJson>`_
* `Boost <http://www.boost.org/>`_
* `Brigand <https://github.com/edouarda/brigand>`_
* `Datejs <http://code.google.com/archive/p/datejs/>`_
* `Farmhash <https://github.com/google/farmhash>`_
* `fmt <https://github.com/fmtlib/fmt>`_
* `Intel Threading Building Blocks <https://www.threadingbuildingblocks.org/>`_
* `JQuery <http://jquery.com/>`_
* `Linenoise <https://github.com/antirez/linenoise>`_
* `LZ4 <http://lz4.github.io/lz4/>`_
* `RapidJson <http://rapidjson.org/>`_
* `RocksDB <https://github.com/facebook/rocksdb>`_
* `ZLib <http://www.zlib.net/>`_

If you find the list to be inaccurate or suspect a license violation, mail to `bug@quasardb.net <bug@quasardb.net>`_.
