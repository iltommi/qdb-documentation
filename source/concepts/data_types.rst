Data Types
**********

Blobs
^^^^^

By default, entries in quasardb are treated as binary objects or blobs. There is no predefined limit on how large a blob can be, for example, entries of hundreds of megabytes are fully supported provided your server has enough available memory.

quasardb will attempt to compress the provided data, if the result is not smaller than the original, the data will be sent "as is".

Blobs are suitable to store binary data or text of any size. When you don't know how to store your data in quasardb, use a blob.

Integers
^^^^^^^^

quasardb provides native, signed 64-bit integers. Native signed integers allow you to perform concurrent, atomic increments and decrements on the value with little overhead.

For example, your client can send the request "add 10 to this value, whatever its current value is". If several concurrent clients send the same request, all requests are guaranteed to be acknowledged and the result will be consistent.

Double-Ended Queues
^^^^^^^^^^^^^^^^^^^

Double-ended queues or "deques" are an ordered collection of blobs. They support concurrent and efficient insertion or removal, but only at the beginning and the end of the queue. You can query the current size of the queue in constant time and access elements of the queue by index.

Queue elements are blobs and can be of any size. Values smaller than 64 bytes benefit from optimized storage.

Double-ended queues are transparently distributed over several nodes and have no predefined length limit.

If running in Transient Mode, double-ended queues may be undefined due to eviction if you reach the memory limit.

Distributed Hash Sets
^^^^^^^^^^^^^^^^^^^^^

A distributed hash set is an unordered collection of blobs that must be unique. They support efficient insertion into and removal from the set.

Hash set elements are blobs and can be of any size. Values smaller than 64 bytes benefit from optimized storage.

Hash sets are transparently distributed over several nodes and have no predefined length limit.

Time series
^^^^^^^^^^^^

Time series are distributed, ordered in time collections with nanosecond granularity timestamps. They support efficient insertion at the end of the time series and insertion anywhere within the time series.

Time series are column oriented and can have an arbitrary number of columns, each column has an unique name. Columns can be renamed, added and removed after the creation of the time series.

Each time series bucket is efficiently stored on disk using temporal compression algorithms, if possible.

Server-side aggregations on time series columns is supported and will use the enhanced instruction set of the processor for maximum throughput, if available. Aggregations are distributed transparently over the cluster.

Time series buckets are transparently distributed over several nodes and have no predefined length limit.

For more information, :doc:`../api/time_series`.
