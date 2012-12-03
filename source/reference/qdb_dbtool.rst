quasardb database tool
******************************

Introduction
============

The quasardb database tool enables you to analyze, dump, repair and backup the persisted data of a quasardb instance.

Parameters reference
====================

Parameters can be supplied in any order and are prefixed with ``--``. The arguments format is parameter dependent.

.. program:: qdb_dbtool

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

.. option:: --analyze, -a

    Requests an analysis of the database. A report will be printed on the standard output.

    Example
        Analyze the database in the current directory::

            qdb_dbtool --database=. --analyze

.. option:: --dump, -d

    Dumps the content of the database on the standard output.

    Example
        Dump the database in the current directory::

            qdb_dbtool --database=. --dump

.. option:: --backup=<path>, -b <path>

    Copies all the content of the database to a new database in the specified directory. If the directory does not exist it will be created.
    If a database exists in the destination directory, its content may be overwritten by the new content.

    Arguments
        A string representing the path where a copy of the database will be created.

    Default value
        None

    Example
        Backup the database in /var/quasardb/db to /var/quasardb/db/backup ::

            qdb_dbtool --database=/var/quasardb/db --backup=/var/quasardb/db/backup

.. option:: --repair, -r

    Attempts to repair the database. All data may not be recovered. Note that the :doc:`qdbd` automatically attempts to repair the database if needed, this option is intended for offline operations.

    Example
        Repairs the database in the current directory::

            qdb_dbtool --database=. --repair











