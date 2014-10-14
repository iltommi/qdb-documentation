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





Principles
----------

Server
^^^^^^

At the heart of many quasardb design and technology decisions lies the desire to solve the `C10k problem <http://en.wikipedia.org/wiki/C10k_problem>`_. To do so, quasardb uses a combination of asynchronous I/O, lock-free containers and parallel processing.

As of now, the server can serve as many concurrent requests as the operating system and the underlying hardware permit. 

The server will make sure that requests do not conflict with each other. It will spread the load across the entire processing power available, if need be.

The server automatically adjusts its multithreading configuration to the underlying hardware. No user intervention is required. Running several instances on the same node is counter-productive.

Multiple clients can simultaneously access the same entry for reading. The server will ensure that only one client accesses an entry for writing at any time.

Multiple clients can simultaneously access different entries for reading and writing.

Client
^^^^^^

All API are thread safe and synchronous unless otherwise noted.

When the client receives a reply from the server, the request is guaranteed to have been carried out by the server, as specified by the answer.

The client takes care of locating the proper node for the request. The client will either find the proper node or fail (this may happen if the ring is unstable, see :ref:`fault-tolerance`).

Guarantees
----------

     * All requests, unless otherwise noted, are atomic
     * All requests, unless otherwise noted, are consistent
     * All requests, unless otherwise noted, are isolated
     * All requests, unless otherwise noted, are durable (see :ref:`fault-tolerance`)
     * Once the server replies, it means the request has been fully carried on
     * Synchronous requests emanating from the same client are executed in order. However multiple requests coming from multiple clients are executed in an arbitrary order (see :ref:`conflicts-resolution`)

.. _conflicts-resolution:

Conflicts resolution
--------------------

When may a conflict occur?
^^^^^^^^^^^^^^^^^^^^^^^^^^

When executing a series of requests, each request is atomic, consistent, isolated and durable (ACID) and the requests will be executed in the given order.

For example, if a client adds an entry and later gets it, the get is guaranteed to succeed if the add was successful (unless an external error occurs, such as a low memory condition, a hardware or power failure, an operating system fault, etc.).

For example:

    * **Client A** *adds* an entry "car" and sets it to "roadster"
    * **Client A** *gets* the entry "car" and obtains the value "roadster"

However, in a multiclient context, conflicts may arise. What happens if a Client B updates the entry before Client A is finished?

    * **Client A** *adds* an entry "car" and sets it to "roadster"
    * **Client B** *updates* the entry "car" to "sedan"
    * **Client A** *gets* the entry "car" and obtains the value "sedan"

From the point of view of quasardb, everything is perfectly valid and coherent, but from the point of view of Client A, something is wrong!

How to use the API to avoid conflicts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Conflicts arise when **client usage is not carefully thought out**. Conflicts are a client's design problem, not a server problem.

On one hand it does not make sense to have clients simultaneously update the same entry and expect the value to be coherent. quasardb could leave it as is and require the client to have a coherent usage scenario.

On the other hand it's a shame the clients cannot rely on the power of quasardb to *at the very least detect* something is wrong.

That's why our API can help clients detect and even avoid conflicts (see :doc:`../api/index`).

The above can be avoided thanks to the way put works. Put fails if the entry already exist, therefore, our example becomes:

    * **Client A** *adds* an entry "car" and sets it to "roadster"
    * **Client B** *puts* the entry "car" and fails because the entry already exists
    * **Client A** *gets* the entry "car" and obtains the value "roadster"

Since updates always succeed, it is however possible to share a single value amongst different clients with the usage of the update command:

    * **Client A** *updates* the entry "stock3" to "503.5"
    * **Client B** *updates* the entry "stock3" to "504.5"
    * **Client A** *gets* the entry "stock3" and obtains the newest value "504.5"

As you can see what was previously considered a conflict is now the expected behaviour.

It is possible to create more complex scenarii thanks to the get_update and compare_and_swap commands. get_update atomically gets the previous value of an entry and updates it to a new one. compare_and_swap updates the value if it matches and returns the old/unchanged value.

.. tip:: Remember Ghostbusters: don't cross the streams.

Updating multiple entries at a time
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We've seen a trivial conflict case, but what about this one:

    * **Client A** *updates* an entry "car" and sets it to "roadster"
    * **Client A** *updates* an entry "motorbike" and sets it to "roadster"
    * **Client B** *gets* "car" and "motorbike" and checks that they match

As you can see, if Client B makes the query too early, it does not match. There are things you can do with get_update and compare_and_swap, but it can quickly become intricate and unmaintainable.

The one thing to understand is that it's a design usage problem on the client side.

    * Is it a problem for Client B to have a mismatch? Client B may try again later.
    * If you always need to update several entries and have those consistent, why have several entries?
    * Shouldn't be Client A and B be synchronized? That is, shouldn't Client B query the entry only once it knows they have been updated?

As you can see, a conflict is a question of context and usage.

The best way to avoid conflicts: plan out
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

quasardb provides several mechanisms to allow clients to synchronize themselves and avoid conflicts. However, the most important step to ensure proper operation is to plan out. What is a conflict? Is it a problem? Only a thorough plan can tell.

Things to consider:

    * Clients are generally heterogeneous. Some clients update content while other only consume content. It is simpler to design each client according to its purpose rather than writing a *one size fits all* client.
    * There is always an update delay, whatever system you're using. The question is, what delay can your business case tolerate? For example a high frequency trading automaton and a reservation system have different requirements.
    * The problem is never the conflict in itself. The problem is operating without realizing that there was a conflict in the first place.
    * quasardb provides ways to synchronize clients. For example, put fails if the entry already exists and update always succeed.
    * Last but not least, if you are trying to squeeze a schema into a non-relational database, disaster will ensue. A system such as quasardb generaly implies to rethink your modelization.





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
