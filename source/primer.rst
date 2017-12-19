.. include:: abbreviations.rst

.. highlight:: python

Primer
******

What is |quasardb|?
-------------------

|Quasardb| is a column-oriented, distributed timeseries database (see :doc:`api/time_series`).

It has been designed to reliably store large amounts of data, while delivering a performance level that enables analysts to work interactively.

Where would you want to use |quasardb|? Here are a couple of use cases:

    * Market data store for back testing and analysis
    * Trades store for compliance
    * Time deviation database for compliance
    * Sensors data repository for predictive maintenance
    * Monitoring database for large deployments

Shall we dance?
---------------

To start a |quasardb| server, just run it! We provide packages for many platforms, but you can always work in a local directory where you manually
extracted your |quasardb| binaries. We also support docker for your convenience.

Let's assume we extracted the |quasardb| archive in a local directory. The default configuration listens on the localhost, port 2836. If you type::

    qdbd --security=false

You will have after a couple of seconds the daemon log on the console that it is ready to accept incoming requests.

|quasardb| is typically used via its multi-language API. For the purpose of this introduction, we will restrict ourselves to the Python API (see :doc:`api/python`) and the shell (see :doc:`reference/qdb_shell`).

Inserting timeseries data
-------------------------

We're going to create a single-column timeseries and insert data. The name of the timeseries will be *stocks* and the name of its unique column will be *close*. The type of the data we will insert in the column is 64-bit floating point numbers.

This is the code you need to write:

.. testcode:: primer

    import quasardb

    # connecting, default port is 2836
    c = quasardb.Cluster("qdb://127.0.0.1:2836")
    # creating a timeseries object
    my_ts = c.ts("stocks")
    # creating the timeseries in the database
    # it will return a list of created columns that we don't need here
    # and throw an error if the timeseries already exist
    ts.create([quasardb.TimeSeries.DoubleColumnInfo("close")])

You create the timeseries only once, like you create a table in a SQL database only once. If you wish to delete (drop) the whole timeseries, you do the following.

.. testcode:: primer

    c = quasardb.Cluster("qdb://127.0.0.1:2836")
    my_ts = c.ts("stocks")
    # remove the whole timeseries, in one call
    ts.remove()

.. note::
    Operations performed on timeseries are transactional. |quasardb| uses MVCC and 2PC to provide you with a high level of reliability.

Let's add 3 values into our timeseries:

.. testcode:: primer

    c = quasardb.Cluster("qdb://127.0.0.1:2836")
    # we don't create the timeseries again, we access the existing column
    close = ts.column(quasardb.TimeSeries.DoubleColumnInfo("close"))
    # this is not the most efficient way to insert data into a time series
    # but it's very convenient
    close.insert([(datetime.datetime(2017, 1, 1), 1.0),
                  (datetime.datetime(2017, 1, 2), 2.0),
                  (datetime.datetime(2017, 1, 3), 3.0)])


In this example we added 3 points, 1 point per day, for simplicity sake. In the examples directory of the Python API, you will find several examples showcasing the different ways you can insert data into a quasardb cluster.

Working with the data
---------------------

The data we inserted with the Python API has been normalized and is now accessible from all other APIs. We can also use our shell to visualize it:

.. note::
    Everything we do with the shell can be done via the API of your choice.

The following command::

    qdbsh

If you fancy some color, and your terminal supports it, you may want to try::

    qdbsh --color-output=yes

Will start the shell and the following prompt should be displayed. Keep in mind you must have the daemon running on the localhost,
as by default the shell will attempt to connect to the localhost::

    qdbsh >

Let's first check that our timeseries exists:

.. code-block:: sql

    qdbsh > show stocks
    2 columns

     0. timestamp - nanosecond timestamp
     1. close - 64-bit double

We can also dump the content of our timeseries:

.. code-block:: sql

    qdbsh > select * from stocks in range(2017-01-01, 2017-01-10)
    timestamp                      close
    --------------------------------------------
    2017-01-01T00:00:00.000000000Z 1.000000
    2017-01-02T00:00:00.000000000Z 2.000000
    2017-01-03T00:00:00.000000000Z 3.000000

As you can see the timestamp allows for nanosecond precision. Time definition syntax in quasardb is very flexible:

