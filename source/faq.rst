FAQ
***

Does quasardb support IPv6?
============================

Yes.

Which platform does quasardb support?
=====================================

FreeBSD, Linux and Windows.

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

In terms of bandwidth, the same computer easily saturates a ten gigabit network. Your maximum bandwidth will depend on the size and the type of your data and your network capability.

Is quasardb faster than... ?
============================

Quasardb is not only faster but also more frugal: it will consume less memory, less disk space and less CPU while achieving a higher level of performance.

Nevertheless, keep in mind that what matters is *your usage scenario*. We will be happy to help you answer this question: contact us for more information (see :doc:`contact`).

Does quasardb support 32-bit operating systems?
===============================================

Only Windows 32-bit is supported. Linux and FreeBSD are 64-bit only.

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

A web bridge enables the user to monitor a node with a HTML 5 interface. The bridge also offers JSON/JSONP interfaces to access data and statistics.

See :doc:`../reference/qdb_httpd` for more information.

Is quasardb free of charge?
===========================

quasardb requires a :doc:`license`.

Non-profit organizations and non-commercial usage are eligible for free licenses.

Contact us for more information, see :doc:`contact` and :doc:`license`.

Can I embed the quasardb technology in my hardware/software?
============================================================

Yes, we have a special license for this case. Contact us for more information, see :doc:`contact`

Do I need a licence to write a client?
======================================

No license is required to write a quasardb client, but the software's documentation and credits must state the following "This software features quasardb, a Quasardb SAS technology. All rights reserved.".

A client is software that connects to a remote or local quasardb server running as a separate instance. If your product needs to include the server as well, a license is required. Contact us for more information, see :doc:`contact`

What happens when my license expires?
=====================================

See :ref:`license_expiration`.

How long are versions compatible?
=================================

Quasardb is versioned using a 1.MAJOR.MINOR system. All patch notes can be found at :doc:`changes`.

Changes in minor level, such as 1.1.0 to 1.1.1, are maintenance releases or add small features to quasardb. The database and client API are backwards compatible with previous versions.

Changes in major level, such as 1.1.0 to either 1.2.0 or 2.0.0, add significant features to quasardb. The database and client API may not be backwards compatible. Please read the :doc:`changes` or `contact us <contact.html>`_ for more information.

In what language is quasardb written?
=====================================

The core quasardb engine (that we also call kernel) is written in C++ 14 and assembly. It makes an intensive usage of the STL and the `boost libraries <http://www.boost.org/>`_.

The administration interface is written in HTML5/Javascript.

Is quasardb open source?
========================

We want to open source as much as we can of quasardb in the form of packaged libraries.

You can find `the open sourced code on github <https://github.com/bureau14/open_lib>`_ under a three-clauses BSD license. 

Does quasardb use open source libraries?
========================================

Yes it does! Here is the list:

* `Boost <http://www.boost.org/>`_
* `Datejs <http://code.google.com/p/datejs/>`_
* `hiredis <https://github.com/antirez/hiredis>`_
* `LevelDB <http://code.google.com/p/leveldb/>`_
* `javabi-sizeof <http://code.google.com/p/javabi-sizeof/>`_
* `JQuery <http://jquery.com/>`_
* `Kryo <http://code.google.com/p/kryo/>`_
* `Intel Threading Building Blocks <http://threadingbuildingblocks.org/>`_ (commercial license)
* `memcachepp <https://github.com/mikhailberis/memcachepp>`_
* `Snappy <http://code.google.com/p/snappy/>`_

If you find the list to be inaccurate or suspect a license violation, mail to `bug@quasardb.net <bug@quasardb.net>`_.

Where are you located?
======================

We are located in Paris, France. 
