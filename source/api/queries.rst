quasardb queries
======================

.. cpp:namespace:: qdb
.. highlight:: sql

.. warning::
    The querying language is a feature under development.

Goal
------

Although the API gives you all the building blocks to find and exploit your data, the flexibility of such approach is limited as opposed to a domain specific language (DSL).

In addition, an API is not always convenient when you need to compose requests, perform joins or work interactively on the database.

The goal of the quasardb querying language is to provide a syntax close to the SQL language so that users become quickly productive while leveraging the unique features of quasardb typically absent from relational databases such as native timeseries support and tags. All of this while abstracting away all the inherent complexity of distributed computing.

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

Find all entries that have the tags "stocks", "euro", "industry" but not "germany", and are a double time series column::

    tag="stocks" and tag="euro" and tag="industry" and not tag="germany" and type=ts_double

BNF Grammar
-------------

.. highlight:: bnf

By default, all types are selected, if one or more types is selected, only those types will be returned. Thus, the grammar does not allow you to exclude a type::

    <entry_types> ::= "blob" | "int" | "integer" | "hset" | "stream" | "deque" | "ts_double" | "ts_blob"
    <quote_char> ::= "'" | '"'
    <quoted_string> ::=  <quote_char> <utf8_string> <quote_char>
    <tag> ::= "tag=" <quoted_string>
    <positive> ::= <tag> | <entry_types>
    <negative> ::= "not" <tag>
    <statement> ::= <positive> | <negative>
    <query> ::= <statement> | <statement> "and" <query>


How to use
---------------

Each API provides a function that takes as an input a query and returns the list of matching aliases.

