.. include:: ../abbreviations.rst
.. default-domain:: scala
.. highlight:: scala

Spark connector
===================

Introduction
------------

Official |quasardb| Spark connector.
It extends |quasardb|'s support to allow storing and retrieving data as `Spark RDDs <https://spark.apache.org/docs/latest/rdd-programming-guide.html#resilient-distributed-datasets-rdds>`_ or DataFrames.
You may read and download the connector's code from GitHub at `<https://github.com/bureau14/qdb-spark-connector>`_.

Querying |quasardb|
-------------------

Given a |quasardb| timeseries table ``doubles_test`` that looks as follows:

+---------------------+-----------+
| timestamp           | value     |
+=====================+===========+
| 2017-10-01 12:09:03 | 1.2345678 |
+---------------------+-----------+
| 2017-10-01 12:09:04 | 8.7654321 |
+---------------------+-----------+
| 2017-10-01 12:09:05 | 5.6789012 |
+---------------------+-----------+
| 2017-10-01 12:09:06 | 2.1098765 |
+---------------------+-----------+

Querying using RDD
^^^^^^^^^^^^^^^^^^

The ``qdbDoubleColumn`` is an implicit method on an ``RDD[(Timestamp, Double)]``,
and the ``qdbBlobColumn`` is an implicit method on an ``RDD[(Timestamp, Array[Byte]))``.
Both methods require explicitly passing a ``qdbUri``, a ``tableName``, a ``columnName`` and a ``QdbTimeRangeCollection`` as demonstrated below.

.. code-block:: scala

    import java.sql.Timestamp
    import org.apache.spark.SparkContext
    import org.apache.spark.sql.SQLContext
    import com.quasardb.spark._
    import net.quasardb.qdb.QdbTimeRangeCollection

    val qdbUri = "qdb://127.0.01:2836"
    val timeRanges = new QdbTimeRangeCollection
    timeRanges.add(
      new QdbTimeRange(
        Timestamp.valueOf("2017-10-01 12:09:03"),
        Timestamp.valueOf("2017-10-01 12:09:07")))

    val sc = new SparkContext("local", "qdb-test")
    val sqlContext = new SQLContext(sc)

    val rdd = sqlContext
      .qdbDoubleColumn(
        qdbUri,
        "doubles_test",
        "value",
        timeRanges)
      .collect

Querying using a DataFrame
^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``qdbDoubleColumnAsDataFrame`` and the ``qdbBlobColumnAsDataFrame`` allows querying data from |quasardb| directly as a DataFrame. It exposes a DataFrame with the columns ``timestamp`` and ``value``, where the value corresponds to the value type of the data being queried (``Double`` or ``Array[Byte]``).

.. code-block:: scala

    import java.sql.Timestamp
    import org.apache.spark.SparkContext
    import org.apache.spark.sql.SQLContext
    import com.quasardb.spark._
    import net.quasardb.qdb.QdbTimeRangeCollection

    val qdbUri = "qdb://127.0.01:2836"
    val timeRanges = new QdbTimeRangeCollection
    timeRanges.add(
      new QdbTimeRange(
        Timestamp.valueOf("2017-10-01 12:09:03"),
        Timestamp.valueOf("2017-10-01 12:09:07")))

    val sc = new SparkContext("local", "qdb-test")
    val sqlContext = new SQLContext(sc)

    val df = sqlContext
      .qdbDoubleColumnAsDataFrame(
        qdbUri,
        "doubles_test",
        "dbl_value",
        timeRanges)
      .collect

Aggregating using an RDD
^^^^^^^^^^^^^^^^^^^^^^^^

|Quasardb| exposes its native aggregation capabilities as RDD using the implicit methods
``qdbAggregateDoubleColumn`` and ``qdbAggregateBlobColumn`` that requires passing
a ``qdbUri``, ``tableName``, ``columnName`` and a sequence of ``AggregateQuery``.
It returns exactly one result row for each ``AggregateQuery`` provided.

