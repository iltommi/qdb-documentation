Transactions
============

Overview
--------

While commands in quasardb are already atomic, transactions allow you to run several API commands as an atomic group. Either all commands in a transaction succeed or no commands succeed.

Transactions have been designed to be fast, scalable, while delivering excellent reliability. They are based on Multi-Version Concurrency Control (MVCC) and Two-Phase Commit protocol (2PC). During the design phase, we've done our best to reach the best balance between performance and reliability. While 2PC has some limitations which can lead to dirty reads, it was decided that using more complex protocols to address those limitations was not worth the huge performance cost.

Transactions are available since quasardb 2.0.0.

Characteristics
---------------

Transactions in quasardb are snapshot based and provide repeatable reads. They can operate on an arbitrary number of entries provided they run within the configured maximum transaction time.

If two transactions attempt to write to the same entry, the first transaction to operate on the entry wins and the other transaction is canceled.

When a transaction writes to an entry, other transactions may access the previous value of the entry.

If a commit fails, uncommitted data is rolled back after a configurable time has elapsed. Committed committed data is rolled back to a previous version if possible.

During partial commit failures, dirty reads may happen.

Design
------

Unique Transaction Identifier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Every time a client creates a new transaction, the quasardb cluster provides the client with a unique transaction ID. This ID is generated from node IDs, which must be unique in the cluster, and a high resolution timestamp.

Relying on the cluster to generate timestamps ensures that offset client clocks cannot tamper with the order of the entries. However, all nodes must be synchronized to prevent a large spread between timestamps. This can be done with NTP, but preferably with PTP.

If two nodes generate the same timestamp for two different transactions, the transaction from the larger node ID appears "after" the node with the smaller ID. This is not an issue, as in the case of any transaction collision, an arbitrary decision is made about which transaction came "before" the other.

Multiple Versions and Garbage Collection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As of quasardb 2.0.0, each entry is saved in the database as a series of concurrent entries, sorted by their transaction identifiers. To reduce the amount of storage and memory usage, old versions of each entry are automatically garbage collected.

The oldest version of the entry is removed if:
 * A new version of the entry is added and the total concurrent entries exceeds the cluster "concurrent entries" setting.
 * The version's timestamp is more than twice the duration of the cluster "transaction duration" setting.

Adjust the "concurrent entries" and "transaction duration" settings to fit your cluster needs. If entries are updated frequently, reduce storage and memory usage by decreasing the concurrent entries limit. If entries are updated infrequently, reduce storage and memory usage by decreasing the transaction duration limit.

If a client requests a transaction ID that has been garbage collected, the cluster returns "not found".

You may manually request garbage collection using the ``trim_all`` command.




Batch or transaction
--------------------

Batch operations and Transactions are very similar. Prefer Transactions when order is important, or all operations must complete successfully, such as a data model update. Prefer Batch when order of operations is not important and when failure of a single operation is not critical, such as a view that updates its information regularly.
