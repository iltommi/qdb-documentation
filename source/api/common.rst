Common principles
=================

.. cpp:namespace:: qdb
.. highlight:: cpp

The APIs have been designed to be close to the *way of thinking* of each programming language, but they share common principles. This chapter will give you a rapid overview of how the API works and the principles behind each language binding.

Connection
----------

Prior to running any command, a connection to the cluster must be established. It is possible to either connect to a single node or to multiple nodes within the cluster.

Connecting to a single node is more simple and suitable for non-critical clients. Connecting to multiple nodes enables the client, at initialization, to try several different nodes should one fail.

Once the connection is established, the client will lazily explore the ring as requests are made.

.. _common.aliases:

Aliases
-------

Each entry in the database (a blob, an integer, a deque...) has a user-defined unique identifier: an alias (or a key).

The following restrictions apply:

 * Aliases must be valid, null-terminated UTF-8 strings
 * Aliases must not be empty
 * The length must not exceed 1,024 *bytes*

Put vs update
--------------

When putting an entry, the call succeeds if the entry does not exist and fails if it already exists.
When updating an entry, the call always succeeds: if the entry does not exist, it will be created.

Atomicity
---------

Unless otherwise noted, all calls are atomic. When a call returns, you can be assured the data has been persisted to disk (to the limit of what the operating system can guarantee in that aspect).

Data Types
----------

See :doc:`../concepts/data_types`.

Tags
----

See :doc:`../concepts/tags`.

Memory management
-----------------

A lot of calls allocate memory on the client side. For example, when you get an entry, the calls allocate a buffer large enough to hold the entry for you. In C, the memory needs to be explicitly released. In C++, Java and Python, this is not necessary as a memory management mechanism is included with the API.

Error management
----------------

Most success and failure conditions are based on return values. When an operation is successful, a function returns with the status :c:macro:`qdb_e_ok<qdb_error_t>`. Other error types are returned as a value from the :c:macro:`qdb_error_t` enum, which can be examined using the :c:macro:`QDB_SUCCESS(qdb_error_t)<QDB_SUCCESS>`, :c:macro:`QDB_FAILURE(qdb_error_t)<QDB_FAILURE>` and :c:macro:`QDB_ERROR_SEVERITY(qdb_error_t)<QDB_ERROR_SEVERITY>` macros.

Transient errors may resolve by themselves given time. Transient errors are commonly transaction conflicts, network timeouts, or an unstable cluster.

An informational error means that the query has been succesfully processed by the server and your parameters were valid but the result is either empty or unavailable. Informational errors include non-existent entries, empty collections, indexes out of range, or integer overflow/underflows.

If the language supports exceptions, like .NET, Python, and Java, errors are translated to exceptions.


Automatic Load Balancing
------------------------

As of quasardb 1.2.0, if the cluster uses :ref:`data.replication`, read queries are automatically load-balanced. Nodes containing replicated entries may respond instead of the original node to provide faster lookup speed.

Expiry
------

Any entry within quasardb can have an expiry time. Once the expiry time is passed, the entry is removed and is no longer accessible. Through the API the expiry time precision is one millisecond. Internally, quasardb clock resolution is operating system dependant, but often below 100 µs.

Expiry time can either be absolute (with the number of milliseconds relative to epoch) or relative (with the number of milliseconds relative to when the call is made). To prevent an entry from expiring, one provides the predefined "never expires" value. By default entries never expire. Specifying an expiry slightly in the past (couple of minutes) results in the entry being removed. If the expiry is more than a couple of minutes in the past, it is considered invalid.

Modifying an entry in any way (via an update, removal, compare and swap operation...) resets the expiry to 0 unless otherwise specified.

All absolute expiry times are UTC and 64-bit large, meaning there is no practical limit to an expiry time.

Iteration
---------

Iteration is unordered, that is, the order in which entries are returned is undetermined. Every entry will be returned once: no entry may be returned twice.

If a node becomes unavailable during iteration, the contents stored on that node may be skipped over, depending on the replication configuration of the cluster.

If it is impossible to recover from an error during the iteration, the iteration will prematurely stop. It is the caller's decision to try again or give up.

The "current" state of the cluster is what is iterated upon. No "snapshot" is made. If an entry is added during iteration it may, or may not, be included in the iteration, depending on its placement respective to the iteration cursor. It is planned to change this behaviour to allow "consistent" iteration in a future release.

.. note::
    Entries cannot be iterated if the cluster is in transient mode.

Batch operations
----------------

Introduction
^^^^^^^^^^^^^^

If you have used quasardb to manage small entries (that is entries smaller than 1 KiB) you certainly have noticed that performance isn't as good as with larger entries. The reason for this is that whatever optimizations we might put into quasardb, every time you request the cluster, the request has to go through the network back and forth.

