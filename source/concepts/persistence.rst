Persistence
**************************************************

Principle
=====================================================

Persistence is done using `LevelDB <http://code.google.com/p/leveldb/>`_. All software that is LevelDB compatible can process the wrpme persistence layer.

Entries are stored "as is", unmodified. The wrpme technology ensures that the most frequent entries stay in memory in a way that allows the serving of a very large amount of simultenous requests (see :doc:`concurrency`).

All entries are persisted to disk as they are added and updated. When a put or add request has been processed, it is guaranteed that the persistence layer has fully acknowledged the persistence request. 

The persistence layer may compress data for efficency purposes. This is transparent to the client.

By default, the persistence layer uses a write cache to increase performance, but this can be disabled (see :doc:`../reference/wrpmed`). When the write cache is disabled, the server will not return from a put or update request until the entry has been actually persisted on disk.

Eviction
=====================================================

Entries are evicted according to the configured thresholds (see :doc:`../reference/wrpmed`).

Since entries are persisted to disk as they are added, an eviction cannot result in the entry being unaccessible.

Eviction is an atomic operation that respects the ACID properties of requests (see :doc:`concurrency`). 

An evicted entry stays on disk until requested at which point it is "paged in".

Entries are elected for eviction using a combination of statistics and probablity (*fast monte carlo* algorithm).

Transient mode
=======================================

It is possible to disable persistence alltogether (see :doc:`../reference/wrpmed`). This is called the *transient* mode.

In this mode:

    * Performance may increase 
    * Memory usage may be reduced
    * Disk usage will be significantely lowered

But:

    * Evicted entries are lost
    * Node failure may imply irrecoverable data loss

Transient mode is useful when wrpme is used as a cache.


