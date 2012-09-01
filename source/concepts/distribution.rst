Distribution
**************************************************

Features
=====================================================

A wrpme hive is a peer-to-peer distributed hash table based on `Chord <http://pdos.csail.mit.edu/chord/>`_. It has the following features:

    Distributed load
        The load is fairly and automatically distributed amongst the nodes of the hive
 
    Automatic configuration
        Nodes organize themselves and exchange data as needed

    Integrated replication
        Data can be replicated on several nodes for increased resilience

    Fault tolerance
        The failure of one or several nodes does not compromise the hive
 
    Transparent topology
        A client queries the hive from any node without any concern for performance


Principles
=====================================================

Nodes
-----------

To be properly operated a ring needs to be stable (see :ref:`fault-tolerance`).

A ring is stable when each node is connected to the proper :term:`successor` and :term:`predecessor`, that is, when all nodes are ordered by their respective ids. Each node requires an unique id that may either be automatically generated or given by the user (see :doc:`../reference/wrpmed`).

If a node detects that its id is already in use, it will part the ring.

Each node periodically checks the validity of its :term:`successor` and :term:`predecessor` and will adjust them if necessary. This process is called :term:`stabilization`.

Entries
---------

Each entry is assigned an unique ID. This unique ID is a `SHA-3 <http://en.wikipedia.org/wiki/Skein_(hash_function)>`_ of the alias. 

The entry is then placed on the node whose ID is the :term:`successor` of the entry's ID. If replication is in place, the entry will also be placed on the successor's successor.

When a client queries the hive, it locates the node who is the successor of the entry and queries that node.

Stabilization
---------------

Each node periodically "stabilizes" itself. 

Stabilizing means a node will exchange information with its neighbourgs in order to:

    * Make sure the neighbors (the :term:`successor` and the :term:`predecessor`) are still up and running
    * A new node isn't a best :term:`successor` that the existing one

In a sane, stable cluster, stabilization is extremely short and does not result in any modification. However, if one or several node fail or new nodes join the hive, stabilization will migrate keys and change the neighbors (see :ref:`data-migration`).

Thus the stabilization duration depends on the amount of data to migrate, if any. Migrating data is done as fast as the underlying architecture permits.

The interval length between each stabilization is between 1 (one) second and 2 (two) minutes.

When the node evaluates its surrounding to be stable, it will increase the duration between each stabilization. On the contrary, when the surrounding are deemed *unstable* this duration will be reduced.

.. tip::
    Stabilization happens when bootstrapping a hive, in case of failure or when adding nodes. It is transparent and does not require any intervention.

.. _data-migration:

Data migration
----------------

When a new node joins the ring, it may imply data migration. Data migration occurs if the new node is the successor of keys already bound to another node. Data migration occurs regardless of replication as it makes sure entries are always bound to the correct node.

.. note::
    Data migration is always enabled. 

At the end of each stabilization cycle, a node will request its successor and its predecessor for entries within its range.

More precisely:

    1. N joins the ring by looking for its successor S
    2. N stabilizes itself, informing its successor and predecessor of its existence
    3. When N has got both predecessor P and successor S, N request both of them for the ]P; N] range of keys
    4. P and S send the requested keys, if any, one by one. 

.. note::
    Migration speed depends on the available network bandwidth, therefore, a large amount (several gigabytes) of data to migrate may negatively impact performances.

