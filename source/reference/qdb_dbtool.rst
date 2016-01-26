quasardb database tool
******************************

.. program:: qdb_dbtool

Introduction
============

The quasardb database tool enables you to analyze, dump, repair and backup the persisted data of a quasardb instance.


Quick Reference
===============

 ===================================== ============================ ==============
                Option                             Usage                Default
 ===================================== ============================ ==============
 :option:`-h`, :option:`--help`        display help
 :option:`--database`                  path to the database
 :option:`-a`, :option:`--analyze`     analyzes the database
 :option:`-d`, :option:`--dump`        dumps database to stdout
 :option:`-b`, :option:`--backup`      performs backup to new db
 :option:`-r`, :option:`--repair`      repairs the database
 ===================================== ============================ ==============



Parameters reference
====================

Parameters can be supplied in any order and are prefixed with ``--``. The arguments format is parameter dependent.

.. option:: -h, --help

    Displays basic usage information.

    Example
        To display the online help, type: ::

            qdb_dbtool --help

.. option:: --database=<path>

    Specifies the path to the database on which to work.

    Arguments
        A string representing the path to the database, may be relative or absolute.

    Default value
        None

    Example
        Work on a database in the current directory::

            qdb_dbtool --database=.

        Work on a database in the /var/quasardb/db directory::

            qdb_dbtool --database=/var/quasardb/db directory

.. option:: -a, --analyze

    Requests an analysis of the database. A report will be printed to the standard output.

    Example
        Analyze the database in the current directory::

            qdb_dbtool --database=. --analyze

.. option:: -d, --dump

    Dumps the content of the database to the standard output.

    Example
        Dump the database in the current directory::

            qdb_dbtool --database=. --dump

.. option:: -b <path>, --backup=<path>

    Copies all the content of the database to a new database in the specified directory. If the directory does not exist it will be created.
    If a database exists in the destination directory, its content may be overwritten by the new content.

    Arguments
        A string representing the path where a copy of the database will be created.

    Default value
        None

    Example
        Backup the database in /var/quasardb/db to /var/backup/quasardb/db ::

            qdb_dbtool --database=/var/quasardb/db --backup=/var/backup/quasardb/db

.. option:: -r, --repair

    Attempts to repair the database. All data may not be recovered. Note that the :doc:`qdbd` daemon automatically attempts to repair the database if needed; this option is intended for offline operations.

    Example
        Repairs the database in the current directory::

            qdb_dbtool --database=. --repair


