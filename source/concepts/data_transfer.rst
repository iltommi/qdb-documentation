Data Transfer
=============

Designed for Concurrency
------------------------

At the heart of quasardb design and technology decisions lies the desire to solve the `C10k problem <http://en.wikipedia.org/wiki/C10k_problem>`_. To do so, quasardb uses a combination of asynchronous I/O, lock-free containers and parallel processing.

Server
^^^^^^

quasardb is developed in C++11 and assembly with performance in mind. The qdbd daemon is organized in a network of mini-daemons that exchange messages. This allows it to ensure low latency while scaling with server resources. qdbd can serve as many concurrent requests as the operating system and underlying hardware permit.

Network I/O operations are done asynchronously for maximum performance. Most of the I/O framework is based on `Boost.Asio <http://www.boost.org/doc/libs/1_51_0/doc/html/boost_asio.html>`_.

The concept of multithreading often implies locking access to a resource. Quasardb reduces locking to a minimum with the use of lock-free structures and transactional memory. Whenever possible, quasardb allocates memory on the stack rather than on the heap. If a heap allocation cannot be avoided, quasardb's zero-copy architecture makes sure no cycle is wasted duplicating data, unless it causes data contention.

The cluster will make sure that requests do not conflict with each other.
 * Only one client can write to a specific entry at a time.
 * Multiple clients can simultaenously read the same entry.
 * Multiple clients can simultaneously read and write to multiple, unique entries.

As of quasardb 1.2.0, if the cluster uses :ref:`data-replication`, read queries are automatically load-balanced. Nodes containing replicated entries may respond instead of the original node to provide faster lookup times.

quasardb automatically scales its multithreading engine to the underlying hardware. No user intervention is required. Running several instances on the same node is counter-productive.


Client
^^^^^^

Clients are any piece of software using the quasardb API to create, read, update, or delete data on a quasardb cluster. Clients that are bundled with the quasardb daemon include qdbsh, qdb_httpd, qdb_dbtool, and qdb_comparison. You can also create your own custom clients using the C, C++, Java, Python, or .NET APIs.

All API calls are thread safe and synchronous unless otherwise noted in the :doc:`../api/index`. When a client receives a reply from the server, the request is guaranteed to have been carried out by the server and replicated to all appropriate nodes.


Guarantees
----------

     * All requests, unless otherwise noted, are Atomic.
     * All requests, unless otherwise noted, are Consistent.
     * All requests, unless otherwise noted, are Isolated.
     * All requests, unless otherwise noted, are Durable.
     * Once the server replies, the request has been fully carried out.
     * Synchronous requests from the same client are executed in order.
     * Multiple requests from multiple clients are executed in an arbitrary order but can be mitigated through careful client design (see :ref:`conflicts-resolution`).


.. _transfer-process:

The Transfer Process
--------------------

Once a cluster has completed :ref:`stabilization`, a client only needs to connect to a single node in the cluster. The client can then send data requests for entries stored across the cluster.

When you store an entry in a cluster:

    #. The client computes the entry's UUID using the `SHA-3 <http://en.wikipedia.org/wiki/Skein_(hash_function)>`_ algorithm.
    #. The client searches the cluster for the node that should store the original entry.
    #. The client sends the data to the node.
    #. The cluster replicates the data as necessary, then responds with OK.

Data is sent and stored "as is", bit for bit. quasardb uses a low-level binary protocol that adds only few bytes of overhead per request. There is no limit on the amount or type of data you can send or receive during a transfer, provided that the cluster has sufficient storage space.

Most high levels API support the language native serialization mechanism to transparently add and retrieve objects to/from a quasardb cluster (see :doc:`../api/index`).


Failure Cases
-------------

Cluster Unstable
^^^^^^^^^^^^^^^^

If the cluster is unstable (see :ref:`stabilization`) because of node failure or reorganization, client requests may temporarily fail. A node searching for its predecessor or successor will return an "unstable" error code. When this occurs, clients attempt to find another node on the ring with a replicated entry. If no replicated entry can be found, the client will return an error to the user.

Topology Changed
^^^^^^^^^^^^^^^^

If the cluster topology has changed between when the node was found and the data request was sent, the data request may temporarily fail. In this case, the target node will return a "wrong node" error and the client will repeat the node search. Three consecutive "wrong node" errors will result in an error returned to the user.

