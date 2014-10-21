Data Transfer
=============

.. ### "Data Transfer" Content Plan
	- Connections between a client and the cluster
	- Network protocol and performance
	- An visual example of "get" - How the cluster determines where data is located
	- An visual example of "set" - How the cluster determines where data gets stored
	- Data Conflicts (reference Troubleshooting article)

.. ## TODO ##
.. ## Find a home for this. ##
.. ## Remove from data_storage.rst at that time. ##
   
   When are entries actually synced to disk?
   ------------------------------------------
   Entries are often kept resident in a write cache so the daemon can rapidly serve a large amount of simultaenous requests. When a user adds or updates an entry on the cluster the entry's value may not be synced to the disk immediately. However, quasardb guarantees the data is consistent at all times, even in case of hardware or software failure.
   
   If you need to guarantee that every cluster write is synced to disk immediately, disable the write cache by setting the "sync" configuration option to true. Disabling the write cache may have an impact on performance.


Designed for Concurrency
------------------------

Server
^^^^^^

At the heart of quasardb design and technology decisions lies the desire to solve the `C10k problem <http://en.wikipedia.org/wiki/C10k_problem>`_. To do so, quasardb uses a combination of asynchronous I/O, lock-free containers and parallel processing.

quasardb is developed in C++11 and assembly with performance in mind. The qdbd daemon is organized in a network of mini-daemons that exchange messages. This allows it to ensure low latency while scaling with server resources. qdbd can serve as many concurrent requests as the operating system and underlying hardware permit.

The concept of multithreading often implies locking access to a resource. Quasardb reduces locking to a minimum with the use of lock-free structures and transactional memory. Whenever possible, quasardb allocates memory on the stack rather than on the heap. If a heap allocation cannot be avoided, quasardb's zero-copy architecture makes sure no cycle is wasted duplicating data, unless it causes data contention.

The cluster will make sure that requests do not conflict with each other.
 * Only one client can write to a specific entry at a time.
 * Multiple clients can simultaenously read the same entry.
 * Multiple clients can simultaneously read and write to multiple, unique entries.

quasardb automatically scales its multithreading engine to the underlying hardware. No user intervention is required. Running several instances on the same node is counter-productive.


Client
^^^^^^

Clients are any piece of software using the quasardb API to create, read, update, or delete data on a quasardb cluster. Clients that are bundled with the quasardb daemon include qdbsh, qdb_httpd, qdb_dbtool, and qdb_comparison. You can also create your own custom clients using the C, C++, Java, Python, or .NET APIs.

All API calls are thread safe and synchronous unless otherwise noted in `the API documentation <../api/index>`_. When a client receives a reply from the server, the request is guaranteed to have been carried out by the server and replicated to all appropriate nodes.

The client takes care of locating the proper node for the request. The client will either find the proper node or fail (this may happen if the ring is unstable, see :ref:`fault-tolerance`).


Guarantees
----------

     * All requests, unless otherwise noted, are Atomic.
     * All requests, unless otherwise noted, are Consistent.
     * All requests, unless otherwise noted, are Isolated.
     * All requests, unless otherwise noted, are Durable.
     * Once the server replies, the request has been fully carried out.
     * Synchronous requests from the same client are executed in order.
     * Multiple requests from multiple clients are executed in an arbitrary order but can be mitigated through careful client design (see :ref:`conflicts-resolution`).



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

While this was a simple two-client example, the API also provides options for more complex scenarios, thanks to the get_update and compare_and_swap commands. get_update atomically gets the previous value of an entry and updates it to a new one. compare_and_swap updates the value if it matches and returns the old/unchanged value.  For more information, see the :doc:`../api/index`.


A more complex data conflict
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We've seen a trivial example, but what about this one:

    * **Client A** *updates* an entry "car" and sets it to "roadster"
    * **Client A** *updates* an entry "motorbike" and sets it to "roadster"
    * **Client B** *gets* "car" and "motorbike" and checks that they match

If Client B makes the query too early, the two entries do not match. While it's possible to resolve this using get_update and compare_and_swap, that can quickly become intricate and unmaintainable.

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


Networking
----------

Network I/O are done asynchronously for maximum performance. Most of the I/O framework is based on `Boost.Asio <http://www.boost.org/doc/libs/1_51_0/doc/html/boost_asio.html>`_.

Description
-----------

A client only needs to know the address of one node within the cluster. However, in order to access entries within the cluster, the node must be fully joined. Usually a node is fully joined within a few minutes of startup.

.. # DEAD LINK: For more information, see :doc:`./distribution`.

When a request is made, an ID is computed from the alias (with the `SHA-3 <http://en.wikipedia.org/wiki/Skein_(hash_function)>`_ algorithm) and the ring is explored to find the proper node. If the ring cannot be explored because it's too unstable, the client will return an "unstable" error code (see :ref:`fault-tolerance`).

