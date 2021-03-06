Time series
=================

.. highlight:: python

.. note::
    Time series are available starting with quasardb 2.1.0.

.. testsetup:: *

    import datetime
    import quasardb

Goal
------

Time series are meant to be used in demanding environments where in one second, millions of events have to be recorded and indexed with very high precision, and kept for as long as needed.

At quasardb, when we decided to implement time series, we did it with the following goals:

 - **Limitless**: It must be possible to record thousands of events every microsecond, for one hundred year, without ever removing a single line.
 - **Reliable**: Writes must be durable and reads consistent. Period.
 - **Flexible**:Although quasardb has server-side aggregations and computations, the user may manipulate the data with her own tools such as Python or R. Extracting a subset of a time series must be simple, fast, and efficient. When inserting data, the user must not have to define a complex schema and can change her mind afterwards.
 - **Interactive**: Transfers, computations and aggregations must be so fast that analytics can access quasardb directly, regardless of the amount of data stored, to enable the analyst to work interactively.
 - **Transparent**: When a user wants to average the value of a column, it should not be her concern whether or not the time series resides on a single node or is distributed over a big cluster, and if 10,000 users are doing the same thing at the same time. The database must solve all the distribution, concurrence and reduction problems and present a naive interface to the user.

Time series are available since quasardb 2.1.0.

Features
--------

Reliability
^^^^^^^^^^^

The transactional backend of quasardb ensures that insertion within a time series is consistent and reliable (see :doc:`../concepts/transactions`).

Performance
^^^^^^^^^^^

Thanks to its unique quasardb I/O engine a single node can typically deliver millions of insertions and lookups per second.

The I/O engine is capable of leveraging the `Messaging Accelerator (VMA) <http://www.mellanox.com/page/software_vma?mtag=vma>`_  of Mellanox cards.

Columns
^^^^^^^

Each time series supports an arbitrary number of columns, represented by an unique name.

A database may have as many time series as the storage allows. Each time series can be looked-up by its name or by one of its tags (see :doc:`queries`).

For each column, the following data types are currently supported:

 - Double precision (64-bit) floating point numbers
 - Binary large objects (blob) of any size
 - 64-bit signed integers
 - Nanosecond timestamps

Distribution
^^^^^^^^^^^^

Time series are distributed over the cluster transparently. Each node in the cluster is responsible for a certain time interval for any given time series. This time interval is set when you create the time series, and can be different for every time series. By default, in most API, it is set to 24 hours (one day).

Bulk loading
^^^^^^^^^^^^

Time series support value by value insertion, as well as efficient bulk loading. Inserting multiple lines in one call can yield significant performance improvements as it gives the opportunity for the database to optimize network traffic, memory allocations and disk writes.

Look-up by time index is efficient with an amortized constant lookup complexity O(1). That means that fetching a sub-part of the time series is independent of the length of the time series.

Size
^^^^

There is no limitation on the number of entries a time series may hold, other by the storage capabilities of the cluster.

Resolution
^^^^^^^^^^

Each point in time is represented with a very-high precision 128-bit timestamp with nanosecond granularity, which makes it possible to represent any point in time for the duration of the universe.

Real-time aggregation
^^^^^^^^^^^^^^^^^^^^^

Time series values are stored in cache-aware data structures. Aggregations are vectorized using the available enhanced instructions set of the processor.

For example, an `Intel Xeon E5-2670 <https://ark.intel.com/products/64595/Intel-Xeon-Processor-E5-2670-20M-Cache-2_60-GHz-8_00-GTs-Intel-QPI>`_ can sum a column in the region of 3 billions of rows per second per core thanks to the SSE 4.2 and AVX instruction sets.

When the time interval spans several nodes, the API will transparently distribute the computation over multiple nodes, and perform the adequate reductions.

Efficient storage
^^^^^^^^^^^^^^^^^

While preserving the 128-bit resolution of each timestamp, each bucket only stores the 64-bit index relative to its time interval. Each 64-bit index is compressed using a lossless compression algorithm that stores only the second-degree variations, leveraging the column-oriented nature of quasarDB.

Integer values are compressed to disk using an algorithm similar to the one used for timestamps.

Doubles and blobs values are currently not compressed.

When a time interval does not contain data, it does not use any space. Thus, discontinuous data is natively supported and there is no need to *"clean up"* the data before inserting it into quasardb.

For more information, see :doc:`../concepts/data_storage`.

.. _ts_functions:

Supported server side functions
-------------------------------

