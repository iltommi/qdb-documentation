Streams
=======

.. highlight:: python

.. note::
    Streams are available starting with quasardb 2.0.0.

Features
---------

A stream is an entry type that supports efficient storage and retrieval of large binary entries.

It is possible to randomly seek within, append, and truncate a stream and there is no practical limit to the size of a stream.

Design
-------

Streams are split in chunks of one megabyte blobs. The streaming API takes care of maintaining consistence accross the blobs as you write to the stream. A separate metadata entry holds the size of the stream and various upkeeping information that enable the API to seek efficiently. The metadata information has a constant size, regardless of the stream size.

Since it is based on blobs, streams chunks are replicated and migrated like regular blobs.

When to use
-----------

You should consider streams when:

  * The entry size represents more than 5% of the total RAM available on the cluster.
  * You need to efficiently read from/write to the cluster in chunks
  * You want the content of your entry to be spread over the cluster

When not to use
---------------

Streams should not be used when the total size of the entry will never exceed one megabyte.

Performance
-----------

The larger the stream, the better the performance compared to a single blob.