.. code-block:: sql

    qdbsh > select * from stocks in range(2017, +10d)
    timestamp                      close
    --------------------------------------------
    2017-01-01T00:00:00.000000000Z 1.000000
    2017-01-02T00:00:00.000000000Z 2.000000
    2017-01-03T00:00:00.000000000Z 3.000000

The database is also able to perform server-side aggregations for maximum performance. For example, you can ask for the average value of a timeseries, without having to retrieve all the data. Aggregations are able to leverage the enhanced instruction set of your CPU, when available.

For example, we can request the arithmetic mean of our stocks for the same interval:

.. code-block:: sql

    qdbsh > select arithmetic_mean(close) from stocks in range(2017, +10d)
    timestamp                      arithmetic_mean(close)
    ------------------------------------------------------
    2017-01-01T00:00:00.000000000Z 2.00

Here are some queries you can try for yourself:

    * Show the minimum and maximum open value for the last 20 years: ``select min(open), max(open) from stocks_A in range(now(), -20y)``
    * Display the open and close of two different time series: ``select open, close from stocks_A, stocks_B in range(2017, +10d)``
    * Daily averages over a year: ``select arithmetic_mean(close) from stocks in range(2017, +1y) group by day``
    * Display the last known value of a timeseries with respect to the timestamps of another: ``select value from bids in range(2017, +1d) asof(trades)``

.. note::
    For a list of supported functions, see :doc:`api/time_series`.

Organizing your data
--------------------

When you start to have a lot of timeseries, you probably want to find them based on criteria different than the name.

Out of the box, all timeseries are searchable by prefix and suffix::

    qdbsh > prefix_get sto 100
    1. stocks

    qdbsh > suffix_get cks 100
    1. stocks

This will return the 100 first matches for entries starting with "sto", and the 100 first matches for entries ending with "cks".

However, sometimes you want to organize your timeseries according to arbitraty criteria. For example, for our stocks, we may want to say that it comes from the NYSE and that the currency is USD.

|quasardb| has a powerful feature named "tags" that enables you to tag timeseries and do reverse lookups based on those tags::

    qdbsh > attach_tag stocks nyq

    qdbsh > attach_tag stocks usd

Then you can look up based on those tags::

    qdbsh > get_tagged nyq
    1. stocks - timeseries

    qdbsh > get_tagged usd
    1. stocks - timeseries

It's also possible to ask more complex questions, such as *"give me everything that is tagged with 'usd' but not 'nyq'"*::

    qdbsh > query "tag='usd' and not tag='nyq'"
    An entry matching the provided alias cannot be found.

Which is, in our case, the correct answer!

That demo is nice, but what happens when I go to production?
------------------------------------------------------------

A fair question which has a simple answer: the size and configuration of the cluster has no impact on the client code. |quasardb| will take care of the sharding and distribution of the data transparently, whether you are writing to and reading from the database.

The only thing that may change is the connection string. For example if you have a cluster of four machines, your connection string can be::

    c = qdb.Cluster("qdb://192.168.1.1:2836,192.168.1.2:2836,192.168.1.3:2836,192.168.1.4:2836", datetime.timedelta(minutes=1))

or::

    c = qdb.Cluster("qdb://192.168.1.1:2836,192.168.1.2:2836", datetime.timedelta(minutes=1))

and even::

    c = qdb.Cluster("qdb://192.168.1.1:2836", datetime.timedelta(minutes=1))

That's because the |quasardb| protocol has built-in discovery! Just give any node in the cluster and we take care of the rest. The more nodes the better as we can
try another node if the one provided is down at the moment of the connection.

Going further
-------------

We hope this quick tour left you wanting for more! |quasardb| is feature-rich yet simple to use and operate. If you want to go further, the best course of
action is to start with the documentation of the API for the language of your choice (:doc:`api/index`).

If you'd like to learn more about building a |quasardb| cluster, head over to the administrative section (:doc:`administration/index`).

Curious about the underlying concepts, we have a section dedicated to it (:doc:`concepts/index`).

Wrap up
-------

Things to remember about |quasardb|:

    * Fast and scalable
    * High-performance binary protocol
    * Multi-platform: FreeBSD, Linux 2.6+, OS X and Windows (32-bit and 64-bit)
    * Peer-to-peer network distribution
    * Transparent persistence
    * Native timeseries support
    * Distributed transactions
    * Rich typing
    * Tag-based search
    * Fire and forget: deploy, run and return to your core business.
