Performance
**************************************************

wrpme is developed in C++11 and assembly with performance in mind.

Multithreading
=======================================

The server is actually organized in a network of mini-daemons that exchange messages. This is done in such a way that preserves low-latency while  increasing parallelism.

Mutlithreading generally implies locking. Locking has been reduced to the minimum with the use of lock-free structures and lightweight locks. 

Networking
=====================================================

Network I/O are done asynchronously for maximum performance. Most of the I/O framework is based on `Boost.Asio <http://www.boost.org/doc/libs/1_49_0/doc/html/boost_asio.html>`_.

Memory management
=====================================================

wrpme uses various custom memory allocators that are multithread-friendly. The most important optimization is that allocations are reduced to the minimum and that the stack is used whenever possible.

If the allocation cannot be avoided, the zero-copy architecture makes sure no cycle is wasted duplicating data.

Measuring performance
==================================

The only way to properly configure your hive is to measure performance. 

The comparison tool can be used to create a wide range of testing scenarii. It understands the wrpme protocol as well as the memcached protocol (see :doc:`../reference/wrpme_comparison`).





