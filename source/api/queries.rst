Queries
======================

.. cpp:namespace:: qdb
.. highlight:: sql

.. note::
    Queries are available starting with quasardb 2.1.0.

Goal
------

Although the API gives you all the building blocks to find and exploit your data, the flexibility of such approach is limited as opposed to a domain specific language (DSL).

In addition, an API is not always convenient when you need to compose requests, perform joins or work interactively on the database.

The goal of the quasardb querying language is to provide a syntax close to the SQL language so that users become quickly productive while leveraging the unique features of quasardb typically absent from relational databases such as native timeseries support and tags. All of this while abstracting away all the inherent complexity of distributed computing.

Queries are meant to extract small subsets of data (thousands of entries) out of very large data sets (billions of entries), fast enough to be used interactively (in a couple of seconds).

Features
-----------

The querying language currently enables you to:

 * Look up entries via a combination of tags and type
 * Extract content of time series based on time ranges
 * Perform server-side aggregations on time series
 * Group aggregations by time bucket
 * Align time series to each other

The execution planner optimizes the request to minimize network traffic.

All requests are transactional: they will not see updates that happen during the execution of the query.

Lookup examples
---------------

Find all entries that have the tag "stocks"::

    find(tag="stocks")

Find all entries that have the tags "stocks", "euro", "industry"::

    find(tag="stocks" and tag="euro" and tag="industry")

Find all entries that have the tags "stocks", "euro", "industry" but not "germany"::

    find(tag="stocks" and tag="euro" and tag="industry" and not tag="germany")

Find all entries that have the tags "stocks", "euro", "industry" but not "germany", and are a time series::

    find(tag="stocks" and tag="euro" and tag="industry" and not tag="germany" and type=ts)

Basic select examples
----------------------

.. note::
    These examples assume typical open, high, low, close, volume stocks time series.

Get everything between January 1st 2007 and January 1st 2008 (left inclusive) for the time series "stocks.apple"::

    select * from stocks.apple in range(2007, 2008)

Get everything between November 3rd 2017, 20:01:22 and December 2nd, 2017, 06:20:10 (left inclusive) for the time series "stocks.apple"::

    select * from stocks.apple in range(2017-11-03T20:01:22, 2017-12-02T06:20:10)

Get the first 10 days of 2007 for "stocks.apple"::

    select * from stocks.apple in range(2007, +10d)

Get the last second of 2017 for "stocks.apple"::

    select * from stocks.apple in range(2017, -1s)

Get the last close value for March 28th 2016::

    select last(close) from stocks.apple in range(2016-03-28, +1d)

Advanced select examples
------------------------

.. note::
    These examples assume typical open, high, low, close, volume stocks time series.

Get the hourly arithmetic mean of volume exchanged for all nasdaq stocks for yesterday::

    select arithmetic_mean(volume) from find(tag='nasdaq') in range(yesterday, +1d) group by hour

Get the daily open, high, low, close, volume for "stocks.apple" for the last 30 days::

    select first(open), max(high), min(low), last(close), sum(volume) from stocks.apple in range(today, -30d) group by day

Get the sum of volume and the number of lines for the last hour by 10 seconds group::

    select sum(volume), count(volume) from stocks.apple in range(now, -1h) group by 10s

EBNF Grammar
-------------

.. highlight:: bnf

Duration
^^^^^^^^

.. note::
    quasarDB has no awareness of your calendar

The smallest duration value is one nanosecond::

    <digit> ::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
    <predefined_duration_abbr> ::= ns | us | ms | s | min | h | d | y
    <predefined_duration_full> ::= nanosecond | microsecond | millisecond | second | minute | hour | day | year
    <predefined_duration> ::= <predefined_duration_abbr> | <predefined_duration_full>
    <composed_duration> ::=  <predefined_duration> | <composed_duration> <predefined_duration>
    <duration> ::= <digit>* <composed_duration>

Examples:

 * ``1h``: one (1) hour
 * ``minute``: one (1) minute
 * ``3min20s``: three (3) minutes and twenty (20) seconds
 * ``1y20d``: one (1) year and twenty (20) days

Absolute time point
^^^^^^^^^^^^^^^^^^^

