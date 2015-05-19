quasardb database tool
******************************

Introduction
============

The quasardb database tool enables you to analyze, dump, repair and backup the persisted data of a quasardb instance.


Quick Reference
===============

 ===================================== ============================ ==============
                Option                             Usage                Default
 ===================================== ============================ ==============
 :option:`-h`, `--help`                display help                  
 :option:`-v`, `--version`             display qdb_dbtool version
 :option:`--database`                  path to the database          
 :option:`-a`, `--analyze`             analyzes the database         
 :option:`-r`, `--repair`              repairs the database          
 ===================================== ============================ ==============



Parameters reference
====================

Parameters can be supplied in any order and are prefixed with ``--``. The arguments format is parameter dependent.

.. program:: qdb_dbtool

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

        Work on a database in the /var/quasardb/db directory::

            qdb_dbtool --database=/var/quasardb/db directory

.. option:: --analyze, -a

    Requests an analysis of the database. A report will be printed to the standard output.

    Example
        Analyze the database in the current directory::

            qdb_dbtool --database=. --analyze

.. option:: --repair, -r

    Attempts to repair the database. All data may not be recovered. Note that the :doc:`qdbd` daemon automatically attempts to repair the database if needed; this option is intended for offline operations.

    Example
        Repairs the database in the current directory::

            qdb_dbtool --database=. --repair


