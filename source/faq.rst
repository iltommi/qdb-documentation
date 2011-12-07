
FAQ
*********

Does wrpme support IPv6?
============================

Yes.

Which platform does wrpme support?
=====================================

FreeBSD, Linux and Windows. 

What is the best platform to use wrpme?
========================================

All platforms are equally supported. 

Does wrpme support multi-core and/or multi-processor computers?
=================================================================

Yes, wrpme has been *designed for* such architectures. 

How is data transmitted on the network?
=========================================

wrpme uses a proprietary low-overhead binary protocol with variable multi-level compression. 

How fast is wrpme?
=====================

In terms of requests per second, a Core i7 desktop computer can serve more than 1,000,000 (one million) requests per second.

In terms of bandwidth, the same computer easily saturates a gigabit network bandwidth. Your maximum bandwidth will depend on the size and the type of your data and your network capability.

Is wrpme faster than... ?
==========================

We are working on fair and reproducible benchmarks. 

Our preliminarily results show that wrpme can be an order of magnitude faster than other engines (open source or commercial), especially as entries size grow.

Does wrpme support 32-bit operating systems?
==============================================

Only Windows 32-bit is supported. Linux and FreeBSD are 64-bit only.

What is the largest possible size for an entry?
================================================

Unless otherwise configured, an entry cannot be larger than the largest contiguous amount of memory the operating system may allocate.

On most operating systems, this is close to the amount of physical memory (RAM) available on the server.

What is the maximum entries count?
==================================

As long as you have the disk space for it, there is no limit (unless otherwise configured) to the numbers of entries into a wrpme server.

How much RAM can wrpme handle?
================================

As much as the operating system can.

How can one administrate a wrpme cluster?
============================================

A web bridge enables the user to monitor a node with a HTML 5 interface. The bridge also offers JSON/JSONP interfaces to access data and statistics.

See :doc:`../reference/wrpme_httpd` for more information.

Is wrpme free of charge?
===========================

wrpme is free of charge for non-commercial purposes.

For example if you run a personal blog and wish to speed it up with wrpme, you do not need to acquire a license. 
If your personal blog generates revenues, you will need to acquire a license.

Non-profit organizations are not *required* to acquire a license, but may have to, should they need support.

What do I get when I register?
==================================

Contact us for more information, see :doc:`contact`

Can I embed the wrpme technology in my hardware/software?
============================================================

Yes, we have a special license for this case. Contact us for more information, see :doc:`contact`

Do I need a licence to write a client?
========================================================

No licence is required to write a wrpme client, but the software's documentation and credits must state the following "this software features wrpme, a Bureau 14 technology. All rights reserved.".

A client is a software that connects to a remote or local wrpme server running as a separate instance. If your product needs to include the server as well, a licence is required. Contact us for more information, see :doc:`contact`

Is support available for non-registered users?
=================================================

Anyone can submit a bug or request a feature in mailing to `bug@wrp.me <bug@wrp.me>`_. All bug reports and feature requests are reviewed.

Support, however, is only available to registered users.

Do you offer consulting or bespoke services?
=================================================

Yes! Contact us for more information, see :doc:`contact`

In what language is wrpme written?
====================================

The core wrpme engine (that we also call kernel) is written in C++ 11. It makes an intensive usage of the STL and the `boost libraries <http://www.boost.org/>`_.

The administration interface is written in HTML5/Javascript.

Is the version I downloaded from the web site limited or crippled in any way?
==============================================================================

No. If you feel like it, you can build a petabyte datacenter with it!

Is wrpme open source?
========================

No.

Does wrpme use open source libraries?
==========================================

Yes it does! Here is the list as of August 2011:

* `Boost <http://www.boost.org/>`_
* `Datejs <http://code.google.com/p/datejs/>`_
* `Highcharts <http://www.highcharts.com/>`_  (commercial license)
* `LevelDB <http://code.google.com/p/leveldb/>`_
* `javabi-sizeof <http://code.google.com/p/javabi-sizeof/>`_
* `JQuery <http://jquery.com/>`_
* `Kryo <http://code.google.com/p/kryo/>`_
* `Intel Threading Building Blocks <http://threadingbuildingblocks.org/>`_ (commercial license)
* `Snappy <http://code.google.com/p/snappy/>`_

If you find the list to be inaccurate or discover a license violation, mail to `bug@wrp.me <bug@wrp.me>`_.  

Where are you located?
=========================

We are located in Paris, France. We offer worldwide off-site and on-site consulting.