All functions are transparently distributed over the cluster.

 +-----------------------------------+----------------+------------+------------+
 | Operation                         | Applies to     | Complexity | Vectorized |
 +===================================+================+============+============+
 | First element                     | Any            | Constant   | No         |
 +-----------------------------------+----------------+------------+------------+
 | Last element                      | Any            | Constant   | No         |
 +-----------------------------------+----------------+------------+------------+
 | Minimum element                   | Double, int64  | Linear     | Yes        |
 +-----------------------------------+----------------+------------+------------+
 | Minimum element (absolute values) | Double, int64  | Linear     | Yes        |
 +-----------------------------------+----------------+------------+------------+
 | Maximum element                   | Double, int64  | Linear     | Yes        |
 +-----------------------------------+----------------+------------+------------+
 | Maximum element (absolute values) | Double, int64  | Linear     | Yes        |
 +-----------------------------------+----------------+------------+------------+
 | Spread                            | Double, int64  | Linear     | Yes        |
 +-----------------------------------+----------------+------------+------------+
 | Population variance               | Double, int64  | Linear     | No         |
 +-----------------------------------+----------------+------------+------------+
 | Sample variance                   | Double, int64  | Linear     | No         |
 +-----------------------------------+----------------+------------+------------+
 | Population standard deviation     | Double, int64  | Linear     | No         |
 +-----------------------------------+----------------+------------+------------+
 | Sample standard deviation         | Double, int64  | Linear     | No         |
 +-----------------------------------+----------------+------------+------------+
 | Arithmetic mean                   | Double, int64  | Linear     | Yes        |
 +-----------------------------------+----------------+------------+------------+
 | Harmonic mean                     | Double, int64  | Linear     | No         |
 +-----------------------------------+----------------+------------+------------+
 | Geometric mean                    | Double, int64  | Linear     | No         |
 +-----------------------------------+----------------+------------+------------+
 | Quadratic mean (root mean square) | Double, int64  | Linear     | No         |
 +-----------------------------------+----------------+------------+------------+
 | Number of elements                | Any            | Constant   | No         |
 +-----------------------------------+----------------+------------+------------+
 | Sum                               | Double, int64  | Linear     | Yes        |
 +-----------------------------------+----------------+------------+------------+
 | Sum of squares                    | Double, int64  | Linear     | Yes        |
 +-----------------------------------+----------------+------------+------------+
 | Product                           | Double, int64  | Linear     | Yes        |
 +-----------------------------------+----------------+------------+------------+
 | Skewness                          | Double, int64  | Linear     | No         |
 +-----------------------------------+----------------+------------+------------+
 | Kurtosis                          | Double, int64  | Linear     | No         |
 +-----------------------------------+----------------+------------+------------+

Usage
-------

In the next example, we'll assume we want to work on the following time series, named "tick42" :

+-------------------------+-------+------+-----------+
| Timestamp               | Price | Size | Exchange  |
+=========================+=======+======+===========+
| 2016-11-28 14:28:32.213 |  243  | 100  |   P       |
+-------------------------+-------+------+-----------+
| 2016-11-28 14:28:33.124 |  243  | 200  |   P       |
+-------------------------+-------+------+-----------+
|   ...                   | ...   | ...  | ...       |
+-------------------------+-------+------+-----------+
| 2016-11-28 15:12:33.024 |  300  | 400  |   T       |
+-------------------------+-------+------+-----------+

Creation
^^^^^^^^

A time series needs to be initially created, and column must be defined. The type of the column is fixed for the lifetime of the column. It is possible to insert, remove and rename columns after the time series has been created.

For example, to create the following time series in Python:

.. testcode:: quasardb

    import quasardb

    # assuming a node on the localhost
    c = quasardb.Cluster('qdb://127.0.0.1:2836')
    ts = c.ts("tick42")
    cols = ts.create([quasardb.TimeSeries.DoubleColumnInfo("Price"), quasardb.TimeSeries.DoubleColumnInfo("Size"), quasardb.TimeSeries.BlobColumnInfo("Exchange")])

Insertion
^^^^^^^^^

Once the time series is created, values are inserted in each column. It is not required to have a value for each column at every timestamp. Concurrent insertion is supported.

It is not possible to insert in a non-existing time series or in a non-existing column.

.. warning::
    Not every API deliver nanosecond resolution for the timestamps during insertion and lookup. This can be due to the inherent limitation of the language. Internally, every value has a timestamp with nanosecond granularity regardless of the language and platform used.

To insert the first line in our example:

.. testcode:: quasardb

    line_ts = datetime.datetime(2016, 11, 28, 14, 28, 32, 213000)

    cols[0].insert([(line_ts, 243)])
    cols[1].insert([(line_ts, 100)])
    cols[2].insert([(line_ts, "P")])

Time series lookup
^^^^^^^^^^^^^^^^^^

Time series can be discovered by key, by tag or by affix, like any other entry (see :doc:`queries`).

It is possible to enumerate the columns of a time series at any time.

In Python, to enumerate the columns of a time series:

.. testcode:: quasardb

    # columns will be returned in the order they were created
    cols = ts.columns()

    # it is also possible to access a specific column
    col_price = ts.column(quasardb.TimeSeries.DoubleColumnInfo("Price"))
    col_price.insert([(line_ts, 243)])

Fetching the values of time series
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Values are obtained by time interval. The complexity of the operation is independent of the size of the time series. Most APIs support querying multiple range in one call to minimize network traffic.

.. warning::
    The number of returned values can be very large.

For example, to get all the prices of March, 25th 2016:

.. testcode:: quasardb

    col_price = ts.column(quasardb.TimeSeries.DoubleColumnInfo("Price"))
    all_prices = col_price.get_ranges([(datetime.datetime(2016,3,25,00,00,00), datetime.datetime(2016,3,25,23,59,59,999999))])

Server-side aggregation
^^^^^^^^^^^^^^^^^^^^^^^

Aggregations are done on ranges. A single aggregation will not be multithreaded on a single server, however, a server supports multiple aggregations on the same (or different) time series in parallel and these aggregations will occur in separate threads.

Aggregations on floating-point values are done at 64-bit precision.

If we wanted to have the total volume for March, 25th 2016:

.. testcode:: quasardb

    col_size = ts.column(quasardb.TimeSeries.DoubleColumnInfo("Size"))

    # volumes[0] will have the total volume
    volumes = col_size.aggregate(quasardb.TimeSeries.Aggregation.sum, [(datetime.datetime(2016,3,25,00,00,00), datetime.datetime(2016,3,25,23,59,59,999999))])