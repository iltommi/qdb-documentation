wrpme benchmark tool
******************************

.. highlight:: js

Introduction
============

The wrpme benchmark tool enables you to evaluate the performance of your wrpme cluster. To do so, it runs a script on the specified cluster and measures - as accuratly as the operating systems allows it - the time taken to process the commands.

Usage scenarii
===============

 * Identifiying hardware limits in a wrpme cluster (network bandwidth, server processing power, etc.)
 * Determining the maximum throughput of your cluster 
 * Tuning

Benchmark script
====================

Each benchmark is a script that runs operation is the given order.

For example to put a one kilobyte entry once and retrieving it ten (10) times, the script is::

    tests
    {
        single_put_multiple_get
        {
            count 10
            size 1024
        }
    }

The tests are run in the given order. If you want to add another test, for example, if you want to put a one byte entry and retrieving it one thousand (1,000) times, the script becomes::

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

.. program:: wrp_me_comparison

.. option:: -h, --help

    Displays basic usage information.

    Example
        To display the online help, type: ::

            wrp_me_comparison --help

.. option:: -a <address>, --address=<address>

    Specifies the address to which the benchmarking tool must connect.

    Argument
        A string representing the address the server listens on. The string can be a host name or an IP address.
        
    Default value
        127.0.0.1, the IPv4 localhost

    Example
        Run the test on the server listening on 192.168.1.1::

            wrp_me_comparison -a 192.168.1.1
            
.. option:: -p <port>, --port=<port>

    Specifies the port to which the benchmarking tool must connect.
    
    Argument
        An integer representing the address the server listens on.  

    Default value
        5909

    Example
        Run the test on the server listening on 31337::
            
            wrp_me_comparison -p 31337

.. option:: --protocol=<protocol>

    Specifies the protocol to use.

    Argument
        A string representing the name of the protocol to use. Only wrpme and memcached are currently supported.

    Default value
        wrpme

    Example
        Run the test on  a memcached compatible server::

            wrp_me_comparison --protocol=memcached

.. option:: -f <path>, --test-file=<path>

    The test script to run.

    Argument
        A string representing the full path to the test script.

    Default value
        test.cfg

    Example
        Runs the tests written in ``stress.cfg``::

            wrp_me_comparison -f stress.cfg

.. option:: -o <path>, --output-file=<path>

    Specifies the path for the `CSV <http://en.wikipedia.org/wiki/Comma-separated_values>` output.

    Argument
        A string representing the full path to the results file:

    Default value
        A file name prefixed *report_* and suffixed with the current date and time.

    Example
        Output the results to ``results.csv``::

            wrpmed --output-file=results.csv

        