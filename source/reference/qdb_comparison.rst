quasardb benchmarking tool
******************************

.. highlight:: js

Introduction
============

The quasardb benchmarking tool enables you to evaluate the performance of your quasardb cluster. To do so, it runs a script on the specified cluster and measures - as accuratly as the operating systems allows it - the time taken to process the commands.

Usage scenarii
===============

 * Identifiying hardware limits in a quasardb cluster (network bandwidth, server processing power, etc.)
 * Determining the maximum throughput of your cluster
 * Tuning

Supported protocols
======================

The tool can be used to benchmark on servers supporting the following protocols (in alphabetical order):

 * aerospike
 * local
 * memcached
 * quasardb
 * redis

The local protocol creates a virtual "local" server to test the local machine memory bandwidth. This can help identify memory-related bottlenecks or abnormal allocator behavior.

Benchmark script
====================

Each benchmark is a script that runs operation is the given order.

For example to put a one (1) kilobyte entry once and retrieve it ten (10) times, the script is::

    tests
    {
        single_put_multiple_get
        {
            count 10
            size 1024
        }
    }

The tests are run in the given order. If you want to add another test, for example, if you want to put a one (1) byte entry and retrieving it one thousand (1,000) times, the script becomes::

    tests
    {
        single_put_multiple_get
        {
            count 10
            size 1024
        }

        single_put_multiple_get
        {
            count 1000
            size 1
        }
    }

Each command requires the count and size parameters.

The accepted commands are:

    * ``single_put_multiple_get``: adds one entry of *size* bytes and retrives it *count* times
    * ``multiple_put``: puts *count* entry of *size* bytes and then deletes them all
    * ``multiple_put_get_delete``: adds an entry of *size* bytes, retrieves it and deletes it *count* times
    * ``multiple_put_get_update_delete``: adds an entry of *size* bytes, retrieves it, updates it and deletes it *count* times

Parameters reference
====================

.. program:: qdb_comparison

.. option:: -h, --help

    Displays basic usage information.

    Example
        To display the online help, type: ::

            qdb_comparison --help

.. option:: --daemon <address>:<port>

   Specifies the address and port of the daemon daemon to which the comparison tool must connect. The daemon must conform to the protocol specified by the ``protocol`` parameter.

   Argument
        The address and port of a machine where a daemon is running.

   Default value
        127.0.0.0:2836, the IPv4 localhost address and the port 2836

   Example
        If the daemon listen on the localhost and on the port 5009::

            qdb_httpd --daemon-port=localhost:5009

.. option:: --protocol=<protocol>

    Specifies the protocol to use.

    Argument
        A string representing the name of the protocol to use. Supported values are aerospike, local, memcached, quasardb and redis.

    Default value
        quasardb

    Example
        Run the test on  a memcached compatible server::

            qdb_comparison --protocol=memcached

.. option:: --threads=<threads>

    Specifies the number of threads to run the test. This duplicates the amount of testing by the number of threads. This function is helpful to simulate multiple clients from a single test instance.

    Argument
        An integer between 1 and 100 representing the number of threads to use.

    Default value
        1

    Example
        Run the test two times in two separate threads::

            qdb_comparison --threads=2

.. option:: -f <path>, --test-file=<path>

    The test script to run.

    Argument
        A string representing the full path to the test script.

    Default value
        test.cfg

    Example
        Runs the tests written in ``stress.cfg``::

            qdb_comparison -f stress.cfg

.. option:: -o <path>, --output-file=<path>

    Specifies the path for the `CSV <http://en.wikipedia.org/wiki/Comma-separated_values>`_ output.

    Argument
        A string representing the full path to the results file:

    Default value
        A file name prefixed *report_* and suffixed with the current date and time.

    Example
        Output the results to ``results.csv``::

            qdbd --output-file=results.csv

