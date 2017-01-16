quasardb configuration generator
*********************************

.. program:: qdb_generate_config

Introduction
============

The quasardb configuration generator is a simple utility designed to create `qdbd.conf` and `qdb_httpd.conf` configuration files from input arguments.

Usage
===============

::

    qdb_generate_config <config_path> <log_path> <db_path> <console_path>

.. option:: config_path

    A folder path for the configuration files. If the folder does not exist it will be created.

.. option:: log_path

    A folder path for the log files. Sets the values of `local::logger::log_files` and `local::logger::dump_file` in `qdbd.conf` and `qdb_httpd.conf`.

.. option:: db_path

    A folder path that will contain the new database location. Sets the value of `global::depot::root`.

.. option:: console_path

    A folder path for the HTTP daemon HTML files. Sets the value of doc_root in `qdb_httpd.conf`.

