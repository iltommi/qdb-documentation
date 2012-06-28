Glossary
========

Here is a list of definitions of words in the context of this documentation.

.. glossary::

    alias
        A unique string of bytes identifying an entry within the hive.

    cluster
        Another word for :term:`hive`.

    content
        Arbitrary data not interpreted by wrpme.

    entry
        An association between a string named :term:`alias` and arbitrary data named :term:`content`. An entry can also be understood as a pair (:term:`alias`, :term:`content`).

    grid
        A set of :term:`nodes <node>`.

    hive
        A set of peer-to-peer wrpme nodes configured to work as a single distributed :term:`repository`.

    node
        An active computer attached to a network.

    predecessor
        An entry or node whose ID is lower than the considered ID

    repository
        A software module enabling data storage and retrieval.

    server
        A running instance of a wrpme daemon. On most setups only one server runs on any given :term:`node`.

    stable
        A :term:`hive` is stable if all its elements have a valid and appropriate predecessor and successor.

    stabilization
        The process that makes a :term:`hive` :term:`stable`.

    successor
        An entry or node whose ID is greater than the considered ID

    transient
        A :term:`server` whose content is not persisted.
