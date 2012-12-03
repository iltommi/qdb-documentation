Persistence
**************************************************

Principle
=====================================================

Persistence is done using `LevelDB <http://code.google.com/p/leveldb/>`_. All software that is LevelDB compatible can process the quasardb persistence layer.

Entries are stored "as is", unmodified. The quasardb technology ensures that the most frequent entries stay in memory in a way that allows the serving of a very large amount of simultaneous requests (see :doc:`concurrency`).

All entries are persisted to disk as they are added and updated. When a put or add request has been processed, it is guaranteed that the persistence layer has fully acknowledged the modification. 

The persistence layer may compress data for efficiency purposes. This is transparent to the client and never done to the detriment of performances.

By default, the persistence layer uses a write cache to increase performance, but this can be disabled (see :doc:`../reference/qdbd`). When the write cache is disabled, the server will not return from a put or update request until the entry is acknowledged by the file system.

Eviction
=====================================================

Entries are evicted according to the configured thresholds (see :doc:`../reference/qdbd`).

Since entries are persisted to disk as they are added, an eviction cannot result in the entry being inaccessible.

Eviction is an atomic operation that respects the ACID properties of requests (see :doc:`concurrency`). 

An evicted entry stays on disk until requested at which point it is "paged in".

Entries are elected for eviction using a combination of statistics and probability (*fast monte carlo* algorithm).

Transient mode
=======================================

It is possible to disable persistence altogether (see :doc:`../reference/qdbd`). This is called the *transient* mode.

In this mode:

    * Performance may increase 
    * Memory usage may be reduced
    * Disk usage will be significantly lowered

But:

    * Evicted entries will be lost
    * Node failure may imply irrecoverable data loss

Transient mode is a clever way to transform a quasardb hive into a powerful cache.


