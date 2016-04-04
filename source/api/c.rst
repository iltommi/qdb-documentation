C
==

.. default-domain:: c
.. highlight:: c

Introduction
--------------

The quasardb C API is the lowest-level API offered but also the fastest and the most powerful.

Installing
--------------

The C API package is downloadable from the quasardb download site. All information regarding the quasardb download site are in your welcome e-mail.

    \qdb-capi-<version>
          \doc        // This documentation
          \example    // C and C++ API examples
          \include    // C and C++ header files
          \lib        // QDB API shared libraries


Most C functions, typedefs and enums are available in the ``include/qdb/client.h`` header file. The object specific functions for hsets, integers, double-ended queues, and tags are in their respective ``include/qdb/*.h`` files.


Connecting to a cluster
--------------------------

The first thing to do is to initialize a handle. A handle is an opaque structure that represents a client side instance.
It is initialized using the function :func:`qdb_open`::

    qdb_handle_t handle = 0;
    qdb_error_t r = qdb_open(&handle, qdb_proto_tcp);
    if (r != qdb_error_ok)
    {
        // error management
    }

We can also use the convenience function :func:`qdb_open_tcp`::

    qdb_handle_t handle = qdb_open_tcp();
    if (!handle)
    {
        // error management
    }

Once the handle is initialized, it can be used to establish a connection. Keep in mind that the API does not actually keep the connection alive all the time. Connections are opened and closed as needed. This code will establish a connection to a single quasardb node listening on the localhost with the :func:`qdb_connect` function::

    qdb_error_t connection = qdb_connect(handle, "qdb://localhost:2836");
    if (connection != qdb_error_ok)
    {
        // error management
    }

Note that we could have used the IP address instead::

    qdb_error_t connection = qdb_connect(handle, "qdb://127.0.0.1:2836");
    if (connection != qdb_error_ok)
    {
        // error management
    }

.. caution::
    Concurrent calls to :func:`qdb_connect` using the same handle results in undefined behaviour.

`IPv6 <https://en.wikipedia.org/wiki/IPv6>`_ is also supported if the node listens on an IPv6 address::

    qdb_error_t connection = qdb_connect(handle, "qdb://::1:2836");
    if (connection != qdb_error_ok)
    {
        // error management
    }

.. note::
    When you call :func:`qdb_open` and :func:`qdb_connect`, a lot of initialization and system calls are made. It is therefore advised to reduce the calls to these functions to the strict minimum, ideally keeping the same handle alive for the lifetime of the program.

Connecting to multiple nodes within the same cluster
------------------------------------------------------

Although quasardb is fault tolerant, if the client tries to connect to the cluster through a node that is unavailable, the connection will fail. To prevent that, it is advised to pass a uri string to qdb_connect with multiple comma-separated hosts and ports. If the client can establish a connection with any of the nodes, the call will succeed. ::

    const char * remote_nodes = "qdb://192.168.1.1:2836,192.168.1.2:2836,192.168.1.3:2836";

    // the function will return 1 if any of the connections succeed.
    qdb_error_t connections = qdb_connect(handle, remote_nodes);
    if (connections != qdb_error_ok)
    {
        // error management...
    }

If the same address/port pair is present multiple times within the string, only the first occurrence is used.

Adding entries
-----------------

Each entry is identified by an unique alias. You pass the alias as a null-terminated string. The alias may contain arbitrary characters but it's probably more convenient to use printable characters only.

The content is a buffer containing arbitrary data. You need to specify the size of the content buffer. There is no built-in limit on the content's size; you just need to ensure you have enough free memory to allocate it at least once on the client side and on the server side.

There are two ways to add entries into the repository. You can use :func:`qdb_blob_put`::

    char content[100];

    // ...

    r = qdb_blob_put(handle, "myalias", content, sizeof(content), 0);
    if (r != qdb_error_ok)
    {
        // error management
    }

or you can use :func:`qdb_blob_update`::

    char content[100];

    // ...

    r = qdb_blob_update(handle, "myalias", content, sizeof(content), 0);
    if (r != qdb_error_ok)
    {
        // error management
    }

The difference is that :func:`qdb_blob_put` fails when the entry already exists. :func:`qdb_blob_update` will create the entry if it does not, or update its content if it does.

Getting entries
--------------------

The most convenient way to fetch an entry is :func:`qdb_blob_get`::

    char * allocated_content = 0;
    qdb_size_t allocated_content_length = 0;
    r = qdb_blob_get(handle, "myalias", &allocated_content, &allocated_content_length);
    if (r != qdb_error_ok)
    {
        // error management
    }

The function will allocate the buffer and update the length. You will need to release the memory later with :func:`qdb_free_buffer`::

    qdb_free_buffer(allocated_content);

However, for maximum performance you might want to manage allocation yourself and reuse buffers (for example). In which case you will prefer to use :func:`qdb_blob_get_noalloc`::

    char buffer[1024];

    size content_length = sizeof(buffer);

    // ...

    // content_length must be initialized with the buffer's size
    // and will be update with the retrieved content's size
    r = qdb_blob_get_noalloc(handle, "myalias", buffer, &content_length);
    if (r != qdb_error_ok)
    {
        // error management
    }

The function will update content_length even if the buffer isn't large enough, giving you a chance to increase the buffer's size and try again.


Removing entries
---------------------

Removing is done with the function :func:`qdb_remove`::

    r = qdb_remove(handle, "myalias");
    if (r != qdb_error_ok)
    {
        // error management
    }

The function fails if the entry does not exist.


Cleaning up
--------------------

When you are done working with a quasardb repository, call :func:`qdb_close`::

    qdb_close(handle);

:func:`qdb_close` **does not** release memory allocated by :func:`qdb_blob_get`. You will need to make appropriate calls to :func:`qdb_free_buffer` for each call to :func:`qdb_blob_get`.

.. note ::

    Avoid opening and closing connections needlessly. A handle consumes very little memory and resources. It is safe to keep it open for the duration of your program.

Timeout
-------

It is possible to configure the client-side timeout with the :func:`qdb_option_set_timeout`::

    // sets the timeout to 5000 ms
    qdb_option_set_timeout(h, 5000);

Currently running requests are not affected by the modification, only new requests will use the new timeout value. The default client-side timeout is one minute. Keep in mind that the server-side timeout might be shorter.

Expiry
-------

Expiry is set with :func:`qdb_expires_at` and :func:`qdb_expires_from_now`. It is obtained with :func:`qdb_get_expiry_time`. Expiry time is always passed in as seconds, either relative to epoch (January 1st, 1970 00:00 UTC) when using :func:`qdb_expires_at` or relative to the call time when using :func:`qdb_expires_from_now`.

.. danger::
    The behavior of :func:`qdb_expires_from_now` is undefined if the time zone or the clock of the client computer is improperly configured.

To set the expiry time of an entry to 1 minute, relative to the call time::

    char content[100];

    // ...

    r = qdb_blob_put(handle, "myalias", content, sizeof(content), 0);
    if (r != qdb_error_ok)
    {
        // error management
    }

    r = qdb_expires_from_now(handle, "myalias", 60);
    if (r != qdb_error_ok)
    {
        // error management
    }

To prevent an entry from ever expiring::

    r = qdb_expires_at(handle, "myalias", 0);
    if (r != qdb_error_ok)
    {
        // error management
    }

By default, entries never expire. To obtain the expiry time of an existing entry::

    qdb_time_t expiry_time = 0;
    r = qdb_get_expiry_time(handle, "myalias", &expiry_time);
    if (r != qdb_error_ok)
    {
        // error management
    }

Batch operations
-----------------

Batch operations can greatly increase performance when it is necessary to run many small operations. Using batch operations requires initializing, running and freeing an array of operations.

The :func:`qdb_init_operations` ensures that the operations are properly reset before setting any value::

    qdb_operation_t ops[4];
    r = qdb_init_operations(ops, 4);
    if (r != qdb_error_ok)
    {
        // error management
    }

Once this is done, you can fill the array with the operations you would like to run. :func:`qdb_init_operations` makes sure all the values have proper defaults::

    // the first operation will be a get for "entry1"
    ops[0].type = qdb_op_get_alloc;
    ops[0].alias = "entry1";

    // the second operation will be a get for "entry2"
    ops[1].type = qdb_op_get_alloc;
    ops[1].alias = "entry2";

    char content[100];

    // the third operation will be an update for "entry3"
    ops[2].type = qdb_op_update;
    ops[2].alias = "entry3";
    ops[2].content = content;
    ops[2].content_size = 100;

    // the fourth operation will be increasing an integer "int_value" by 42
    ops[3].type = qdb_op_int_inc_dec;
    ops[3].alias = "int_value";
    ops[3].int_op.value = 42;

You now have an operations batch that can be run on the cluster::

    // runs the three operations on the cluster
    qdb_size_t success_count = qdb_run_batch(handle, ops, 4);
    if (success_count != 4)
    {
        // error management
    }

Note that the order in which operations run is undefined. Error management with batch operations is a little bit more delicate than with other functions. :func:`qdb_run_batch` returns the number of successful operations. If this number is not equal to the number of submitted operations, it means you have an error.

The error field of each operation is updated to reflect its status. If it is not qdb_e_ok, an error occured.

Let's imagine the previous example returned an error. Here is some simple code for error detection::

    if (success_count != 4)
    {
        for(qdb_size_t i = 0; i < 4; ++i)
        {
            if (ops[i].error != qdb_e_ok)
            {
                // we have an error in this operation
            }
        }
    }

What you must do when an error occurs is entirely dependent on your application.

In our case, there have been four operations, two blob gets, one blob update and one int increase. In the case of the update, we only care if the operation has been successful or not. But what about the gets and the increase? The content is available in the result field for blobs::

    const char * entry1_content = ops[0].result;
    qdb_size_t entry1_size = ops[0].result_size;

    const char * entry2_content = ops[1].result;
    qdb_size_t entry2_size = ops[1].result_size;

And for the integer in result_value::

    qdb_int_t result_value = ops[3].int_op.result_vale;

Once you are finished with a series of batch operations, you must release the memory that the API allocated using :func:`qdb_free_operations`. The call releases all buffers at once::

    r = qdb_free_operations(ops, 4);
    if (r != qdb_error_ok)
    {
        // error management
    }

Iteration
-----------

Iteration on the cluster's entries can be done forward and backward. You initialize the iterator with :func:`qdb_iterator_begin` or :func:`qdb_iterator_rbegin` depending on whether you want to start from the first entry or the last entry.

Actual iteration is done with :func:`qdb_iterator_next` and :func:`qdb_iterator_previous`. Once completed, the iterator should be freed with :func:`qdb_iterator_close`::

    qdb_const_iterator_t it;

    // forward loop
    for(qdb_error_t err = qdb_iterator_begin(h, &it); err == qdb_e_ok; err = qdb_iterator_next(&it))
    {
        // work on entry
        // it.content and it.content_size is the entry content
    }

    qdb_iterator_close(&it);

    // backward loop
    for(qdb_error_t err = qdb_iterator_rbegin(h, &it); err = qdb_e_ok; err = qdb_iterator_previous(&it))
    {
        // work on entry
        // it.content and it.content_size is the entry content
    }

    qdb_iterator_close(&it);

.. note::
    Although each entry is returned only once, the order in which entries are returned is undefined.

Streaming
----------

Use the streaming API to read or write portions of large entries in linear packets. There is no limit to the size of entries that can be streamed to or from the client. ::

    char * content = load_video("large_video_file.mp4"); // large amount of data
    qdb_stream_t * stream;
    qdb_stream_mode_t mode = qdb_stream_mode_write;

    qdb_stream_open(handle, alias, mode, stream)

    status = qdb_stream_write(stream, content, sizeof(content));
    if (status != qdb_error_ok)
    {
        // error management
    }


Logging
----------

It can be useful for debugging and information purposes to obtain all logs. The C API provides access to the internal log system through a callback which is called each time the API has to log something.

.. warning::
    Improper usage of the logging API can seriously affect the performance and the reliability of the quasardb API. Make sure your logging callback is as simple as possible.

The thread and context in which the callback is called is undefined and the developer should not assume anything about the memory layout. However, calls to the callback are not concurrent: the user only has to take care of thread safety in the context of its application. In other words, **calls are serialized**.

Logging is asynchronous, however buffers are flushed when :func:`qdb_close` is successfully called.

The callback profile is the following::

     void qdb_log_callback(const char * log_level,       // qdb log level
                           const unsigned long * date,   // [years, months, day, hours, minute, seconds] (valid only in the context of the callback)
                           unsigned long pid,            // process id
                           unsigned long tid,            // thread id
                           const char * message_buffer,  // message buffer (valid only in the context of the callback)
                           qdb_size_t message_size);         // message buffer size


The parameters passed to the callback are:

    * *log_level:* a null-terminated string describing the log level for the message. The possible log levels are: detailed, debug, info, warning, error and panic. The string is static and valid as long as the dynamic library remains loaded in memory.
    * *date:* an array of six unsigned longs describing the timestamp of the log message. They are ordered as such: year, month, day, hours, minutes, seconds. The time is in 24h format.
    * *pid:* the process id of the log message.
    * *tid:* the thread id of the log message.
    * *message_buffer:* a null-terminated buffer that is valid only in the context of the callback.
    * *message_size:* the size of the buffer, in bytes.

Here is a callback example::

     void my_log_callback(const char * log_level,       // qdb log level
                          const unsigned long * date,   // [years, months, day, hours, minute, seconds] (valid only in the context of the callback)
                          unsigned long pid,            // process id
                          unsigned long tid,            // thread id
                          const char * message_buffer,  // message buffer (valid only in the context of the callback)
                          qdb_size_t message_size)          // message buffer size
    {
        // will print to the console the log message, e.g.
        // 12/31/2013-23:12:01 debug: here is the message
        // note that you don't have to use all provided information, only use what you need!
        printf("%02d/%02d/%04d-%02d:%02d:%02d %s: %s", date[1], date[2], date[0], date[3], date[4], date[5], log_level, message_buffer);
    }

Setting the callback is done with :func:`qdb_option_add_log_callback`::


    qdb_log_callback_id cid = 0; 

    qdb_option_add_log_callback(my_log_callback, &cid);

If you later wish to unregister the callback::

    qdb_option_remove_log_callback(cid);

.. warning::
    Multiple calls to :func:`qdb_option_add_log_callback` will result in several callbacks being registered. Registering the same callback multiple times results in undefined behaviour.


Reference
----------------

General
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. doxygengroup:: client
  :content-only:

Error codes 
^^^^^^^^^^^^^^^^^^

.. doxygengroup:: error
  :content-only:


Blobs
^^^^^^^^^^^^^^^^^^

.. doxygengroup:: blob
  :content-only:

Batches 
^^^^^^^^^^^^^^^^^^

.. doxygengroup:: batch
  :content-only:

Deques
^^^^^^^^^^^^^^^^^^

.. doxygengroup:: deque
  :content-only:

Integers
^^^^^^^^^^^^^^^^^^

.. doxygengroup:: integer
  :content-only:

Hash sets
^^^^^^^^^^^^^^^^^^

.. doxygengroup:: hset
  :content-only:

Prefix
^^^^^^^^^^^^^^^^^^

.. doxygengroup:: prefix
  :content-only:


Streams
^^^^^^^^^^^^^^^^^^

.. doxygengroup:: stream
  :content-only:

Tags
^^^^^^^^^^^^^^^^^^

.. doxygengroup:: tag
  :content-only: