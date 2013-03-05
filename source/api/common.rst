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

A lot of calls allocate memory on the client side. For example, when you get an entry, the calls allocate a buffer large enough to hold the entry for you. In C, the memory needs to be explicitely released. In C++, Java and Python, this is not necessary as a memory management mechanism is included with the API.

