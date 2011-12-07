Glossary
========

Here is a list of definitions of words in the context of this documentation.

.. glossary::

    alias
        An unique string of bytes identifying an entry within a given cluster.
        
    cluster
        Another word for :term:`ring`.
        
    content
        Arbitrary data not interpreted by the cluster.
        
    entry        
        An association between a string named :term:`alias` and arbitrary data named :term:`content`. An entry can also be understood as a pair (:term:`alias`, :term:`content`).
        
    grid
        A set of nodes.
        
    node
        An active computer attached to a network.
       
    pair
        A collection of two objects. The first entry may be referred as the left entry, and the second one as the right entry.
        
    predecessor
        The previous node on the ring
        
    ring
        A set of peer-to-peer wrpme servers distributing the load amongst themselves.
        
    server
        A running instance of a wrpme daemon. On most setups only one server runs on any given :term:`node`.
        
    stable
        A :term:`ring` is stable if all its elements have a valid and appropriate predecessor and successor.
        
    stabilization
        The process that makes a :term:`ring` :term:`stable`.
        
    successor
        The next node on the ring
        
    transient
        A :term:`server` whose content is not persisted.