Data Storage
============

.. ### "Data Storage" Content Plan
	- Where is the data stored on the filesystem?
	- How is the data stored on the filesystem?
	- Where is the data stored within the cluster? (refer where appropriate to Data Transfer)
	- ACID guarantees
	- Data replication
	- Data storage performance
	- Any other relevant information from current Persistence page

Entries
---------

Each entry is assigned an unique ID. This unique ID is a `SHA-3 <http://en.wikipedia.org/wiki/SHA-3>`_ of the alias. 

The entry is then placed on the node whose ID is the :term:`successor` of the entry's ID. If replication is in place, the entry will also be placed on the successor's successor.

When a client queries the cluster, it locates the node who is the successor of the entry and queries that node.


Persistence
-----------

Persistence is done using `LevelDB <http://code.google.com/p/leveldb/>`_. All software that is LevelDB compatible can process the quasardb persistence layer.

Entries are stored "as is", unmodified. The quasardb ensures that the most frequently access entries stay in memory so it can rapidly serve a large amount of simultaneous requests.

.. # DEAD LINK: (see :doc:`concurrency`).

All entries are persisted to disk as they are added and updated. When a put or add request has been processed, it is guaranteed that the persistence layer has fully acknowledged the modification. 

The persistence layer may compress data for efficiency purposes. This is transparent to the client and never done to the detriment of performance.

By default, the persistence layer uses a write cache to increase performance, but this can be disabled (see :doc:`../reference/qdbd`). When the write cache is disabled, the server will not return from a put or update request until the entry is acknowledged by the file system.





.. _data-migration:

Data Migration
--------------

Data migration is the process of transferring entries from one node to another for the purpose of load balancing. Not to be confused with :ref:`data-replication`.

.. note::
    Data migration is always enabled.

Data migration only occurs when a new node joins the ring. Nodes may join a ring when:

    1. The administrator expands the cluster by adding new nodes
    2. A node recovers from failure and rejoins the ring

If the new node is the successor of keys already bound to another node, data migration will take place. Data migration occurs regardless of data replication, as it makes sure entries are always bound to the correct node.

.. ### EXAMPLE
   ### Consider a cluster of 3 nodes with IDs 3, 5, and 10. A fourth node is added with the ID of 8.


Migration Process
^^^^^^^^^^^^^^^^^
At the end of each stabilization cycle, a node will request its successor and its predecessor for entries within its range.

More precisely:

    1. N joins the ring by looking for its successor S
    2. N stabilizes itself, informing its successor and predecessor of its existence
    3. When N has both predecessor P and successor S, N request both of them for the [P; N] range of keys
    4. P and S send the requested keys, if any, one by one.

.. note::
    Migration speed depends on the available network bandwidth, the speed of the underlying hardware, and the amount of data to migrate. Therefore, a large amount of data (several gigabytes) on older hardware may negatively impact client performance.

