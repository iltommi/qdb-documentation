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

The querying language currently enables you to look up entries by tag and type and compose them inclusively. It is also possible to exclude the presence of a tag.

The execution planner optimizes the request to minimize network traffic.

All requests are transactional: they will not see updates that happen during the execution of the query.

Examples
----------

Find all entries that have the tag "stocks"::

    tag="stocks"

Find all entries that have the tags "stocks", "euro", "industry"::

    tag="stocks" and tag="euro" and tag="industry"

Find all entries that have the tags "stocks", "euro", "industry" but not "germany"::

    tag="stocks" and tag="euro" and tag="industry" and not tag="germany"

Find all entries that have the tags "stocks", "euro", "industry" but not "germany", and are a time series::

    tag="stocks" and tag="euro" and tag="industry" and not tag="germany" and type=ts

BNF Grammar
-------------

.. highlight:: bnf

By default, all types are selected, if one or more types is selected, only those types will be returned. Thus, the grammar does not allow you to exclude a type::

    <entry_types> ::= "blob" | "int" | "integer" | "hset" | "stream" | "deque" | "ts"
    <quoted_string> ::= "\"" <utf8_string> "\"" | "'" <utf8_string> "'"
    <tag> ::= "tag=" <quoted_string>
    <type> ::= "type=" <entry_types>
    <positive> ::= <tag> | <type>
    <negative> ::= "not" <tag>
    <statement> ::= <positive> | <negative>
    <query> ::= <statement> | <statement> "and" <query>

How it works
-------------

Queries are parsed by the client API to produce an Abstract Syntax Tree (AST). The client api will then analyse the AST to determine the optimal execution order and which nodes should take part in the query execution.

To compute the optimal execution order, an approximation of the cardinality of each part of the query is computed. Since estimating the cardinality can be extremely I/O intensive for very large subsets (hundres of millions of entries), the query planner has an internal safety to stop at a certain threshold (the default value is set at a very safe threshold of 10,007. It can be changed through one API call). When this threshold is exceeded, the query asumes the data set to be *large*.

The client then sends to every node the appropriate part of the AST to be executed on the server. Only the appropriate sub-results are returned to the client that will collapse everything into the final answer.

This results in both minimum network traffic and low latency operations.

Maximum cardinality
-------------------

A query that **only works on large sets has little to no optimization opportunities** and the API will therefore refuse to run and return a "query too large" error.

This protects both the client and the server from running queries that could:

 * Run an excessively I/O intensive operation on the server
 * Return an unmanageable number of results to the client

If your query is flagged as "too large", there are two possible work arounds:

 * Increase the maximum allowed cardinality with the appropriate API call
 * Narrow the results of your query by including a tag whose cardinality is below the configured threshold

How to use
---------------

Each API provides a function that takes as an input a query and returns the list of matching aliases.

