R
===

.. default-domain:: r
.. highlight:: r

Introduction
------------

.. warning:: **Our R API is currently in alpha release and is not recommended for production**

             During the alpha phase only macOS is supported.

This document is an introduction to the quasardb R API. It is primarily focused on
timeseries, and will guide you through the various ways you can interact with the
QuasarDB backend.

Requirements
------------

 * `QuasarDB Daemon <https://download.quasardb.net/quasardb/2.6/2.6.0/server/>`_
 * `QuasarDB C API <https://download.quasardb.net/quasardb/2.6/2.6.0/api/c/>`_


Installation
------------

You can install the quasardb R API directly from github as follows:

.. code-block:: bash

   devtools::install_github("bureau14/qdb-api-r")

For instructions on how to perform a clean build of the extension from source,
please look at our `Github repository <https://github.com/bureau14/qdb-api-r>`_.

Usage
-----

Require the R library, and verify the C API version:

.. code-block:: r

   library(quasardb)
   qdb_version()
   #> [1] "quasardb 2.6.0"

   qdb_build()
   #> [1] "2.6.0 build 5daea00 2018-05-28 00:27:52 +0000"


Establishing a connection
^^^^^^^^^^^^^^^^^^^^^^^^^

Connect to a QuasarDB cluster:

.. code-block:: r

   handle <- qdb_connect("qdb://127.0.0.1:2836")

Creating a timeseries
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: r

   handle <- qdb_connect("qdb://127.0.0.1:2836")
   qdb_ts_create(handle, name = "timeseries1",
        columns = c("column1" = ColumnType$Blob, "column2" = ColumnType$Double))

This will create a timeseries with the a default shard size of 24h.

Retrieving timeseries
^^^^^^^^^^^^^^^^^^^^^

QuasarDB allows you to organise many different timeseries by tag. To look up these timeseries by tag, use the `qdb_find`:

.. code-block:: r

   handle <- qdb_connect("qdb://127.0.0.1:2836")
   keys <- qdb_find(handle, "find(tag='nyse' and type=ts)")

Executing queries
^^^^^^^^^^^^^^^^^

You can execute queries directly in R and process their results:

.. code-block:: r

   handle <- qdb_connect("qdb://127.0.0.1:2836")
                result <- qdb_find(handle, "select first(open), max(high) from find(tag='nasdaq' and type=ts) in range(today, -1y) group by day")
   #> res$tables$test$data