During migration nodes remain available and will answer to requests, however since migration occurs *after* the node is registered there is a time interval during which entries in migration may be temporarly unvailable (between step #3 and #4).

Failure scenario:

    1. A new node *N* joins the ring, its predecessor is *P* and tits successor *S*
    2. A client looks for the entry *e*, it is currently bound to *S* but ought to be on *N*
    3. As *N* has joined the ring, the client correctly requests *N* for *e*
    4. N answers "not found" as *S* has not migrated e yet

This unvailability is only for the duration of the migration and cannot result in a data loss. This is because a node will not remove an entry until the peer fully acknowledged the migration.

.. tip::
    Add nodes when the trafic is at its lowest point.

Migration only occurs when a new node joins the ring. This happens only:

    1. In case of failure, when the node rejoins the ring upon recovery
    2. When the administrator expands the hive by adding new nodes

Removing nodes does not cause data migration. Removing nodes results in unaccessible entries, unless replication is in place (see :ref:`data-replication`).

.. _data-replication:

Data replication
-----------------

Data replication greatly reduces the odds of functional failures at the cost of increased memory usage and reduced performances when adding or updating.

.. note::
    Replication is optional and disabled by default (see :doc:`../reference/wrpmed`).

Principle
^^^^^^^^^^

Data is replicated on a node's successors. For example with a factor two replication, an entry will be maintained by a node and by its successor. With a factor three replication, an entry will be maintained by a node and and by its two successors. Thus, replication linearly increases memory usage.

.. note::
    The replication factor is identical for all nodes of a hive and is configurable (see :doc:`../reference/wrpmed`). By default it is set to one (replication disabled).

The limit to this rule is for hives with fewer nodes than the replication factor. For example, a two nodes hive cannot have a factor three replication.

Replication is done synchronously as data is added or updated. The call will not successfully return until the data has been stored and fully replicated.

When a node fails, data will be replicated on the new successor after stabilization completes. This means that simultaneous failures between two stabilizations may result in inaccessible entries (see :ref:`data-replication-reliability-impact`)

.. note::
    Since the location of the replication depends on the order of nodes, control of the physical location can be done via a control of the nodes's id.

Benefits
^^^^^^^^^^

Replication main benefits are in the fields of reliability and resilience:

    * When adding a new node, data remains accessible during migration. The client will look on replicas should it fail accessing the original entrie (see :ref:`data-migration`)
    * When a node becomes unreachable, replicas will take over and service requests

How replication minimizes unavailability
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When a node becomes unavailable, the entries it was holding are no longer accessible for reading or writing. With replication, as the successor holds a complete copy of all its predecessor entries, all entries will be instantly accessible as soon as the ring is stabilized.

How replication works with migration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When a new node joins a ring, data is migrated (see :ref:`data-migration`). When replication is in place, the migration phase also includes a replication phase that consists in copying all the entries to the successor. Thus, replication increases the migration duration.

Conflicts resolution
^^^^^^^^^^^^^^^^^^^^^^

The way replication work, an original and a replica cannot be simultenously edited. The client will always access the version considered *original* and replicas are always overwritten in favor or the considered *original*.

A version is original if it belongs to the node range, if not, it is a replica. A replica becomes original when the range of the node changes. 

In other words, the client access the replica **after** ring stabilization. It does not attempt to directly read the entry at the successor: replication is totally transparent to the client.

This comes at the cost that an entry may be unavailable when the ring is in unstable phase.

Formally put, this means that wrpme may chose to sacrifice *Availability* for *Consistency* and *Partionability* during short periods of time.

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
    *Read-mostly* hives greatly benefit from replication without any noticeable performance penalty.

Usage
=====================================================

Building a hive
----------------

To build a hive, nodes are added to each other. A node only needs to know one other node within the ring (see :doc:`../tutorials/one_ring`). It is paramount to make sure that rings are not disjoint, that is, that all nodes will eventually join the same large ring. 

The simplest way to ensure this is to make all nodes initially join the same node. This will not create a single point of failure as once the ring is stabilized the nodes will properly reference each other.

If following to a major network failures a ring forms two disjoint rings, the two rings will be able to unite again once the underlying failure is resolved. This is because each node "remembers" past topologies.

Connecting to a hive
------------------------

A client may connect to any node within the hive. It will automatically discover the nodes as needed.

Recovering a node
--------------------

When a node recovers from failure, it needs to reference a peer within the need to properly rejoin. The first node in a ring generally does not reference any other, thus, if the first node of the ring fails, it needs to be restarted with a reference to a peer within the existing ring.

.. _fault-tolerance:

Fault tolerance
=====================================================

Data loss
--------------

wrpme is designed to be extremely resilient. All failures are temporary, assuming the underlying cause of failure can be fixed (power failure, hardware fault, driver bug, operating system fault, etc.). 

However, there is one case where data may be lost:

    1. A node fails **and**
    2. Data is not replicated **and**
    3. The data was not persisted to disk **or** storage failed

The persistence layer is able to recover from write failures, which means that one write error will not compromise everything. It is also possible to make sure writes are synced to disks (see :doc:`../reference/wrpmed`) to increase reliability further. 

Data persistence enables a node to fully recover from a failure and should be considered for production environments. Its impact on performance is negligible for *read-mostly* hives.

Unstable state
-----------------

When a node fails, a segment of the ring will become unstable. When a ring's segment is unstable, requests might fail. This happens when:

    1. The requested node's :term:`predecessor` or :term:`successor` is unavailable **and**
    2. The requested node is currently looking for a valid :term:`predecessor` or :term:`successor`

In this context the node choses to answer to the client with an "unstable" error status. The client will then look for another node on the ring able to answer its query. If it fails to do so, the client will return an error to the user.

When a node joins a ring, it is in an unstable state until the join is complete.

That means that although a ring's segment may be unable to serve requests for a short period of time, the rest of the ring remains unaffected.

In a production environment, hive segments may become unstable for a short period of time after a node fails. This temporary instability does not require human intervention to be resolved. 

.. tip::
    When a hive's segment is unstable requests *might* temporarily fail. The probability for failure is exponentially correlated with the number of simultaneous failures.

Minimum number of working nodes required
-------------------------------------------

A hive can successfully operate with a single node; however, the single node may not be able to handle all the load of the ring by itself. Additionally, managing nodes failures implies extra work for the nodes. Frequent failures will severely impact performances.

.. tip::
    A hive operates best when more than 90% of the nodes are fully functional. Anticipate traffic growth and add nodes before the hive is saturated.




