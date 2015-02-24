Transactions
============

Overview
--------

While commands in quasardb are already atomic, transactions allow you to run several API commands as an atomic group. All commands in a transaction will be successful or none of them will.

Transactions are only available in Quasardb 2.0.0 and higher.

Design
------

Transactions in quasardb are based off of `Multiversion concurrency control <http://en.wikipedia.org/wiki/Multiversion_concurrency_control>`_  The basic principle of MVCC is to create a new *uncommitted* version everytime you modify or delete an entry. Each version has a minimum date before which it didn't exist and potentially a maximum date after which it no longer exists. When the transaction is successful the affected version are flagged as *committed*.

Getting an entry is just a matter of getting the version matching the time at which you query it.

In order to implement MVCC in Quasardb, we must meet the following requirements:
 * Use a unique identifier for each transaction
 * Store multiple versions of each entity
 * Determine when each version can be garbage collected
 * Flag the state of each entity (uncommitted, committed, canceled)


Unique Transaction Identifier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Every time a client creates a new transaction, the quasardb cluster provides the client with a unique transaction ID. This ID is generated from node IDs, which must be unique in the cluster, and a high resolution timestamp.

Relying on the cluster to generate timestamps ensures that offset client clocks cannot tamper with the order of the entries. However, all nodes must be synchronized to prevent a large spread between timestamps. This can be done with NTP.

If two nodes generate the same timestamp for two different transactions, the transaction from the larger node ID will appear "after" the node with the smaller ID. This is not an issue as in the case of any transaction collision we would need to make an arbitrary decision about which transaction came "before" the other.

For more information on how quasardb generates the high-resolution timestamp, see the blog post `A Portable High-Resolution Timestamp in C++ <https://blog.quasardb.net/index.php/2014/06/a-portable-high-resolution-timestamp-in-c/>`_


Multiple Versions and Garbage Collection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As of quasardb 2.0.0, each entry is saved in the database as a series of concurrent entries, sorted by their transaction identifiers. To reduce the amount of storage and memory usage, old versions of each entry are automatically garbage collected.

The oldest version of the entry is removed if:
 * A new version of the entry is added and the total concurrent entries exceeds the cluster "concurrent entries" setting.
 * The version's timestamp is more than twice the duration of the cluster "transaction duration" setting.

Adjust the "concurrent entries" and "transaction duration" settings to fit your cluster needs. If entries are updated frequently, reduce storage and memory usage by decreasing the concurrent entries limit. If entries are updated infrequently, reduce storage and memory usage by decreasing the transaction duration limit.

If a client requests a transaction ID that has been garbage collected, the cluster will return "not found".

You may manually request garbage collection using the node_request_trim_all command.


Transaction States
~~~~~~~~~~~~~~~~~~

Each version of an entity also stores a transaction state, which can be thought of as an enum: ::

    enum class transaction_state : std::int8_t
    {
        inflight = 0,
        committed = 1,
        cancelled = 2
    };

Inflight status means the entry has been recorded in the database, but the parent transaction is still in progress.

Committed status means the entry has been recorded in the database and the parent transaction has completed successfully.

Cancelled status means the entry is invalid, as the parent transaction has failed or been rolled back.


Example Transactions
--------------------


Success: Transfer Money
~~~~~~~~~~~~~~~~~~~~~~~

Failure: Entry Inflight
~~~~~~~~~~~~~~~~~~~~~~~

Failure: qdb_get() Outside a Transaction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once a transaction has completed all of its operations, it goes through each operation in order and sets the status from inflight to committed. This means there is a brief period where some entries are inflight and some entries are committed.

When used outside of a transaction, the qdb_get() function returns the latest version of the entry with a committed status. This means a qdb_get() used outside of a transaction may return values from multiple, incongruous database states.


Failure: Client Crash Mid-Transaction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If a client crashes in the middle of a transaction, operating on the entries of this transaction will not be possible for the duration of the maximum transaction duration. After which the entry will be trimmed.



Best Practices
--------------

When using transactions, wrap all get calls in transactions. This ensures the client receives the latest information without a chance for undefined behavior.

Batch operations and Transactions are very similar. Prefer Transactions when order is important, or all operations must complete successfully, such as a data model update. Prefer Batch when order of operations is not important and when failure of a single operation is not critical, such as a view that updates its information regularly.


References
----------

Use the following links to learn more about MVCC. Keep in mind that the quasardb implementation may be different, especially because it implements MVCC transactions on a distributed cluster.

 * `MVCC on Wikipedia <http://en.wikipedia.org/wiki/Multiversion_concurrency_control>`_
 * `MVCC unmasked <http://momjian.us/main/writings/pgsql/mvcc.pdf>`_
 * `MVCC in PostgreSQL <http://www.postgresql.org/docs/7.1/static/mvcc.html>`_
 * `Understanding PostgreSQL MVCC <http://eric.themoritzfamily.com/understanding-psqls-mvcc.html>`_
 * `Implementation of MVCC for key-value store <https://highlyscalable.wordpress.com/2012/01/07/mvcc-transactions-key-value/>`_

