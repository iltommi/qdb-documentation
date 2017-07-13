quasardb database tool
******************************

.. program:: qdb_dbtool

Introduction
============

The quasardb database tool enables you to analyze, dump, repair, backup, restore and verify backups of your quasardb node.

Quick Reference
===============

 ===================================== ============================ ==============
                Option                             Usage                Default
 ===================================== ============================ ==============
 :option:`-h`, :option:`--help`        display help
 :option:`-v`, :option:`--version`     display qdb_dbtool version
 :option:`--database`                  path to the database
 :option:`-a`, :option:`--analyze`     analyzes the database
 :option:`-r`, :option:`--repair`      repairs the database
 :option:`-b`, :option:`--backup`      performs a database backup
 :option:`--restore`                   restores a database backup
 :option:`--verify_backup`             verifies database backups
 ===================================== ============================ ==============


Parameters reference
====================

Parameters can be supplied in any order and are prefixed with ``--``. The arguments format is parameter dependent.

.. option:: -h, --help

    Displays basic usage information.

.. option:: -v, --version

    Displays the version of the quasardb database tool.

.. option:: --database=<path>

    Specifies the path to the database on which to work.

    Arguments
        A string representing the path to the database, may be relative or absolute.

    Default value
        None

    Example
        Work on a database in the current directory::

            qdb_dbtool --database=.

        Work on a database in the `/var/quasardb/db directory`::

            qdb_dbtool --database=/var/quasardb/db directory

.. option:: -a, --analyze

    Requests an analysis of the database. A report will be printed to the standard output.

    Example
        Analyze the database in the current directory::

            qdb_dbtool --database=. --analyze

.. option:: -r, --repair

    Attempts to repair the database. All data may not be recovered. Note that the :doc:`qdbd` daemon automatically attempts to repair the database if needed; this option is intended for offline operations.

    Example
        Repairs the database in the current directory::

            qdb_dbtool --database=. --repair


.. option:: -b=<path>, --backup=<path>

    Performs an incremental database backup. The daemon must not be running.

    Arguments
        A string representing the path to the backup, may be relative or absolute.

    Default value
        None

    Example
        Backup a database in `/var/lib/db/qdb` to `/mnt/backups/qdb`::

            qdb_dbtool --database=/var/lib/db/qdb --backup=/mnt/backups/qdb

.. option:: --restore=<path>

    Restores a database backup. The daemon must not be running. Data in the destination directory may be destroyed.

    Arguments
        A string representing the path to the backup from which do the restoration. May be relative or absolute.

    Default value
        None

    Example
        Restore a backup in `/var/lib/db/qdb` to `/mnt/backups/qdb`::

            qdb_dbtool --database=/var/lib/db/qdb --restore=/mnt/backups/qdb

.. option:: --verify_backup=<path>

    Verifies a database backup.

    Arguments
        A string representing the path to the backup to verify. May be relative or absolute.

    Default value
        None

    Example
        Verify a backup in `/mnt/backups/db`::

            qdb_dbtool --verify_backup=/mnt/backups/qdb