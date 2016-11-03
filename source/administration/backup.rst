Backing up quasardb
=====================

Replication isn't always enough
---------------------------------

Quasardb offers the possibility to replicate your data up to three times. Meaning that an entry can exist on up to four different nodes in a single cluster. This protects you - for example - from hardware failure. Since a single quasardb cluster can spawn - within certain limits - several datacenters, you can even protect your cluster from a complete datacenter failure.

However, replication will not help you if:

 * An operator issues a "cluster_purge" command on a quasardb cluster where the command has been allowed (the command is disabled by default).
 * A test program that generates test samples has been run by accident on a production quasardb cluster.
 * A bug in a program causes data to be removed.
 * You lose the connection to your datacenter.
 * For regulation purposes, you need to have a clone of your cluster ready to run at any time.
 * You need to restore your integration cluster to a certain known state every day.

The solution for this is to backup your quasardb cluster.

There are two ways to backup a quasardb cluster: offline and online.

.. caution::
    Backing up is an I/O intensive operation. Avoid backups during traffic spikes.

Offline backups
----------------------------

Quasardb stores its data in a Virtual File System (VFS) that is seen by the operating systems as regular files. Thus, any backup system that works on files is able to backup quasardb.

Offline backups have the following advantages:

 * quasardb doesn't have to be running.
 * Can be done with third-party backup software or quasardb tools.
 * Backup doesn't need to be aware of the business logic.
 * Support of incremental backups.

They have however the following limitations:

 * Filesystem access to the quasardb nodes is required.
 * May backup more data than needed during incremental backups.
 * It is not possible to restore an offline backup to a smaller quasardb cluster.
 * Restoration is slower than with online backups.

Offline backup of a quasardb node
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An offline backup of a quasardb node is strictly backing up its database directory.

 #. Locate your quasardb database directory (see :doc:`../reference/qdbd`).
 #. Ensure you have read permission on the quasardb directory.
 #. *(optional)* Stop the quasardb daemon.
 #. Backup the quasardb database directory with your backup software (you can alternatively use :doc:`../reference/qdb_dbtool`).
 #. If you stopped the quasardb daemon, restart it once the backup is finished.

Offline restoration of a quasardb node
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Quasardb comes with advanced, automatic, recovery mechanisms. All is needed to restore a quasardb node is to restore its directory.

 #. Locate your quasardb database directory (see :doc:`../reference/qdbd`).
 #. Ensure the node is running a quasardb version greater or equal to the backed up node.
 #. Ensure you have write permissions on the quasardb directory.
 #. Ensure you have sufficient space on the filesystem that hosts the quasardb directory.
 #. Ensure the quasardb daemon is stopped.
 #. *(optional)* Remove all content from the existing database directory.
 #. Restore your backup in the quasardb directory with your backup software (you can alternatively use :doc:`../reference/qdb_dbtool`).
 #. *(optional)* Use :doc:`../reference/qdb_dbtool` to validate the database.
 #. Start the quasardb daemon.
 #. The daemon will validate and optionally repair the database. If, needed, it will migrate and replicate the content to other nodes.

Offline backup of a quasardb cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To backup a quasardb cluster, backup every node as described in the procedure. You may backup all the node simultaneously or in stages,
depending on the size of your cluster and your operational requirements.

Backing up all the nodes at once has the advantage of reducing the total backup time, but may severely degrade the performances of the cluster
during the procedure.

Backing up nodes in stages has the advantage of reducing the I/O pressure on the cluster, but significantely increases the total duration of the backup.

.. caution::
    Ensure you backup every node in a different target directory. Failure to do so may result in data loss.

Partial offline restoration of a quasardb cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For clusters that are not replicated, it may be needed to restore one or several nodes after a failure. The procedure is identical to the offline restoration of a single node. Nodes restoration can be done in any order, at any time. Once the restored node joins the cluster, it will automatically synchronize its state with other nodes.

Complete offline restoration of a quasardb cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 #. Ensure all quasardb daemons are stopped.
 #. Ensure all quasardb daemons have a virgin quasardb directory.
 #. Restore all the nodes. This can be done simultaneously, if your backup software supports it.
 #. Start all quasardb nodes in any order.
 #. Wait for the quasardb cluster to stabilize and data to be replicated. If the cluster on which you restore the backup is larger than the original cluster, this will require, at worst, all the data to be transfered to different nodes. The time it takes depends on the volume of your data and your network bandwidth.

.. caution::
    Offline restoration only works if the target cluster is at least as large as the backup.

Online backups
----------------------------

Online backups are more powerful, more flexible. They can be used to keep two clusters in sync, surgically backup content and quickly recover from failure.

Online backups have the following advantages:

 * Nodes are backed up remotely.
 * Cluster topology has no influence on the backup.
 * Can backup exactly what is needed.
 * Backup can be done in whatever form required (raw data, excel file, csv, text files...).
 * Can be designed to be very low profile.

They have however the following limitations:

 * quasardb must be running and working properly.
 * Requires an understanding of the business logic.
 * Can only be done through quasardb scripts and APIs, thus, may require specific developments.

There are two main classes of online backup strategy:

 #. Cluster to cluster
 #. Cluster to data

Cluster to cluster online backups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using a replication script, a *master* cluster is read at regular intervals and the updated content is saved to a *slave* cluster.

Requirements:

 * The *slave* cluster must be at least as large as the *master* cluster.
 * The two clusters must be running compatible versions of quasardb.

Cluster to data online backups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using a replication script, a cluster is read at regular intervals and the content is saved to a file system.

Requirements:

 * The destination file system must be large enough to store all the cluster content.
