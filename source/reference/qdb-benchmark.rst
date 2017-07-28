quasardb benchmarking tool
******************************

.. highlight:: js
.. program:: qdb-benchmark

Introduction
============

The quasardb benchmarking tool (`qdb-benchmark`) enables you to evaluate the performance of your quasardb cluster.
To do so, it runs chosen tests on the specified cluster and measures the time taken to process the commands as accurately as the operating systems allows it.


Quick Reference
===============

 ===================================== ============================================ ==============================
                Option                             Usage                                Default
 ===================================== ============================================ ==============================
 :option:`-h`, :option:`--help`        display help
 :option:`-v`, :option:`--version`     display version
 :option:`--show-tests`                display all available tests
 :option:`-n`, :option:`--dry-run`     display tests to be executed and exit
 :option:`--no-cleanup`                turn off cleaning up after each test
 :option:`-c`, :option:`--cluster`     cluster URI                                  ``qdb://127.0.0.1:2836``
 :option:`-p`, :option:`--pause`       pause duration between tests (in seconds)    ``1``
 :option:`-d`, :option:`--duration`    duration of each test (in seconds)           ``4``
 :option:`--sizes`                     sizes of entry contents to test (in bytes)   ``1,1k,1M``
 :option:`--threads`                   numbers of concurrent threads used for tests ``1,2,4``
 :option:`--user-credentials-file`     path to a JSON file with user credentials
 :option:`--cluster-public-file`       path to a file with cluster public key
 :option:`--tests`                     tests to run                                 ``*``
 ===================================== ============================================ ==============================


Usage scenarii
===============

 * Identifying hardware limits in a quasardb cluster (network bandwidth, server processing power, etc.).
 * Determining the maximum throughput of your cluster.
 * Comparing to other databases.
 * Tuning your system: network, disk, OS, etc.

Parameters reference
====================

.. option:: -h, --help

    Displays basic usage information.

    Example
        To display the online help, type: ::

            qdb-benchmark --help

.. option:: -v, --version

    Displays tool version information.

.. option:: --cluster=<address>:<port>

   Specifies the address and port of the quasardb cluster to which the benchmark tool must connect.

   Argument
        The URI (list of comma-separated endpoints, i.e. addresses and ports, preceded by ``qdb://``)
        of a cluster on which the tests will be run.

   Default value
        ``qdb://127.0.0.0:2836``, the IPv4 localhost address and the port 2836

   Example
        If the daemon listens on localhost and on the port 5009::

            qdb-benchmark --cluster=qdb://localhost:5009

.. option:: --threads=<threads>

    Specifies the number of threads that `qdb-benchmark` should use to run the test.
    This function is helpful to simulate multiple clients from a single test instance.

    Argument
        A list of positive integers representing the number of threads to use.

    Default value
        1,2,4

    Example
        Run the test two times, once in one thread and once in two threads::

            qdb-benchmark --threads=1,2