During migration, nodes remain available and will answer to requests, however since migration occurs *after* the node is registered there is a time interval during which entries in migration may be temporarly unvailable (between steps #3 and #4).

Failure scenario:

    1. A new node *N* joins the ring, its predecessor is *P* and its successor is *S*
    2. A client looks for the entry *e*, it is currently bound to *S* but ought to be on *N*
    3. As *N* has joined the ring, the client correctly requests *N* for *e*
    4. N answers "not found" as *S* has not migrated *e* yet

Entry *e* will only be unavailable for the duration of the migration and does not result in a data loss. A node will not remove an entry until the peer has fully acknowledged the migration.

.. tip::
    Add nodes when the traffic is at its lowest point.





.. _data-replication:

Data replication
-----------------

Data replication is the process of duplicating entries across multiple nodes for the purpose of fault tolerance. Data replication greatly reduces the odds of functional failures at the cost of increased memory usage and reduced performance when adding or updating entries.

.. note::
    Replication is optional and disabled by default (see :doc:`../reference/qdbd`).

Principle
^^^^^^^^^^

Data is replicated on a node's successors. For example, with a factor two replication, an entry will be maintained by a node and by its successor. With a factor three replication, an entry will be maintained by a node and and by its two successors. Thus, replication linearly increases memory usage.

.. note::
    The replication factor is identical for all nodes of a cluster and is configurable (see :doc:`../reference/qdbd`). By default it is set to one (replication disabled).

The limit to this rule is for clusters with fewer nodes than the replication factor. For example, a two nodes cluster cannot have a factor three replication.

Replication is done synchronously as data is added or updated. The call will not successfully return until the data has been stored and fully replicated.

When a node fails and leaves the ring, data will be replicated on the new successor after stabilization completes. This means that simultaneous failures between two stabilizations may result in inaccessible entries (see :ref:`data-replication-reliability-impact`)

.. note::
    Since the location of the replication depends on the order of nodes, control of the physical location can be done through control of the nodes's id.

Benefits
^^^^^^^^^^

Replication main benefits are in the fields of reliability and resilience:

    * When adding a new node, data remains accessible during migration. The client will look up replicas should it fail to access the original entry (see :ref:`data-migration`)
    * When a node becomes unreachable, replicas will take over and service requests

How replication minimizes unavailability
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When a node becomes unavailable, the entries it was holding are no longer accessible for reading or writing. With replication, because the successor holds a complete copy of all its predecessor entries, all entries will be instantly accessible as soon as the ring is stabilized.

How replication works with migration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When a new node joins a ring, data is migrated (see :ref:`data-migration`). When replication is in place, the migration phase also includes a replication phase that consists in copying all the entries to the successor. Thus, replication increases the migration duration.

Conflict resolution
^^^^^^^^^^^^^^^^^^^^^

Because of the way replication works, an original and a replica entry cannot be simultenously edited. The client will always access the version considered the *original* entry and replicas are always overwritten in favor of the *original*.

A version is original if it belongs to the node range, if not, it is a replica. A replica becomes original when the range of the node changes. 

In other words, the client accesses the replica **after** ring stabilization. It does not attempt to directly read the entry of the successor. Therefore, replication is totally transparent to the client.

This comes at the cost of some unavailability. An when the ring is unstable and replicating entries.

Formally put, this means that quasardb may chose to sacrifice *Availability* for *Consistency* and *Partitionability* during short periods of time.

.. _data-replication-reliability-impact:

Impact on reliability
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For an entry x to become unavailable, all replicas must *simultaneously* fail.

More formally, given a :math:`\lambda(N)` failure rate of a node N, the mean time :math:`\tau` between failures of any given entry for an x replication factor is:

.. math::
    \tau:x \to \frac{1}{{\lambda(N)}^{x}}

This formula assumes that failures are unrelated, which is never completly the case. For example, the failure rates of blades in the same enclosure is correlated. However, the formula is a good enough approximation to exhibit the exponential relation between replication and reliability.

.. tip::
    A replication factor of two is a good compromise between reliability and memory usage as it gives a quadratic increase on reliablity while increasing memory usage by a factor two.

Impact on performance
^^^^^^^^^^^^^^^^^^^^^^^^

All add and update ("write") operations are :math:`\tau` slower when replication is active. Read-only operations are not impacted. 

Replication also increases the time needed to add a new node to the ring by a factor of at most :math:`\tau`.

.. tip::
    Clusters that mostly perform read operations greatly benefit from replication without any noticeable performance penalty.




.. # Stolen from reference/qdbd.rst

Replication
-----------

The replication factor (:option:`--replication`) is the number of copies for any given entry within the cluster. Each copy is made on a different node, this implies that a replication factor greater than the number of nodes will be lowered to the actual number of nodes.

The purpose of replication is to increase fault tolerance at the cost of decreased write performance.

For example a cluster of three nodes with a replication factor of four (4) will have an effective replication factor of three (3). If a fourth node is added, effective replication will be increased to four automatically.

By default the replication factor is one (1) which is equivalent to no replication. A replication factor of two (2) means that each entry has got a backup copy. A replication factor of three (3) means that each entry has got two (2) backup copies. The maximum replication factor is four (4).

When adding an entry to a node, the call returns only when the add and all replications have been successful. If a node part or joins the ring, replication and migration occurs automatically as soon as possible.

Replication is a cluster-wide parameter.






.. MOST of this belongs in cluster_organization; cherry-pick out the data sections.

.. _fault-tolerance:

Fault tolerance
---------------

quasardb is designed to be extremely resilient. All failures are temporary, assuming the underlying cause of failure can be fixed (power failure, hardware fault, driver bug, operating system fault, etc.). In most cases, simply repairing the cause of the failure then reconnecting the node to the cluster will resolve

However, there is one case where data may be lost:

    1. A node fails **and**
    2. Data is not replicated **and**
    3. The data was not persisted to disk **or** storage failed

The persistence layer is able to recover from write failures, which means that one write error will not compromise everything. It is also possible to make sure writes are synced to disks (see :doc:`../reference/qdbd`) to increase reliability further. 

Data persistence enables a node to fully recover from a failure and should be considered for production environments. Its impact on performance is negligible for clusters that mostly perform read operations.


Transient mode
^^^^^^^^^^^^^^

It is possible to disable persistence altogether (see :doc:`../reference/qdbd`). This is called the *transient* mode.

In this mode:

    * Performance may increase 
    * Memory usage may be reduced
    * Disk usage will be significantly lowered

But:

    * Evicted entries will be lost
    * Node failure may imply irrecoverable data loss

Transient mode is a clever way to transform a quasardb cluster into a powerful cache.




.. ### This is really more of a concurrency / sysadmin-wants-more-RAM thing than a disk thing. No data is changed here.
.. ### Consider moving elsewhere.


Eviction
--------

In order to achieve high performance, quasardb keeps as much data as possible in memory. However, a node may not have enough physical memory available to hold all of its entries. Therefore, you may enable an eviction limit, which will remove entries from memory when the cache reaches a maximum number of entries or a given size in bytes. Use :option:`--limiter-max-entries-count` (defaults to 100,000) and :option:`--limiter-max-bytes` (defaults to a half the available physical memory) options to configure these thresholds.

.. note::
    The memory usage (bytes) limit includes the alias and content for each entry, but doesn't include bookkeeping, temporary copies or internal structures. Thus, the daemon memory usage may slightly exceed the specified maximum memory usage.

The quasardb daemon chooses which entries to evict using a proprietary, *fast monte-carlo* heuristic. Evicted entries stay on disk until requested, at which point they are paged into the cache.


