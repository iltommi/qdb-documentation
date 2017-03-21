C
=

.. default-domain:: c

Introduction
------------

The quasardb C API is the lowest-level API offered but also the fastest and the most powerful.

Installing
----------

The C API package is downloadable from the quasardb download site. All information regarding the quasardb download site are in your welcome e-mail.

::

    \qdb-<version>-<platform>-c-api
        \bin        // QDB API shared libraries (.dll, Windows only)
        \examples   // C and C++ API examples
        \include    // C and C++ header files
        \lib        // QDB API shared libraries
        \share
            \doc    // This documentation


Most C functions, typedefs and enums are available in the ``include/qdb/client.h`` header file. The object specific functions for hsets, integers, double-ended queues, and tags are in their respective ``include/qdb/*.h`` files.

.. highlight:: c

Connecting to a cluster
-----------------------

The first thing to do is to initialize a handle. A handle is an opaque structure that represents a client-side instance.
It is initialized using the function :func:`qdb_open`:

.. literalinclude:: ../../../../examples/c/connect.c
    :start-after: doc-start-open
    :end-before: doc-end-open
    :dedent: 4

We can also use the convenience function :func:`qdb_open_tcp`:

.. literalinclude:: ../../../../examples/c/connect_tcp.c
    :start-after: doc-start-open
    :end-before: doc-end-open
    :dedent: 4

Once the handle is initialized, it can be used to establish a connection. This code will establish a connection to a single quasardb node listening on the localhost with the :func:`qdb_connect` function:

.. literalinclude:: ../../../../examples/c/connect.c
    :start-after: doc-start-connect
    :end-before: doc-end-connect
    :dedent: 4

Note that we could have used the IP address instead:

.. literalinclude:: ../../../../examples/c/connect_tcp.c
    :start-after: doc-start-connect
    :end-before: doc-end-connect
    :dedent: 4

.. caution::
    Concurrent calls to :func:`qdb_connect` using the same handle results in undefined behaviour.

`IPv6 <https://en.wikipedia.org/wiki/IPv6>`_ is also supported if the node listens on an IPv6 address:

.. literalinclude:: ../../../../examples/c/connect_ipv6.c
    :start-after: doc-start-connect
    :end-before: doc-end-connect
    :dedent: 4

.. note::
    When you call :func:`qdb_open` and :func:`qdb_connect`, a lot of initialization and system calls are made. It is therefore advised to reduce the calls to these functions to the strict minimum, ideally keeping the same handle alive for the lifetime of the program.

Connecting to multiple nodes within the same cluster
----------------------------------------------------

Although quasardb is fault-tolerant, if the client tries to connect to the cluster through a node that is unavailable, the connection will fail. To prevent that, it is advised to pass a URI string to :func:`qdb_connect` with multiple comma-separated hosts and ports. If the client can establish a connection with any of the nodes, the call will succeed.

.. literalinclude:: ../../../../examples/c/connect_many.c
    :start-after: doc-start-connect
    :end-before: doc-end-connect
    :dedent: 4

If the same address/port pair is present multiple times within the string, only the first occurrence is used.

Adding entries
--------------

Each entry is identified by a unique alias. See :ref:`aliases` for more information.

The content is a buffer containing arbitrary data. You need to specify the size of the content buffer. There is no built-in limit on the content's size; you just need to ensure you have enough free memory to allocate it at least once on the client side and on the server side.

There are two ways to add entries into the repository. You can use :func:`qdb_blob_put`:

.. literalinclude:: ../../../../examples/c/blob_put.c
    :start-after: doc-start-blob_put
    :end-before: doc-end-blob_put
    :dedent: 12

or you can use :func:`qdb_blob_update`:

.. literalinclude:: ../../../../examples/c/blob_update.c
    :start-after: doc-start-blob_update
    :end-before: doc-end-blob_update
    :dedent: 12

The difference is that :func:`qdb_blob_put` fails when the entry already exists. :func:`qdb_blob_update` will create the entry if it does not (and return :cpp:enum:`qdb_e_ok_created`), or update its content if it does (and return :cpp:enum:`qdb_e_ok`).
:func:`qdb_blob_update` may be called with expiry time equal to :macro:`qdb_preserve_expiration`, in which case, it will not modify the expiration of the updated entry.
Should the entry be created, it will have no expiration.
:func:`qdb_blob_put`, if called with expiry time equal to :macro:`qdb_preserve_expiration`, will behave as if the argument were equal to :macro:`qdb_never_expires`.

Getting entries
---------------

The most convenient way to fetch an entry is :func:`qdb_blob_get`:

.. literalinclude:: ../../../../examples/c/blob_get.c
    :start-after: doc-start-blob_get
    :end-before: doc-end-blob_get
    :dedent: 12

The function will allocate the buffer and update the length. You will need to release the memory later with :func:`qdb_release`:

.. literalinclude:: ../../../../examples/c/blob_get.c
    :start-after: doc-start-free_buffer
    :end-before: doc-end-free_buffer
    :dedent: 16

However, for maximum performance you might want to manage allocation yourself and reuse buffers (for example). In which case you will prefer to use :func:`qdb_blob_get_noalloc`:

.. literalinclude:: ../../../../examples/c/blob_get_noalloc.c
    :start-after: doc-start-blob_get_noalloc
    :end-before: doc-end-blob_get_noalloc
    :dedent: 12

The function will update content_length even if the buffer isn't large enough, giving you a chance to increase the buffer's size and try again.


Removing entries
----------------

Removing is done with the function :func:`qdb_remove`:

.. literalinclude:: ../../../../examples/c/remove.c
    :start-after: doc-start-remove
    :end-before: doc-end-remove
    :dedent: 12

The function fails if the entry does not exist.


Cleaning up
-----------

When you are done working with a quasardb cluster, call :func:`qdb_close`:

.. literalinclude:: ../../../../examples/c/connect.c
    :start-after: doc-start-close
    :end-before: doc-end-close
    :dedent: 4

:func:`qdb_close` **does not guarantee** to release memory allocated by :func:`qdb_blob_get`. You will need to make appropriate calls to :func:`qdb_release` for each call to :func:`qdb_blob_get`.

.. note ::

    Avoid opening and closing connections needlessly. A handle consumes very little memory and resources. It is safe to keep it open for the duration of your program.


Timeout
-------

It is possible to configure the client-side timeout with the :func:`qdb_option_set_timeout`:

.. literalinclude:: ../../../../examples/c/blob_get.c
    :start-after: doc-start-option_set_timeout
    :end-before: doc-end-option_set_timeout
    :dedent: 12

Currently running requests are not affected by the modification, only new requests will use the new timeout value. The default client-side timeout is one minute. Keep in mind that the server-side timeout might be shorter.

Expiry
------

Expiry is set with :func:`qdb_expires_at` and :func:`qdb_expires_from_now`. It is obtained with :func:`qdb_get_expiry_time`. Expiry time is always passed in as seconds, either relative to epoch (January 1st, 1970 00:00 UTC) when using :func:`qdb_expires_at` or relative to the call time when using :func:`qdb_expires_from_now`.

.. warning::
    The behavior of :func:`qdb_expires_from_now` is undefined if the time zone or the clock of the client computer is improperly configured.

To set the expiry time of an entry relatively to the call time:

.. literalinclude:: ../../../../examples/c/expires.c
    :start-after: doc-start-expires_from_now
    :end-before: doc-end-expires_from_now
    :dedent: 12

To prevent an entry from ever expiring:

.. literalinclude:: ../../../../examples/c/expires.c
    :start-after: doc-start-expires_at
    :end-before: doc-end-expires_at
    :dedent: 12

By default, entries never expire. To obtain the expiry time of an existing entry:

.. literalinclude:: ../../../../examples/c/expires.c
    :start-after: doc-start-get_expiry_time
    :end-before: doc-end-get_expiry_time
    :dedent: 12

Integers
--------

Quasardb supports signed 64-bit integers natively. All operations on integers are guaranteed to be atomic. Likes blobs, integers support put (:func:`qdb_int_put`),
update (:func:`qdb_int_update`), get (:func:`qdb_int_get`) and remove (:func:`qdb_remove`):

.. literalinclude:: ../../../../examples/c/int_basics.c
    :start-after: doc-start-int_basics
    :end-before: doc-end-int_basics
    :dedent: 12

Quasardb API defines a cross platform integer to be used with all integer operations: `qdb_int_t`. You are strongly encouraged to use this type.

In addition to basic put/update/get/remove operations, integers support atomic increment and decrement through the :func:`qdb_int_add` function:

.. literalinclude:: ../../../../examples/c/int_add.c
    :start-after: doc-start-int_add
    :end-before: doc-end-int_add
    :dedent: 12

The :func:`qdb_int_add` function requires the entry to already exist.

Quasardb integers storage on disk is highly optimized and increment/decrement use native instructions. If you are working on 64-bit signed integers, using quasardb native integers can deliver a significant performance boost compared to blobs.

Tags
----

Any entry can have an arbitrary number of tags, and you can lookup entries based on their tags. In other words, you can ask quasardb questions like "give me all the entry with the tag X". You can only tag existing entries. There is no predetermined limit on the number of tags per entry, or the number of entries a tag may refer to.

You can attach one tag at a time to an entry (:func:`qdb_attach_tag`), or several tags at once (:func:`qdb_attach_tags`):

.. literalinclude:: ../../../../examples/c/tags.c
    :start-after: doc-start-tag_attach
    :end-before: doc-end-tag_attach
    :dedent: 12

If the tag is already set, the error code returned will be :cpp:enum:`qdb_e_tag_already_set`. You can only attach tag to previously created entries.

To remove a tag, use :func:`qdb_detach_tag`:

.. literalinclude:: ../../../../examples/c/tags.c
    :start-after: doc-start-tag_detach
    :end-before: doc-end-tag_detach
    :dedent: 12

It is an error to detach a non-existing tag.

.. note::
    The :func:`qdb_attach_tags` and :func:`qdb_detach_tags` take as the tags list an array of pointers to null-terminated strings.

To retrieve the entries matching a tag, there are two possibilities: fetch everything at once or iterate on the entries.

If you think the number of returned entries will be reasonable (e.g. easily fits in RAM), you can use :func:`qdb_get_tagged`:

.. literalinclude:: ../../../../examples/c/tags.c
    :start-after: doc-start-tag_get
    :end-before: doc-end-tag_get
    :dedent: 12

.. note::
    You must use :func:`qdb_release` on the aliases returned by :func:`qdb_get_tagged`.

If you suspect the number of results to be very high, you may want to iterate over the results:

.. literalinclude:: ../../../../examples/c/tags.c
    :start-after: doc-start-tag_iterate
    :end-before: doc-end-tag_iterate
    :dedent: 12

Iteration prefetches the results to optimize network traffic and occurs on a snapshot of the database. Once you are finished with an iterator, call :func:`qdb_tag_iterator_close`. When iteration reaches the final entry, :func:`qdb_tag_iterator_next` will return  :cpp:enum:`qdb_e_iterator_end`.

Removing an entry correctly updates the associated tags, in other words, a removed entry will no longer be reported as tagged.

Forward lookup is also supported. For any entry, you can test the existence of a tag or just retrieve the list of tags:

.. literalinclude:: ../../../../examples/c/tags.c
    :start-after: doc-start-tag_meta
    :end-before: doc-end-tag_meta
    :dedent: 12

:func:`qdb_has_tag` will return :cpp:enum:`qdb_e_tag_not_set` if the tag isn't set.

.. note::
    Tags returned by :func:`qdb_get_tags` must be freed with :func:`qdb_release`.

Double-ended queues
-------------------

.. warning::
    Experimental feature

Double-ended queues (deques) are distributed containers that support concurrent insertion and removal at the beginning and the end. Random access to any element within the deque is also supported.

The flexibility of the deque API enables you to implement at-most-once and at-least-once semantics.

There is no limit to the number of entries in a deque, no limit to the size of the entries within the deque.

To create a deque, you push elements to it using either :func:`qdb_deque_push_front` or :func:`qdb_deque_push_back`. Each function has a constant complexity and will span the deque accross nodes as it grows.

.. literalinclude:: ../../../../examples/c/deque.c
    :start-after: doc-start-deque_push
    :end-before: doc-end-deque_push
    :dedent: 12

Push operations are atomic and safe to use concurrently.

To access elements within a deque, you can either use :func:`qdb_deque_front`, :func:`qdb_deque_back` or :func:`qdb_deque_get_at`. Each function has a constant complexity, independant of the length of the deque. The :func:`qdb_deque_get_at` function uses 0 based index, 0 representing the front item.

.. literalinclude:: ../../../../examples/c/deque.c
    :start-after: doc-start-deque_axx
    :end-before: doc-end-deque_axx
    :dedent: 12

It is possible to atomically update any entry within the deque with :func:`qdb_deque_set_at`:

.. literalinclude:: ../../../../examples/c/deque.c
    :start-after: doc-start-deque_set
    :end-before: doc-end-deque_set
    :dedent: 12

.. note::
    You must call :func:`qdb_release` on entries returned by deque accessors.

In addition to accessing entries, it is also possible to atomically remove and retrieve an entry with the :func:`qdb_deque_pop_front` and :func:`qdb_deque_pop_back` functions:

.. literalinclude:: ../../../../examples/c/deque.c
    :start-after: doc-start-deque_pop
    :end-before: doc-end-deque_pop
    :dedent: 12

.. note::
    You must call :func:`qdb_release` on entries returned by :func:`qdb_deque_pop_front`, :func:`qdb_deque_pop_back` and :func:`qdb_deque_get_at`.

A deque can be empty. You can query the size of the deque with the :func:`qdb_deque_size` function:

.. literalinclude:: ../../../../examples/c/deque.c
    :start-after: doc-start-deque_size
    :end-before: doc-end-deque_size
    :dedent: 12

To fully a deque, use :func:`qdb_remove`, like any other entry type:

.. literalinclude:: ../../../../examples/c/deque.c
    :start-after: doc-start-deque_remove
    :end-before: doc-end-deque_remove
    :dedent: 12

Removing a deque has a linear complexity.

Hashed sets
-----------

.. warning::
    Experimental feature

Hashed sets are distributed over the nodes and have no limit in the number of entries or the size of the entries. Hashed set currently support only insertion, erasure and querying. Entries are hashed using a cryptographically strong 256-bit hash, making collision extremely unlikely.

Insertion, access and removal are logarithmic respective to the size of the set.

To create a set, you insert an entry to a previously non existing set with :func:`qdb_hset_insert`:

.. literalinclude:: ../../../../examples/c/hset.c
    :start-after: doc-start-hset_insert
    :end-before: doc-end-hset_insert
    :dedent: 12

When you need to remove an entry from a set, use :func:`qdb_hset_erase`:

.. literalinclude:: ../../../../examples/c/hset.c
    :start-after: doc-start-hset_erase
    :end-before: doc-end-hset_erase
    :dedent: 12

To test the existence of an entry within a set, use :func:`qdb_hset_contains`:

.. literalinclude:: ../../../../examples/c/hset.c
    :start-after: doc-start-hset_contains
    :end-before: doc-end-hset_contains
    :dedent: 12

To fully remove a set, use :func:`qdb_remove`, like any other entry type:

.. literalinclude:: ../../../../examples/c/hset.c
    :start-after: doc-start-hset_remove
    :end-before: doc-end-hset_remove
    :dedent: 12

Batch operations
----------------

Batch operations can greatly increase performance when it is necessary to run many small operations. Using batch operations requires initializing, running and freeing an array of operations.

The :func:`qdb_init_operations` ensures that the operations are properly reset before setting any value:

.. literalinclude:: ../../../../examples/c/batch.c
    :start-after: doc-start-init_operations
    :end-before: doc-end-init_operations
    :dedent: 12

Once this is done, you can fill the array with the operations you would like to run. :func:`qdb_init_operations` makes sure all the values have proper defaults:

.. literalinclude:: ../../../../examples/c/batch.c
    :start-after: doc-start-batch-create
    :end-before: doc-end-batch-create
    :dedent: 16

You now have an operations batch that can be run on the cluster:

.. literalinclude:: ../../../../examples/c/batch.c
    :start-after: doc-start-run_batch
    :end-before: doc-end-run_batch
    :dedent: 16

Note that the order in which operations run is undefined. Error management with batch operations is a little bit more delicate than with other functions. :func:`qdb_run_batch` returns the number of successful operations. If this number is not equal to the number of submitted operations, it means you have an error.

The error field of each operation is updated to reflect its status. If it is not :cpp:enum:`qdb_e_ok` or :cpp:enum:`qdb_e_ok_created`, an error occured.

Let's imagine the previous example returned an error. Here is some simple code for error detection:

.. literalinclude:: ../../../../examples/c/batch.c
    :start-after: doc-start-error
    :end-before: doc-end-error
    :dedent: 16

What you must do when an error occurs is entirely dependent on your application.

In our case, there have been four operations, two blob gets, one blob update and one int increase. In the case of the update, we only care if the operation has been successful or not. But what about the gets and the increase? The content is available in the result field for blobs:

.. literalinclude:: ../../../../examples/c/batch.c
    :start-after: doc-start-results-blob
    :end-before: doc-end-results-blob
    :dedent: 16

And for the integer in result_value:

.. literalinclude:: ../../../../examples/c/batch.c
    :start-after: doc-start-results-int
    :end-before: doc-end-results-int
    :dedent: 16

Once you are finished with a series of batch operations, you must release the memory that the API allocated using :func:`qdb_release`. The call releases all buffers at once:

.. literalinclude:: ../../../../examples/c/batch.c
    :start-after: doc-start-free_operations
    :end-before: doc-end-free_operations
    :dedent: 16

Memory management
-----------------

You may have noticed the :func:`qdb_release` function. It takes two parameters: a handle and a buffer. Internally, the quasardb API will track every buffer it allocated. When you pass a structure to the :func:`qdb_release` function it knows all the attached resources that must be freed.

For example if you ran a batch, it may have resulted in client-side allocations. When passing the pointer to your batch array to the :func:`qdb_release`, every allocated buffer, if any, will be freed. There is no need to call the function for each item in the batch.

To sum up: for every function that allocates memory, release the resource with :func:`qdb_release`.

Iteration
---------

Iteration on the cluster's entries can be done forward and backward. You initialize the iterator with :func:`qdb_iterator_begin` or :func:`qdb_iterator_rbegin` depending on whether you want to start from the first entry or the last entry.

Actual iteration is done with :func:`qdb_iterator_next` and :func:`qdb_iterator_previous`. Once completed, the iterator should be freed with :func:`qdb_iterator_close`:

.. literalinclude:: ../../../../examples/c/iterator.c
    :start-after: doc-start-iterator_begin
    :end-before: doc-end-iterator_begin
    :dedent: 12

.. literalinclude:: ../../../../examples/c/iterator.c
    :start-after: doc-start-iterator_rbegin
    :end-before: doc-end-iterator_rbegin
    :dedent: 12

.. note::
    Although each entry is returned only once, the order in which entries are returned is undefined.

Queries
--------

To run a query on quasardb, use the function :func:`qdb_query`. It will return a list of aliases that matches the specified query.

.. literalinclude:: ../../../../examples/c/query.c
    :start-after: doc-start-query
    :end-before: doc-end-query
    :dedent: 12

Aliases returned by :func:`qdb_query` must be freed with :func:`qdb_release`. For more information about queries, see :doc:`../api/queries`.

Streaming
---------

Use the streaming API to read or write portions of large entries in linear packets. There is no limit to the size of entries that can be streamed to or from the client.
First, one should open the stream handle choosing an appropriate mode:

.. literalinclude:: ../../../../examples/c/stream_write.c
    :start-after: doc-start-stream_open
    :end-before: doc-end-stream_open
    :dedent: 4

Then, you can stream in (write) as much data as you wish:

.. literalinclude:: ../../../../examples/c/stream_write.c
    :start-after: doc-start-stream_write
    :end-before: doc-end-stream_write
    :dedent: 8

To get the current size of the stream, in bytes, there is :func:`qdb_stream_size`:

.. literalinclude:: ../../../../examples/c/stream_write.c
    :start-after: doc-start-stream_size
    :end-before: doc-end-stream_size
    :dedent: 8

Logging
-------

It can be useful for debugging and information purposes to obtain all logs. The C API provides access to the internal log system through a callback which is called each time the API has to log something.

.. warning::
    Improper usage of the logging API can seriously affect the performance and the reliability of the quasardb API. Make sure your logging callback is as simple as possible.

The thread and context in which the callback is called is undefined and the developer should not assume anything about the memory layout. However, calls to the callback are not concurrent: the user only has to take care of thread safety in the context of its application. In other words, **calls are serialized**.

Logging is asynchronous, however buffers are flushed when :func:`qdb_close` is successfully called.

The callback profile is the following:

.. literalinclude:: ../../../../examples/c/log_callback.c
    :start-after: doc-start-log_callback
    :end-before: doc-end-log_callback

The parameters passed to the callback are:

    * *log_level:* a qdb_log_level_t describing the log_level. The possible values are: qdb_log_detailed, qdb_log_debug, qdb_log_info, qdb_log_warning, qdb_log_error and qdb_log_panic.
    * *date:* an array of six unsigned longs describing the timestamp of the log message. They are ordered as such: year, month, day, hours, minutes, seconds. The time is in 24h format.
    * *pid:* the process id of the log message.
    * *tid:* the thread id of the log message.
    * *message_buffer:* a null-terminated buffer that is valid only in the context of the callback.
    * *message_size:* the size of the buffer, in bytes.

Here is a callback example:

.. literalinclude:: ../../../../examples/c/log_callback.c
    :start-after: doc-start-my_log_callback
    :end-before: doc-end-my_log_callback

Setting the callback is done with :func:`qdb_log_add_callback`:

.. literalinclude:: ../../../../examples/c/log_callback.c
    :start-after: doc-start-log_add_callback
    :end-before: doc-end-log_add_callback
    :dedent: 12

If you later wish to unregister the callback:

.. literalinclude:: ../../../../examples/c/log_callback.c
    :start-after: doc-start-log_remove_callback
    :end-before: doc-end-log_remove_callback
    :dedent: 16

You may pass a null pointer as callback identifier to :func:`qdb_log_add_callback`, but then you will lose the possibility to unregister it.

.. literalinclude:: ../../../../examples/c/log_callback.c
    :start-after: doc-start-log_add_callback-no-cid
    :end-before: doc-end-log_add_callback-no-cid
    :dedent: 12

.. warning::
    Multiple calls to :func:`qdb_log_add_callback` will result in several callbacks being registered. Registering the same callback multiple times results in undefined behaviour.


Reference
---------

General
^^^^^^^

.. doxygengroup:: client
  :content-only:


Error codes
^^^^^^^^^^^

.. doxygengroup:: error
  :content-only:

Queries
^^^^^^^^

.. doxygengroup:: query
  :content-only:

Blobs
^^^^^^

.. doxygengroup:: blob
  :content-only:

Batches
^^^^^^^

.. doxygengroup:: batch
  :content-only:

Deques
^^^^^^

.. doxygengroup:: deque
  :content-only:

Integers
^^^^^^^^

.. doxygengroup:: integer
  :content-only:

Hash sets
^^^^^^^^^

.. doxygengroup:: hset
  :content-only:

Prefix
^^^^^^

.. doxygengroup:: prefix
  :content-only:


Streams
^^^^^^^

.. doxygengroup:: stream
  :content-only:

Tags
^^^^

.. doxygengroup:: tag
  :content-only:

Time series
^^^^^^^^^^^

.. doxygengroup:: ts
  :content-only:
