Data Types
**********

Blobs
^^^^^

By default, entries in quasardb are treated as binary objects or blobs. There is no predefined limit on how large a blob can be, for example, entries of hundreds of megabytes are fully supported provided your server has enough available memory.

quasardb will attempt to compress the provided data, if the result is not smaller than the original, the data will be sent "as is".

Blobs are suitable to store binary data or text of any size. When you don't know how to store your data in quasardb, use a blob.

Integers
^^^^^^^^

Quasardb provides native, signed 64-bit integers. Native signed integers allow you to perform concurrent, atomic increments and decrements on the value with little overhead.

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