Once the proper node has been found, the request is sent. 

If the topology has changed between the time the node has been found and the request has been made, the target node will return a "wrong node" error to the client, and the client will search again for the valid node.

A client attempts to locate the valid node only three times. In other words, three consecutive errors will result in a definitive error returned to the user.

Data management
---------------

Data is sent and stored "as is", bit for bit. The user may add any kind of content to the quasardb cluster, provided that the nodes have sufficient storage space. quasardb uses a low-level binary protocol that adds only few bytes of overhead per request.

The persistence layer may compress data for efficiency purposes. This is transparent to the client.

Most high levels API support the language native serialization mechanism to transparently add and retrieve objects to/from a quasardb cluster (see :doc:`../api/index`).

Metadata is associated with each entry. The quasardb cluster ensures the metadata and the actual data are consistent at all time. 

.. note::
    It is currently not possible to obtain the metadata via the API.

Timeout
-------

If the server does not reply to the client in the specified delay, the client will drop the request and return a "timeout" error code. This timeout is configurable and defaults to one minute.


Streaming
---------

Motivation
^^^^^^^^^^

quasardb can store entries of arbitrary size, limited only by the hardware capabilities of the cluster's node. However, the server capability often exceeds the client's capability, especially in terms of memory.

Additionally, the client may wish to consume the content as soon as possible. 

For example, if you use a quasardb cluster to store digital videos and clients are video players, it is expected to be able to display the video as you download it.

Usage
^^^^^

.. note:: The streaming API is currently only available in C (see :doc:`../api/c`), support for other languages will be added in future releases. One can currently stream entry *from* the server, but not *to* the server.

The typical usage scenario is the following:

    #. A client opens a streaming handle for a given entry. The default buffer size is 1 MiB. If it is inappropriate, it needs to be set *before* opening the streaming handle via the appropriate API call.
    #. The client reads content for the entry. The API automatically reads the next chunk of available data. The result of the read is placed in the API allocated buffer.
    #. The client processes the buffer. For example, it may send the buffer to a video decoder.
    #. The client may manually set the offset if need be. Positioning the offset beyond the end results in an error.
    #. The client stops reading when the offset reaches the end. Reading beyond the end will result in an error.
    #. The client closes the handle. This frees all resources.

.. important::
    The streaming buffer is allocated by the API. The client should only read from the buffer and never attempt to free it manually. All resources are freed when the streaming handle is closed.

Conflicts
^^^^^^^^^

By design, streaming an entry does not "lock" access to this entry. This is to prevent a client that does not properly close its streaming handle to "lock out" an entry.

Therefore, streaming is one of the rare operations that is not ACID. When you stream an entry from the server, if this entry is updated by another client, the next call will result in a "conflicting operation" error and streaming will no longer be possible.

The client must therefore close its streaming handle and reopen a new one to resume streaming. It may set the offset to the previous position if need be (and if the updated entry is large enough to support the operation).

If another client removes the entry as you stream it, the next call will result in a "not found" error and streaming will no longer be possible.


.. Rework this so it refers to "what happens when a query comes in during stabilization"

Unstable state
^^^^^^^^^^^^^^

When a node fails, a segment of the ring will become unstable. When a ring's segment is unstable, requests might fail. This happens when:

    1. The requested node's predecessor or successor is unavailable **and**
    2. The requested node is currently looking for a valid predecessor or successor

In this context the node choses to answer to the client with an "unstable" error status. The client will then look for another node on the ring able to answer its query. If it fails to do so, the client will return an error to the user.

When a node joins a ring, it is in an unstable state until the join is complete.

That means that although a ring's segment may be unable to serve requests for a short period of time, the rest of the ring remains unaffected.

In a production environment, cluster segments may become unstable for a short period of time after a node fails. This temporary instability does not require human intervention to be resolved. 

.. tip::
    When a cluster's segment is unstable requests *might* temporarily fail. The probability for failure is exponentially correlated with the number of simultaneous failures.


Eviction
--------

In order to achieve high performance, quasardb keeps as much data as possible in memory. However, a node may not have enough physical memory available to hold all of its entries. Therefore, you may enable an eviction limit, which will remove entries from memory when the cache reaches a maximum number of entries or a given size in bytes. Use :option:`--limiter-max-entries-count` (defaults to 100,000) and :option:`--limiter-max-bytes` (defaults to a half the available physical memory) options to configure these thresholds.

.. note::
    The memory usage (bytes) limit includes the alias and content for each entry, but doesn't include bookkeeping, temporary copies or internal structures. Thus, the daemon memory usage may slightly exceed the specified maximum memory usage.

The quasardb daemon chooses which entries to evict using a proprietary, *fast monte-carlo* heuristic. Evicted entries stay on disk until requested, at which point they are paged into the cache.


