Performance
**************************************************

quasardb is developed in C++11 and assembly with performance in mind.

Multithreading
=======================================

The server is actually organized in a network of mini-daemons that exchange messages. This is done in such a way that it preserves low-latency while increasing parallelism.

Multithreading generally implies locking. Locking has been reduced to the minimum with the use of lock-free structures and transactional memory.

Networking
=====================================================

Network I/O are done asynchronously for maximum performance. Most of the I/O framework is based on `Boost.Asio <http://www.boost.org/doc/libs/1_51_0/doc/html/boost_asio.html>`_.

Memory management
=====================================================

quasardb uses custom memory allocators that are multithread-friendly. Whenever possible, quasardb allocates memory on the stack rather than on the heap. If a heap allocation cannot be avoided, quasardb's zero-copy architecture makes sure no cycle is wasted duplicating data, unless it causes data contention.

Measuring performance
==================================

The only way to properly configure your cluster is to measure performance. 

The quasardb comparison tool can be used to create a wide range of test scenarii. It understands the quasardb protocol as well as the memcached and the redis protocol (see :doc:`../reference/qdb_comparison`).