.. note::
    All quasarDB times are UTC

Dates are in ISO format, and abbreviation are supported, for example "2008" means January 1st, 2008 at midnight::

    <digit> ::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
    <hour> ::= <digit>? <digit>
    <minute> ::= <digit>? <digit>
    <seconds> ::= <digit>? <digit>
    <nanoseconds> ::= <digit>+
    <time> ::= <hours> ":" <minutes> (":" <seconds> ("." <nanoseconds>)?)?
    <year> ::= <digit> <digit> <digit> <digit>
    <month> ::= <digit>? <digit>
    <day> ::= <digit>? <digit>
    <date> ::= <year> | <year> "-" <month> "-" <day>
    <predefined> ::= "yesterday" | "today" | "tomorrow" | "now"
    <time_point> ::= <predefined> | <date> | <date> "T" <time> "Z"?

Examples:

 * ``2008``: January the 1st 2008, midnight
 * ``2008-05-03T23:20``: May 5th, 2008 23 hours 20 minutes 0 seconds 0 nanoseconds
 * ``2008-05-03T23:20:35.9791``: May 5th, 2008 23 hours 20 minutes 35 seconds 9791 nanoseconds
 * ``2008-03-04``: March 4th 2008, midnight

Time range
^^^^^^^^^^

Time range are between two absolute time points, or one absolute time point and a duration::

    <absolute> ::= <time_point>
    <relative> ::= "+" <duration> | "-" <duration>
    <time_range> ::= "range" "(" <absolute> "," (<absolute> | <relative>) ")"

Time ranges are left inclusive, right exclusive.

Examples:

    * ``range(2008, +1d)``: The first day of 2008
    * ``range(2006, 2008)``: Between January 1st 2006 midnight and January 1st 2008 midnight
    * ``range(2008-05-03T23:20:35.9791, +1000ns)``: Between May 5th, 2008 23 hours 20 minutes 35 seconds 9791 nanoseconds and May 5th, 2008 23 hours 20 minutes 35 seconds 10791 nanoseconds

Find
^^^^

By default, all types are selected, if one or more types is selected, only those types will be returned. Thus, the grammar does not allow you to exclude a type::

    <entry_types> ::= "blob" | "int" | "integer" | "hset" | "stream" | "deque" | "ts"
    <quoted_string> ::= "\"" <utf8_string> "\"" | "'" <utf8_string> "'"
    <tag> ::= "tag=" <quoted_string>
    <type> ::= "type=" <entry_types>
    <positive> ::= <tag> | <type>
    <negative> ::= "not" <tag>
    <statement> ::= <positive> | <negative>
    <find> ::= <statement> | <statement> "and" <query>


Select
^^^^^^

Select currently requires a time range and does not support where clauses::

    <columns> ::= "*" | (<identifier> ("," <identifier>)+)
    <lookup> ::= <identifier> | <find>
    <lookup_list> ::= <lookup> ("," <lookup>)+
    <group_by> ::= "group" "by" <duration>
    <asof> ::= "asof" "(" <identifier> ")"
    <select> ::= "select" <columns> "from" <lookup_list> "in" <time_range> (<group_by>? | <asof>?)

How it works
-------------

Queries are parsed by the client API to produce an Abstract Syntax Tree (AST). The client api will then analyse the AST to determine the optimal execution order and which nodes should take part in the query execution.

The client then sends to every node the appropriate part of the AST to be executed on the server. Only the appropriate sub-results are returned to the client that will collapse everything into the final answer.

The query thus minimizes the amount of data exchanged between the server and the client.

Maximum cardinality
-------------------

When using find, an approximation of the cardinality is computed to avoid running a request on too many entries. When this happens, the API will return a "query too large" error.

The default value is set at a very safe threshold of 10,007. It can be changed through one API call.

This protects both the client and the server from running queries that could:

 * Run an excessively I/O intensive operation on the server
 * Return an unmanageable number of results to the client

If your query is flagged as "too large", there are two possible work arounds:

 * Increase the maximum allowed cardinality with the appropriate API call
 * Narrow the results of your query by including a tag whose cardinality is below the configured threshold