Timeout
^^^^^^^

If the node does not reply to the client in the specified delay, the client will drop the request and return a "timeout" error code. The client timeout is configurable using the qdb API and defaults to one minute.



.. _conflicts-resolution:

Data Conflicts
--------------

A simple data conflict
^^^^^^^^^^^^^^^^^^^^^^

Conflicts usually occur when a client program is not designed for or used in a manner that scales with multiple, simultaneous clients.

For example, if a client adds an entry and later gets it, the get is guaranteed to succeed if the add was successful (barring an external error such as low memory, a hardware or power failure, an operating system fault, etc.).

    * **Client A** *puts* an entry "car" with the value "roadster"
    * **Client A** *gets* the entry "car" and obtains the value "roadster"

However, in a multiclient context, a simple set and get operation may cause a data conflict. What happens if a Client B updates the entry before Client A is finished?

    * **Client A** *puts* an entry "car" with the value "roadster"
    * **Client B** *updates* the entry "car" with the value "sedan"
    * **Client A** *gets* the entry "car" and obtains the value "sedan"

From the point of view of the quasardb server, the data is perfectly valid and coherent, but from the point of view of Client A, something is wrong!

Resolving the simple conflict
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

One way we could avoid the problem above is to change client B to use the "put" command. The "put" command fails if the entry already exists. Client A receives the data it expects, Client B receives an exception, and both can act on that data appropriately:

    * **Client A** *puts* an entry "car" and sets it to "roadster"
    * **Client B** *puts* the entry "car" and fails because the entry already exists
    * **Client A** *gets* the entry "car" and obtains the value "roadster"

Alternately, if the entry is intended to change regularly, like a value in a stock market ticker, client A could be rewritten so it does not error when the data is not what it expects:

    * **Client A** *updates* the entry "stock3" to "503.5"
    * **Client B** *updates* the entry "stock3" to "504.0"
    * **Client A** *gets* the entry "stock3" and obtains the newest value "504.0"

In either case, what was previously considered a conflict is now the expected behaviour.

While this was a simple two-client example, the API also provides options for more complex scenarios, thanks to the get_and_update and compare_and_swap commands. get_and_update atomically gets the previous value of an entry and updates it to a new one. compare_and_swap updates the value if it matches and returns the old/unchanged value.  For more information, see the :doc:`../api/index`.


A more complex data conflict
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We've seen a trivial example, but what about this one:

    * **Client A** *updates* an entry "car" and sets it to "roadster"
    * **Client A** *updates* an entry "motorbike" and sets it to "roadster"
    * **Client B** *gets* "car" and "motorbike" and checks that they match

If Client B makes the query too early, the two entries do not match. While it's possible to resolve this using get_and_update and compare_and_swap, that can quickly become intricate and unmaintainable.

Like above, this is a design usage problem on the client side.

    * Should Client B fail if it receives a mistmatch?
    * Can Client B timeout and try again later?
    * If several entries must be consistent, can those entries be with a single entry?
    * Can Client A and B be synchronized? That is, can Client B query the entries once it knows Client A has completed updating them?

As you can see, a conflict is a question of context and usage.

Best Practice: Plan for Concurrency
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The quasardb client API provides several mechanisms to allow clients to synchronize themselves and avoid conflicts. However, the most important step to ensure proper operation is to plan. What is the potential conflict? Is it a problem? Can it be mitigated or worked around?

Things to consider:

    * Clients are generally heterogeneous. Some clients update content while other only consume content. It is simpler to design each client according to its purpose rather than writing a *one size fits all* client.
    * There is always an update delay, no matter how powerful your nodes are or how big your cluster is. The question is, what delay can your business case tolerate? A high frequency trading automaton and a reservation system will have different latency requirements.
    * The problem is never the conflict in itself. The problem is clients operating without realizing that there was a conflict in the first place.
    * The quasardb API provides ways to synchronize clients or detect concurrency issues. For example, "put" fails if the entry already exists, "update" always succeds, and "compare_and_swap" can provide a conditional "put".
    * Last but not least, trying to squeeze a schema into a non-relational database will result in disaster. A non-relational system such as quasardb will likely require you to rethink your data model.


