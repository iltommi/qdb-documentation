Common principles
=================

All the API have been designed to be close the *way of thinking* of each programming language, but they share common principle. This chapter will give you a rapid overview of how the API works and the principles behind.

Error management
----------------

The API is based on return values. When an operation is successful, a function returns with the status qdb_e_ok. In Python and Java, errors are translated to exceptions.

Connection
----------

Prior to running any command, a connection to the cluster must be established. It is possible to either connect to a single node or to multiple node within the cluster.

Connecting to a single node is more simple and suitable for non-critical clients. Connecting to multiple nodes enables the client, at initialization, to try several different nodes should one fail. 

Once the connection is established, the client will lazily explore the ring as requests are made. 

Put vs update
--------------

When putting an entry, the call succeeds if the entry does not exist and fails if it already exists.
When updating an entry, the call always succeeds: if the entry does not exist, it will be created.

Atomicity
---------

Unless otherwise noted, all calls are atomic. When you return from a call, the data is persisted to disk (to the limit of what the operating system can guarantee in that aspect).

Memory management
-----------------

A lot of calls allocate memory on the client side. For example, when you get an entry, the calls allocate a buffer large enough to hold the entry for you. In C, the memory needs to be explicitly released. In C++, Java and Python, this is not necessary as a memory management mechanism is included with the API.

Expiry
------

Any entry within quasardb can have an expiry time. Once the expiry time is passed, the entry is removed and is no longer accessible. Through the API the expiry time precision is one second. Internally, quasardb clock resolution is operating system dependant, but often below 100 µs.

Expiry time can either be absolute (with the number of seconds relative to epoch) or relative (with the number of seconds relative to when the call is made). To prevent an entry from expirying, one provides a 0 absolute time. By default entries never expire. Specifying an expiry in the past results in the entry being removed. 

Modifying an entry in any way (via an update, removal, compare and swap operation...) resets the expiry to 0.

All absolute expiry time are UTC and 64-bit large, meaning there is no practical limit to an expiry time.

Iteration
---------

Iteration is unordered, that is, the order in which entries are returned is undefined. Every entry will be returned once: no entry may be returned twice.

If nodes become unavailable during the iteration, contents of those nodes may be skipped over, depending on the replication configuration of the cluster. 

If it is impossible to recover from an error during the iteration, the iteration will prematurely stop. It is the caller's decision to try again or give up.

The "current" state of the cluster is what is iterated upon, that is, no "snapshot" is made. If an entry is added during iteration it may, or may not, be included in the iteration, depending on its placement respective to the iteration cursor. It is planned to change this behaviour to allow "consistent" iteration in a future release.

