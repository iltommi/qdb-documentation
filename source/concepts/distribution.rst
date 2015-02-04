Distribution
**************************************************

Features
=====================================================

A quasardb cluster is a peer-to-peer distributed hash table based on `Chord <http://pdos.csail.mit.edu/chord/>`_. It has the following features:

    Distributed load
        The load is fairly and automatically distributed amongst the nodes of the cluster

    Optimized replica usage
        For reads, the nearest replica is used 
 
    Automatic configuration
        Nodes organize themselves and exchange data as needed

    Integrated replication
        Data can be replicated on several nodes for increased resilience

    Fault tolerance
        The failure of one or several nodes does not compromise the cluster
 
    Transparent topology
        A client queries the cluster from any node without any concern for performance


Principles
=====================================================

Nodes
-----------

To be properly operated a ring needs to be stable (see :ref:`fault-tolerance`).

A ring is stable when each node is connected to the proper :term:`successor` and :term:`predecessor`, that is, when all nodes are ordered by their respective ids. Each node requires an unique id that may either be automatically generated or given by the user (see :doc:`../reference/qdbd`).

If a node detects that its id is already in use, it will leave the ring.

Each node periodically checks the validity of its :term:`successor` and :term:`predecessor` and will adjust them if necessary. This process is called :term:`stabilization`.

Entries
---------

Each entry is assigned an unique ID. This unique ID is a `SHA-3 <http://en.wikipedia.org/wiki/SHA-3>`_ of the alias. 

The entry is then placed on the node whose ID is the :term:`successor` of the entry's ID. If replication is in place, the entry will also be placed on the successor's successor.

When a client queries the cluster, it locates the node who is the successor of the entry and queries that node.

Stabilization
---------------

Each node periodically "stabilizes" itself. 

Stabilizing means a node will exchange information with its neighbors in order to:

    * Make sure the neighbors (the :term:`successor` and the :term:`predecessor`) are still up and running
    * A new node isn't a better :term:`successor` than the existing one

In a sane, stable cluster, the time required to stabilize is extremely short and does not result in any modification. However, if one or several nodes fail or if new nodes join the cluster, stabilization will migrate data and change the neighbors (see :ref:`data-migration`).

Thus the stabilization duration depends on the amount of data to migrate, if any. Migrating data is done as fast as the underlying architecture permits.

The interval length between each stabilization can be anywhere between 1 (one) second and 2 (two) minutes.

When the node evaluates its neighbors in the cluster are stable, it will increase the duration between each stabilization check. On the contrary, when its neighbors are deemed *unstable*, the duration between stabilization checks will be reduced.

.. tip::
    Stabilization happens when bootstrapping a cluster, in case of failure or when adding nodes. It is transparent and does not require any intervention.

.. _data-migration:

Data migration
----------------

Migration Timing
^^^^^^^^^^^^^^^^

Data migration only occurs when a new node joins the ring. If the new node is the successor of keys already bound to another node, data migration will take place. Data migration occurs regardless of data replication, as it makes sure entries are always bound to the correct node.

.. note::
    Data migration is always enabled.

Nodes may join a ring when:

    1. In case of failure, when the node rejoins the ring upon recovery
    2. When the administrator expands the cluster by adding new nodes

Removing nodes does not cause data migration. Removing nodes results in inaccessible entries, unless data replication is in place (see :ref:`data-replication`).

Migration Process
^^^^^^^^^^^^^^^^^
At the end of each stabilization cycle, a node will request its successor and its predecessor for entries within its range.

More precisely:

    1. N joins the ring by looking for its successor S
    2. N stabilizes itself, informing its successor and predecessor of its existence
    3. When N has both predecessor P and successor S, N request both of them for the [P; N] range of keys
    4. P and S send the requested keys, if any, one by one.

.. note::
    Migration speed depends on the available network bandwidth. Therefore, a large amount of data (several gigabytes) to migrate may negatively impact performances.

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

Data replication greatly reduces the odds of functional failures at the cost of increased memory usage and reduced performance when adding or updating entries.

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

Usage
=====================================================

Building a cluster
------------------

To build a cluster, nodes are added to each other. A node only needs to know one other node within the ring (see :doc:`../tutorials/one_ring`). It is paramount to make sure that rings are not disjointed, that is, that all nodes will eventually join the same large ring. 

The simplest way to ensure this is to make all nodes initially join the same node. This will not create a single point of failure as once the ring is stabilized the nodes will properly reference each other.

If following a major network failure, a ring forms two disjointed rings, the two rings will be able to unite again once the underlying failure is resolved. This is because each node "remembers" past topologies.

Connecting to a cluster
------------------------

A client may connect to any node within the cluster. It will automatically discover the nodes as needed.

Recovering a node
--------------------

When a node recovers from failure, it needs to reference a peer within the existing ring to properly rejoin. The first node in a ring generally does not reference any other, thus, if the first node of the ring fails, it needs to be restarted with a reference to a peer within the existing ring.

.. _fault-tolerance:

Fault tolerance
=====================================================

Data loss
--------------

quasardb is designed to be extremely resilient. All failures are temporary, assuming the underlying cause of failure can be fixed (power failure, hardware fault, driver bug, operating system fault, etc.). 

However, there is one case where data may be lost:

    1. A node fails **and**
    2. Data is not replicated **and**
    3. The data was not persisted to disk **or** storage failed

The persistence layer is able to recover from write failures, which means that one write error will not compromise everything. It is also possible to make sure writes are synced to disks (see :doc:`../reference/qdbd`) to increase reliability further. 

Data persistence enables a node to fully recover from a failure and should be considered for production environments. Its impact on performance is negligible for clusters that mostly perform read operations.

Unstable state
-----------------

When a node fails, a segment of the ring will become unstable. When a ring's segment is unstable, requests might fail. This happens when:

    1. The requested node's :term:`predecessor` or :term:`successor` is unavailable **and**
    2. The requested node is currently looking for a valid :term:`predecessor` or :term:`successor`

In this context the node choses to answer to the client with an "unstable" error status. The client will then look for another node on the ring able to answer its query. If it fails to do so, the client will return an error to the user.

When a node joins a ring, it is in an unstable state until the join is complete.

That means that although a ring's segment may be unable to serve requests for a short period of time, the rest of the ring remains unaffected.

In a production environment, cluster segments may become unstable for a short period of time after a node fails. This temporary instability does not require human intervention to be resolved. 

.. tip::
    When a cluster's segment is unstable requests *might* temporarily fail. The probability for failure is exponentially correlated with the number of simultaneous failures.

Minimum number of working nodes required
-------------------------------------------

A cluster can successfully operate with a single node; however, the single node may not be able to handle all the load of the ring by itself. Additionally, managing node failures implies extra work for the nodes. Frequent failures will severely impact performances.

.. tip::
    A cluster operates best when more than 90% of the nodes are fully functional. Anticipate traffic growth and add nodes before the cluster is saturated.