Assuming that you have a 1 ms latency between the client and the server, if you want to query 1,000 entries sequentially it will take you at least 2 seconds, however small the entry might be, however large the bandwidth might be.

Batch operations solve this problem by enabling you to group multiple queries into a single request. This grouping can speed up processing by several orders of magnitude.

C++ Example
^^^^^^^^^^^^

How to query the content of many small entries at once? If we assume we have a vector of strings containing the entries named "entries" getting all entries is a matter of building the batch and running it::

    // we assume the existence and correctness of std::vector<std::string> entries;
    std::vector<qdb_operations_t> operations(entries.size());

    std::transform(entries.begin(), entries.end(), operations.begin(), [](const std::string & str) -> qdb_operation_t
    {
        qdb_operation_t op;

        // it is paramount that unused parameters are set to zero
        memset(&op, 0, sizeof(op));
        op.error = qdb_e_uninitialized; // this is optional
        op.type = qdb_op_get_alloc; // this specifies the kind of operation we want
        op.alias = str.c_str();

        return op;
    });

    // we assume a properly initialized qdb::handle named h
    size_t success_count = h.run_batch(&operations[0], operations.size());
    if (success_count != operations.size())
    {
        // error management
        // each operation will have its error member updated properly
    }

Each result is now available in the "result" structure member and its size is stored in the "result_size". This an API allocated buffer. Releasing all memory is done in the following way::

    qdb_free_operations(h, &operations[0], operations.size());
    operations.clear();

Limitations
^^^^^^^^^^^^

    * The order in which operations in a batch are executed is undefined
    * Each operation in a batch is ACID, however the batch as a whole is neither ACID nor transactional
    * Running a batch adds overhead. Using the batch API for small batches may therefore yield unsatisfactory performance

Allowed operations
^^^^^^^^^^^^^^^^^^^^

Batches may contain any combination of gets, puts, updates, removes, compare and swaps, get and updates (atomic), get and removes (atomic) and conditional removes.

.. warning::
    Since the execution order is undetermined, it is strongly advised to avoid dependencies within a single batch. For performance reasons the API doesn't perform any semantic check.

Error management
^^^^^^^^^^^^^^^^^^

Each operation receives a status, independent from other operations. If for some reason the cluster estimates that running the batch may be unsafe or unreliable, operations may be skipped and will have the :c:macro:`qdb_e_skipped<qdb_error_t>` error code. This can also happen in case of a global error (unstable ring, low memory condition) or malformed batch.

A batch with an invalid request or an invalid number of operations is considered malformed as a whole and ignored. This is because quasardb considers that a batch with invalid entries is probably erroneous as a whole and even requests that look valid should not be run as a precaution.

For example, if you submit a batch of put operations and one of the operations has an invalid parameter (for example an empty alias), the whole batch will be in error. The operation with the invalid parameter will have the :c:macro:`qdb_e_invalid_argument<qdb_error_t>` error code and other operations will have the :c:macro:`qdb_e_skipped<qdb_error_t>` error code.

Complexity
^^^^^^^^^^^^

Batch operations have three stages:

    1. Mapping - The API maps all operations to the proper nodes in making all necessary requests. This phase, although very fast, is dependant on the cluster size and has a worst case of three requests per node.
    2. Dispatching - The API sends groups of operations in optimal packets to each node. This phase is only dependant on the size of the batch.
    3. Reduction - Results from the cluster are received, checked and reduced. This phase is only dependant on the size of the batch.

Formally, if you consider the first phase as a constant overhead, the complexity of batch operations, with :math:`i` being the number of operations inside a batch is:

.. math::
    O(i)

.. note::
    Because of the first phase, running batches that are smaller than three times the size of the cluster may not yield the expected performance improvement. For example, if you cluster is 10 nodes large, it is recommended to have batches of at least 30 operations.

Summary
^^^^^^^^^^

Used properly, batch operations can turn around performance and enable you to process extremely fast large sets of small operations.

Transactions
-------------

quasardb supports distributed, multi-entry key transactions. The transaction API is very close to the batch API, with the exceptions that:

    * Operations are executed in order.
    * Transactions are "all or nothing", if one operation fails, the whole transaction is rolled back.
    * Transactions are generally slower than batches.

quasardb transactions are based on Multi-Version Concurrency Control and two-phase commit (2PC).

Limitations
^^^^^^^^^^^^

Transactions are currently auto-commit only, meaning that you can only submit a list of instructions that will be committed on success or rolled back on failure.

Transactions must run within a cluster-side configurable time limit or be cancelled.

This is an API restriction only and may change in the future.

Allowed operations
^^^^^^^^^^^^^^^^^^^^

Transactions support the same operations as batches.