.. code-block:: scala

    import java.sql.Timestamp
    import org.apache.spark.SparkContext
    import org.apache.spark.sql.SQLContext
    import net.quasardb.qdb.QdbAggregation
    import com.quasardb.spark._
    import com.quasardb.spark.rdd.AggregateQuery

    val qdbUri = "qdb://127.0.01:2836"
    val sc = new SparkContext("local", "qdb-test")
    val sqlContext = new SQLContext(sc)

    val results = sqlContext
      .qdbAggregateDoubleColumn(
        qdbUri,
        "doubles_test",
        "value",
        List(
          AggregateQuery(
            begin = Timestamp.valueOf("2017-10-01 12:09:03"),
            end = = Timestamp.valueOf("2017-10-01 12:09:07"),
            operation = QdbAggregation.Type.COUNT))
      .collect

    results.length should equal(1)
    results.head.count should equal(doubleCollection.size)

Aggregating using a DataFrame
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

|Quasardb| exposes its native aggregation capabilities as DataFrame using the implicit methods
``qdbAggregateDoubleColumnAsDataFrame`` and ``qdbAggregateBlobColumnAsDataFrame`` that requires passing
a ``qdbUri``, ``tableName``, ``columnName`` and a sequence of ``AggregateQuery``.
It returns exactly one result row for each ``AggregateQuery`` provided.

.. code-block:: scala

    import java.sql.Timestamp
    import org.apache.spark.SparkContext
    import org.apache.spark.sql.SQLContext
    import net.quasardb.qdb.QdbAggregation
    import com.quasardb.spark._
    import com.quasardb.spark.rdd.AggregateQuery

    val qdbUri = "qdb://127.0.01:2836"
    val sc = new SparkContext("local", "qdb-test")
    val sqlContext = new SQLContext(sc)

    val results = sqlContext
      .qdbAggregateDoubleColumnAsDataFrame(
        qdbUri,
        "doubles_test",
        "value",
        List(
          AggregateQuery(
            begin = Timestamp.valueOf("2017-10-01 12:09:03"),
            end = = Timestamp.valueOf("2017-10-01 12:09:07"),
            operation = QdbAggregation.Type.COUNT))
      .collect

    results.length should equal(1)
    results.head.getLong(0) should equal(doubleCollection.size)

Writing to |quasardb|
---------------------

Writing using an RDD
^^^^^^^^^^^^^^^^^^^^

.. code-block:: scala

    import java.sql.Timestamp
    import org.apache.spark.SparkContext
    import org.apache.spark.sql.SQLContext
    import com.quasardb.spark._

    val qdbUri = "qdb://127.0.01:2836"
    val sc = new SparkContext("local", "qdb-test")
    val sqlContext = new SQLContext(sc)

    val dataSet = List(
      (Timestamp.valueOf("2017-10-01 12:09:03"), 1.2345678),
      (Timestamp.valueOf("2017-10-01 12:09:04"), 8.7654321),
      (Timestamp.valueOf("2017-10-01 12:09:05"), 5.6789012),
      (Timestamp.valueOf("2017-10-01 12:09:06"), 2.1098765))

    sc
      .parallelize(dataSet)
      .toQdbDoubleColumn(qdbUri, "doubles_test", "dbl_value")

Writing using a DataFrame
^^^^^^^^^^^^^^^^^^^^^^^^^

The ``qdbDoubleColumnAsDataFrame`` and ``qdbBlobColumnAsDataFrame`` functions are available
in the Spark SQLContext to allow storing data into |quasardb|.
You must also pass a ``qdbUri``, a ``tableName`` and a ``columnName`` to the function to store the data in the correct location.

The code example below copies all the data from the ``doubles_test`` table into the ``doubles_test_copy`` table.

.. code-block:: scala

    import java.sql.Timestamp
    import org.apache.spark.SparkContext
    import org.apache.spark.sql.SQLContext
    import com.quasardb.spark._
    import net.quasardb.qdb.QdbTimeRangeCollection

    val qdbUri = "qdb://127.0.01:2836"
    val timeRanges = new QdbTimeRangeCollection
    timeRanges.add(
      new QdbTimeRange(
        Timestamp.valueOf("2017-10-01 12:09:03"),
        Timestamp.valueOf("2017-10-01 12:09:07")))

    val sc = new SparkContext("local", "qdb-test")
    val sqlContext = new SQLContext(sc)

    val df = sqlContext
      .qdbDoubleColumnAsDataFrame(
        qdbUri,
        "doubles_test",
        "dbl_value",
        timeRanges)
      .toQdbDoubleColumn(qdbUri, "doubles_test_copy", "dbl_value")

Tests
-----

In order to run the tests, please download the latest quasardb-server and extract in a ``qdb`` subdirectory like this:

.. code-block:: shell

    mkdir qdb
    cd qdb
    wget "https://download.quasardb.net/quasardb/2.1/2.1.0-beta.1/server/qdb-2.1.0master-darwin-64bit-server.tar.gz"
    tar -xzf "qdb-2.1.0master-darwin-64bit-server.tar.gz"

Then launch the integration test using sbt:

.. code-block:: shell

    sbt test

A note for macOS users
----------------------

|Quasardb| uses a C++ standard library that is not shipped with macOS by default.
Unfortunately, due to static linking restrictions on macOS this can cause runtime errors such like these:

.. code-block:: shell

    dyld: Symbol not found: __ZTISt18bad_variant_access

Until a fix is available for the |quasardb| client libraries,
the best course of action is to download the libc++ libraries and tell your shell where to find them:

.. code-block:: shell

    cd qdb
    wget "http://releases.llvm.org/5.0.0/clang+llvm-5.0.0-x86_64-apple-darwin.tar.xz"
    tar -xzf "clang+llvm-5.0.0-x86_64-apple-darwin.tar.xz"

And then run the tests like this:

.. code-block:: shell

    DYLD_LIBRARY_PATH=qdb/clang+llvm-5.0.0-x86_64-apple-darwin/lib/ sbt test
