C
==

.. highlight:: c


.. // The functions below are linked using :c:type: not :c:func: so that Sphinx 
.. // does not add a (). This allows a reader to copy-and-paste the whole row.

Quick Reference
---------------

 =========================== ====================================== ===================
        Return Type                       Name                           Arguments     
 =========================== ====================================== ===================
  ..                          :c:type:`qdb_limits_t`;                ..
  ..                          :c:type:`qdb_compression_t`;           ..
  ..                          :c:type:`qdb_log_level_t`;             ..
  ..                          :c:type:`qdb_handle_t`;                ..
  ..                          :c:type:`qdb_const_iterator_t`;        ..
  ..                          :c:type:`qdb_remote_node_t`;           ..
  ..                          :c:type:`qdb_entry_type_t`;            ..
  ..                          :c:type:`qdb_operation_type_t`;        ..
  ..                          :c:type:`qdb_operation_t`;             ..
  ..                          :c:type:`qdb_error_t`;                 ..
  ..                          :c:type:`qdb_option_t`;                ..
  ..                          :c:type:`qdb_protocol_t`;              ..
  :c:type:`const char *`      :c:type:`qdb_error`                    (:c:type:`qdb_error_t` error);
  :c:type:`const char *`      :c:type:`qdb_version`                  (void);
  :c:type:`const char *`      :c:type:`qdb_build`                    (void);
  :c:type:`qdb_error_t`       :c:type:`qdb_open`                     (:c:type:`qdb_handle_t *` handle, :c:type:`qdb_protocol_t` proto);
  :c:type:`qdb_handle_t`      :c:type:`qdb_open_tcp`                 (void);
  :c:type:`qdb_error_t`       :c:type:`qdb_option_set_timeout`       (:c:type:`qdb_handle_t` handle, int timeout_ms);
  :c:type:`qdb_error_t`       :c:type:`qdb_option_add_log_callback`  (qdb_log_callback cb);
  :c:type:`qdb_error_t`       :c:type:`qdb_option_set_compression`   (:c:type:`qdb_handle_t` handle, qdb_compression_t comp_level);
  :c:type:`qdb_error_t`       :c:type:`qdb_connect`                  (:c:type:`qdb_handle_t` handle, :c:type:`const char *` uri);
  :c:type:`qdb_error_t`       :c:type:`qdb_close`                    (:c:type:`qdb_handle_t` handle);
  :c:type:`qdb_error_t`       :c:type:`qdb_get_noalloc`              (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`char *` content, :c:type:`size_t *` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_get`                      (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`char **` content, :c:type:`size_t *` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_copy_alloc_buffer`        (:c:type:`qdb_handle_t` handle, :c:type:`const char *` source_buffer, :c:type:`size_t` source_buffer_size, :c:type:`const char **` dest_buffer);
  :c:type:`qdb_error_t`       :c:type:`qdb_get_and_remove`           (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`char **` content, :c:type:`size_t *` content_length);
  :c:type:`void`              :c:type:`qdb_free_buffer`              (:c:type:`qdb_handle_t` handle, :c:type:`char *` buffer);
  :c:type:`qdb_error_t`       :c:type:`qdb_put`                      (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` content, :c:type:`size_t` content_length, :c:type:`qdb_time_t` expiry_time);
  :c:type:`qdb_error_t`       :c:type:`qdb_update`                   (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` content, :c:type:`size_t` content_length, :c:type:`qdb_time_t` expiry_time);
  :c:type:`qdb_error_t`       :c:type:`qdb_get_and_update`           (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` update_content, :c:type:`size_t` update_content_length, :c:type:`qdb_time_t` expiry_time, :c:type:`char **` get_content, :c:type:`size_t *` get_content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_compare_and_swap`         (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` new_value, :c:type:`size_t` new_value_length, :c:type:`const char *` comparand, :c:type:`size_t` comparand_length, :c:type:`qdb_time_t` expiry_time, :c:type:`char **` original_value, :c:type:`size_t *` original_value_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_remove`                   (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias);
  :c:type:`qdb_error_t`       :c:type:`qdb_remove_if`                (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` comparand, :c:type:`size_t` comparand_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_init_operations`          (:c:type:`qdb_operation_t *` operations, :c:type:`size_t` operations_count);
  :c:type:`size_t`            :c:type:`qdb_run_batch`                (:c:type:`qdb_handle_t` handle, :c:type:`qdb_operation_t *` operations, :c:type:`size_t` operations_count);
  :c:type:`qdb_error_t`       :c:type:`qdb_run_transaction`          (:c:type:`qdb_handle_t` handle, :c:type:`qdb_operation_t *` operations, :c:type:`size_t` operations_count, :c:type:`size_t *` failed_index);
  :c:type:`void`              :c:type:`qdb_free_operations`          (:c:type:`qdb_handle_t` handle, :c:type:`qdb_operation_t *` operations, :c:type:`size_t` operations_count);
  :c:type:`qdb_error_t`       :c:type:`qdb_expires_at`               (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`qdb_time_t` expiry_time);
  :c:type:`qdb_error_t`       :c:type:`qdb_expires_from_now`         (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`qdb_time_t` expiry_delta);
  :c:type:`qdb_error_t`       :c:type:`qdb_get_expiry_time`          (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`qdb_time_t` expiry_time);
  :c:type:`qdb_error_t`       :c:type:`qdb_get_location`             (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`qdb_remote_node_t *` location);
  :c:type:`qdb_error_t`       :c:type:`qdb_get_type`                 (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`qdb_entry_type_t *` entry_type);
  :c:type:`qdb_error_t`       :c:type:`qdb_purge_all`                (:c:type:`qdb_handle_t` handle);
  :c:type:`qdb_error_t`       :c:type:`qdb_trim_all`                 (:c:type:`qdb_handle_t` handle);
  :c:type:`qdb_error_t`       :c:type:`qdb_node_status`              (:c:type:`qdb_handle_t` handle, :c:type:`const char *` uri, :c:type:`const char **` content, :c:type:`size_t *` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_node_config`              (:c:type:`qdb_handle_t` handle, :c:type:`const char *` uri, :c:type:`const char **` content, :c:type:`size_t *` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_node_topology`            (:c:type:`qdb_handle_t` handle, :c:type:`const char *` uri, :c:type:`const char **` content, :c:type:`size_t *` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_stop_node`                (:c:type:`qdb_handle_t` handle, :c:type:`const char *` uri, :c:type:`const char *` reason);
  :c:type:`qdb_error_t`       :c:type:`qdb_iterator_begin`           (:c:type:`qdb_handle_t` handle, :c:type:`qdb_const_iterator_t *` iterator);
  :c:type:`qdb_error_t`       :c:type:`qdb_iterator_rbegin`          (:c:type:`qdb_handle_t` handle, :c:type:`qdb_const_iterator_t *` iterator);
  :c:type:`qdb_error_t`       :c:type:`qdb_iterator_next`            (:c:type:`qdb_const_iterator_t *` iterator);
  :c:type:`qdb_error_t`       :c:type:`qdb_iterator_previous`        (:c:type:`qdb_const_iterator_t *` iterator);
  :c:type:`qdb_error_t`       :c:type:`qdb_iterator_close`           (:c:type:`qdb_const_iterator_t *` iterator);
  :c:type:`qdb_error_t`       :c:type:`qdb_iterator_copy`            (:c:type:`qdb_const_iterator_t *` original, :c:type:`qdb_const_iterator_t *` copy);
  :c:type:`qdb_error_t`       :c:type:`qdb_hset_insert`              (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` content, :c:type:`size_t` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_hset_erase`               (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` content, :c:type:`size_t` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_hset_contains`            (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` content, :c:type:`size_t` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_int_put`                  (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`qdb_int` integer, :c:type:`qdb_time_t` expiry_time);
  :c:type:`qdb_error_t`       :c:type:`qdb_int_update`               (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`qdb_int` integer, :c:type:`qdb_time_t` expiry_time);
  :c:type:`qdb_error_t`       :c:type:`qdb_int_get`                  (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`qdb_int *` integer);
  :c:type:`qdb_error_t`       :c:type:`qdb_int_add`                  (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`qdb_int` addend, :c:type:`qdb_int *` result);
  :c:type:`qdb_error_t`       :c:type:`qdb_queue_size`               (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`size_t *` size);
  :c:type:`qdb_error_t`       :c:type:`qdb_queue_at`                 (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`size_t` index, :c:type:`const char **` content, :c:type:`size_t *` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_queue_push_front`         (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` content, :c:type:`size_t` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_queue_push_back`          (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` content, :c:type:`size_t` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_queue_pop_front`          (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char **` content, :c:type:`size_t` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_queue_pop_back`           (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char **` content, :c:type:`size_t` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_queue_front`              (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char **` content, :c:type:`size_t` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_queue_back`               (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char **` content, :c:type:`size_t` content_length);
  :c:type:`qdb_error_t`       :c:type:`qdb_add_tag`                  (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` tag);
  :c:type:`qdb_error_t`       :c:type:`qdb_has_tag`                  (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` tag);
  :c:type:`qdb_error_t`       :c:type:`qdb_remove_tag`               (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char *` tag);
  :c:type:`qdb_error_t`       :c:type:`qdb_get_tagged`               (:c:type:`qdb_handle_t` handle, :c:type:`const char *` tag, :c:type:`const char ***` aliases, :c:type:`size_t` aliases_count);
  :c:type:`qdb_error_t`       :c:type:`qdb_get_tags`                 (:c:type:`qdb_handle_t` handle, :c:type:`const char *` alias, :c:type:`const char ***` tags, :c:type:`size_t` tags_count);

 =========================== ====================================== ===================
 

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


Most C functions, typedefs and enums are available in the ``include/qdb/client.h`` header file. The object specific functions for hsets, integers, queues, and tags are in their respective ``include/qdb/*.h`` files.


Connecting to a cluster
--------------------------

The first thing to do is to initialize a handle. A handle is an opaque structure that represents a client side instance.
It is initialized using the function :c:func:`qdb_open`: ::

    qdb_handle_t handle = 0;
    qdb_error_t r = qdb_open(&handle, qdb_proto_tcp);
    if (r != qdb_error_ok)
    {
        // error management
    }

We can also use the convenience function :c:func:`qdb_open_tcp`: ::

    qdb_handle_t handle = qdb_open_tcp();
    if (!handle)
    {
        // error management
    }

Once the handle is initialized, it can be used to establish a connection. Keep in mind that the API does not actually keep the connection alive all the time. Connections are opened and closed as needed. This code will establish a connection to a single quasardb node listening on the localhost with the :c:func:`qdb_connect` function: ::

    qdb_error_t connection = qdb_connect(handle, "qdb://localhost:2836");
    if (connection != qdb_error_ok)
    {
        // error management
    }

Note that we could have used the IP address instead: ::

    qdb_error_t connection = qdb_connect(handle, "qdb://127.0.0.1:2836");
    if (connection != qdb_error_ok)
    {
        // error management
    }

.. caution::
    Concurrent calls to :c:func:`qdb_connect` using the same handle results in undefined behaviour.

`IPv6 <http://en.wikipedia.org/wiki/IPv6>`_ is also supported if the node listens on an IPv6 address: ::

    qdb_error_t connection = qdb_connect(handle, "qdb://::1:2836");
    if (connection != qdb_error_ok)
    {
        // error management
    }

.. note::
    When you call :c:func:`qdb_open` and :c:func:`qdb_connect`, a lot of initialization and system calls are made. It is therefore advised to reduce the calls to these functions to the strict minimum, ideally keeping the same handle alive for the lifetime of the program.

Connecting to multiple nodes within the same cluster
------------------------------------------------------

Although quasardb is fault tolerant, if the client tries to connect to the cluster through a node that is unavailable, the connection will fail. To prevent that, it is advised to pass a uri string to qdb_connect with multiple comma-separated hosts and ports. If the client can establish a connection with any of the nodes, the call will succeed.::

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

There are two ways to add entries into the repository. You can use :c:func:`qdb_put`: ::

    char content[100];

    // ...

    r = qdb_put(handle, "myalias", content, sizeof(content), 0);
    if (r != qdb_error_ok)
    {
        // error management
    }

or you can use :c:func:`qdb_update`: ::

    char content[100];

    // ...

    r = qdb_update(handle, "myalias", content, sizeof(content), 0);
    if (r != qdb_error_ok)
    {
        // error management
    }

The difference is that :c:func:`qdb_put` fails when the entry already exists. :c:func:`qdb_update` will create the entry if it does not, or update its content if it does.

Getting entries
--------------------

The most convenient way to fetch an entry is :c:func:`qdb_get`::

    char * allocated_content = 0;
    size_t allocated_content_length = 0;
    r = qdb_get(handle, "myalias", &allocated_content, &allocated_content_length);
    if (r != qdb_error_ok)
    {
        // error management
    }

The function will allocate the buffer and update the length. You will need to release the memory later with :c:func:`qdb_free_buffer`::

    qdb_free_buffer(allocated_content);

However, for maximum performance you might want to manage allocation yourself and reuse buffers (for example). In which case you will prefer to use :c:func:`qdb_get_noalloc`::

    char buffer[1024];

    size content_length = sizeof(buffer);

    // ...

    // content_length must be initialized with the buffer's size
    // and will be update with the retrieved content's size
    r = qdb_get_noalloc(handle, "myalias", buffer, &content_length);
    if (r != qdb_error_ok)
    {
        // error management
    }

The function will update content_length even if the buffer isn't large enough, giving you a chance to increase the buffer's size and try again.


Removing entries
---------------------

Removing is done with the function :c:func:`qdb_remove`::

    r = qdb_remove(handle, "myalias");
    if (r != qdb_error_ok)
    {
        // error management
    }

The function fails if the entry does not exist.


Cleaning up
--------------------

When you are done working with a quasardb repository, call :c:func:`qdb_close`::

    qdb_close(handle);

:c:func:`qdb_close` **does not** release memory allocated by :c:func:`qdb_get`. You will need to make appropriate calls to :c:func:`qdb_free_buffer` for each call to :c:func:`qdb_get`.

.. note ::

    Avoid opening and closing connections needlessly. A handle consumes very little memory and resources. It is safe to keep it open for the duration of your program.

Timeout
-------

It is possible to configure the client-side timeout with the :c:func:`qdb_option_set_timeout`::

    // sets the timeout to 5000 ms
    qdb_option_set_timeout(h, 5000);

Currently running requests are not affected by the modification, only new requests will use the new timeout value. The default client-side timeout is one minute. Keep in mind that the server-side timeout might be shorter.

Expiry
-------

Expiry is set with :c:func:`qdb_expires_at` and :c:func:`qdb_expires_from_now`. It is obtained with :c:func:`qdb_get_expiry_time`. Expiry time is always passed in as seconds, either relative to epoch (January 1st, 1970 00:00 UTC) when using :c:func:`qdb_expires_at` or relative to the call time when using :c:func:`qdb_expires_from_now`.

.. danger::
    The behavior of :c:func:`qdb_expires_from_now` is undefined if the time zone or the clock of the client computer is improperly configured.

To set the expiry time of an entry to 1 minute, relative to the call time::

    char content[100];

    // ...

    r = qdb_put(handle, "myalias", content, sizeof(content), 0);
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

The :c:func:`qdb_init_operations` ensures that the operations are properly reset before setting any value::

    qdb_operations_t ops[3];
    r = qdb_init_operations(ops, 3);
    if (r != qdb_error_ok)
    {
        // error management
    }

Once this is done, you can fill the array with the operations you would like to run. :c:func:`qdb_init_operations` makes sure all the values have proper defaults::

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

You now have an operations batch that can be run on the cluster::

    // runs the three operations on the cluster
    size_t success_count = qdb_run_batch(handle, ops, 3);
    if (success_count != 3)
    {
        // error management
    }

Note that the order in which operations run is undefined. Error management with batch operations is a little bit more delicate than with other functions. :c:func:`qdb_run_batch` returns the number of successful operations. If this number is not equal to the number of submitted operations, it means you have an error.

The error field of each operation is updated to reflect its status. If it is not qdb_e_ok, an error occured.

Let's imagine the previous example returned an error. Here is some simple code for error detection::

    if (success_count != 3)
    {
        for(size_t i = 0; i < 3; ++i)
        {
            if (ops[i].error != qdb_e_ok)
            {
                // we have an error in this operation
            }
        }
    }

What you must do when an error occurs is entirely dependent on your application. 

In our case, there have been three operations, two gets and one update. In the case of the update, we only care if the operation has been successful or not. But what about the gets? The content is available in the result field::

    const char * entry1_content = ops[0].result;
    size_t entry1_size = ops[0].result_size;

    const char * entry2_content = ops[1].result;
    size_t entry2_size = ops[1].result_size;

Once you are finished with a series of batch operations, you must release the memory that the API allocated using :c:func:`qdb_free_operations`. The call releases all buffers at once::

    r = qdb_free_operations(ops, 3);
    if (r != qdb_error_ok)
    {
        // error management
    }

Iteration
-----------

Iteration on the cluster's entries can be done forward and backward. You initialize the iterator with :c:func:`qdb_iterator_begin` or :c:func:`qdb_iterator_rbegin` depending on whether you want to start from the first entry or the last entry.

Actual iteration is done with :c:func:`qdb_iterator_next` and :c:func:`qdb_iterator_previous`. Once completed, the iterator should be freed with :c:func:`qdb_iterator_close`::

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


Logging
----------

It can be useful for debugging and information purposes to obtain all logs. The C API provides access to the internal log system through a callback which is called each time the API has to log something.

.. warning::
    Improper usage of the logging API can seriously affect the performance and the reliability of the quasardb API. Make sure your logging callback is as simple as possible.

The thread and context in which the callback is called is undefined and the developer should not assume anything about the memory layout. However, calls to the callback are not concurrent: the user only has to take care of thread safety in the context of its application. In other words, **calls are serialized**.

Logging is asynchronous, however buffers are flushed when :c:func:`qdb_close` is successfully called.

The callback profile is the following::

     void qdb_log_callback(const char * log_level,       // qdb log level
                           const unsigned long * date,   // [years, months, day, hours, minute, seconds] (valid only in the context of the callback)
                           unsigned long pid,            // process id
                           unsigned long tid,            // thread id
                           const char * message_buffer,  // message buffer (valid only in the context of the callback)
                           size_t message_size);         // message buffer size


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
                          size_t message_size)          // message buffer size
    {
        // will print to the console the log message, e.g.
        // 12/31/2013-23:12:01 debug: here is the message
        // note that you don't have to use all provided information, only use what you need!
        printf("%02d/%02d/%04d-%02d:%02d:%02d %s: %s", date[1], date[2], date[0], date[3], date[4], date[5], log_level, message_buffer);
    }

Setting the callback is done with :c:func:`qdb_option_add_log_callback`::

    qdb_option_add_log_callback(my_log_callback);

.. warning::
    It is not possible to unregister a log callback. Multiple calls to :c:func:`qdb_option_add_log_callback` will result in several callbacks being registered. Registering the same callback multiple times results in undefined behaviour.


Reference
----------------

.. c:type:: qdb_limits_t

    An enum that defines the maximum limits for entries.

.. c:type:: qdb_error_t

    An enum that represents possible error codes returned by the API functions. "No error" evaluates to 0. When the error is qdb_e_system, either errno or GetLastError (depending on the platform) will be updated with the corresponding system error.

.. c:type:: qdb_compression_t

    An enum that defines available compression levels.

.. c:type:: qdb_protocol_t

    An enum that defines available network protocols.

.. c:type:: qdb_log_level_t

    An enum that defines available log levels.

.. c:type:: qdb_handle_t

    An opaque handle that represents a quasardb client instance.

.. c:type:: qdb_log_callback

    The required profile of a log callback function.

.. c:type:: qdb_const_iterator_t

    A structure that represents a const iterator.

.. c:type:: qdb_remote_node_t

    A structure that represents a remote node with an associated error status updated by the last API call, unless the structure is passed as constant.

.. c:type:: qdb_entry_type_t

    A structure that represents a type of entry, such as a Blob, Queue, HashSet, or Integer.

.. c:type:: qdb_operation_type_t

    A structure that represents a type of operation, such as a put, get, or update.

.. c:type:: qdb_operation_t

    A structure that represents an operation request with an associated error status updated by the last API call.

.. c:type:: qdb_option_t

    An enum representing the available options.

.. c:function:: const char * qdb_error(qdb_error_t error)

    Translate an error into a meaningful message. If the content does not fit into the buffer, the content is truncated. A null terminator is always appended, except if the buffer is empty. The function never fails and returns the passed pointer for convenience.

    :param error: An error code 
    :type error: qdb_error_t
    :returns: The pointer to the buffer that received the translated error message.

.. c:function:: const char * qdb_version(void)

    Returns a null terminated string describing the API version. The buffer is API managed and should not be freed or written to by the caller.

    :returns: A pointer to a null terminated string describing the API version.

.. c:function:: const char * qdb_build(void)

    Returns a null terminated string with a build number and date. The buffer is API managed and should be be freed or written to by the caller.

    :returns: A pointer to a null terminated string describing the build number and date.

.. c:function:: qdb_error_t qdb_open(qdb_handle_t * handle, qdb_protocol_t proto)

    Creates a client instance. To avoid resource and memory leaks, the :c:func:`qdb_close` must be used on the initialized handle when it is no longer needed.

    :param handle: A pointer to a :c:type:`qdb_handle_t` that will be initialized to represent a new client instance.
    :type handle: qdb_handle_t *
    :param proto: The protocol to use of type :c:type:`qdb_protocol_t`
    :type proto: :c:type:`qdb_protocol_t`
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_handle_t qdb_open_tcp(void)

    Creates a client instance for the TCP network protocol. This is a convenience function.

    :returns: A valid handle when successful, 0 in case of failure. The handle must be closed with :c:func:`qdb_close`.

.. c:function:: qdb_error_t qdb_option_set_timeout(qdb_handle_t handle, int timeout_ms)
    
    Sets the timeout for all client calls in milliseconds.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param timeout_ms: A number of milliseconds after which a client call will time out.
    :type timeout_ms: :c:type:`int`
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_option_add_log_callback(qdb_log_callback cb)
    
    Registers a callback function for logging.
    
    :param cb: The callback function used for logging.
    :type cb: :c:type:`qdb_log_callback`
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_option_set_compression(qdb_handle_t handle, qdb_compression_t comp_level)
    
    Sets the compression level for all network calls.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param comp_level: The compression level the client should use for network calls.
    :type comp_level: :c:type:`qdb_compression_t`
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_connect(qdb_handle_t handle, const char * uri)

    Bind the client instance to a quasardb cluster and connect to one node within.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param uri: A pointer to a null terminated string in the format "qdb://host:port[,host:port]".
    :type uri: const char *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_close(qdb_handle_t handle)

    Terminates all connections and releases all client-side allocated resources.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_noalloc(qdb_handle_t handle, const char * alias, char * content, size_t * content_length)

    Retrieves an entry's content from the quasardb server. The caller is responsible for allocating and freeing the provided buffer.

    If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

    If the buffer is not large enough to hold the data, the function will fail and return ``qdb_e_buffer_too_small``. content_length will nevertheless be updated with entry size so that the caller may resize its buffer and try again.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
    :type alias: const char *
    :param content: A pointer to an user allocated buffer that will receive the entry's content.
    :type content: char *
    :param content_length: A pointer to a size_t initialized with the length of the destination buffer, in bytes. It will be updated with the length of the retrieved content, even if the buffer is not large enough to hold all the data.
    :type content_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get(qdb_handle_t handle, const char * alias, char ** content, size_t * content_length)

    Retrieves an entry's content from the quasardb server.

    If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

    The function will allocate a buffer large enough to hold the entry's content. This buffer must be released by the caller with a call to :c:func:`qdb_free_buffer`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
    :type alias: const char *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content.
    :type content: char **
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type content_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_copy_alloc_buffer(qdb_handle_t handle, const char * source_buffer, size_t source_buffer_size, const char ** dest_buffer)

    Copies a source buffer to a destination buffer, automatically allocating memory for the destination buffer. The caller is responsible for freeing the destination buffer.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle
    :type handle: qdb_handle_t
    :param source_buffer: A pointer to an user allocated buffer that will provide the content.
    :type alias: const char *
    :param source_buffer_size: A size_t representing the size of the source buffer.
    :type source_buffer_size: size_t
    :param dest_buffer: A pointer to a pointer that will be set to a function-allocated buffer holding the copied content.
    :type content: char **
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_and_remove(qdb_handle_t handle, const char * alias, const char ** content, size_t * content_length)

    Atomically gets an entry from the quasardb server and removes it. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

    The function will allocate a buffer large enough to hold the entry's content. This buffer must be released by the caller with a call to :c:func:`qdb_free_buffer`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias to delete.
    :type alias: const char *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content.
    :type content: char **
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type content_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: void qdb_free_buffer(qdb_handle_t handle, char * buffer)

    Frees a buffer allocated by :c:func:`qdb_get`.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param buffer: A pointer to a buffer to release allocated by :c:func:`qdb_get`.
    :type buffer: char *

    :returns: This function does not return a value.

.. c:function:: qdb_error_t qdb_put(qdb_handle_t handle, const char * alias, const char * content, size_t content_length, qdb_time_t expiry_time, qdb_time_t expiry_time)

    Adds an entry to the quasardb server. If the entry already exists the function will fail and will return ``qdb_e_alias_already_exists``. Keys beginning with the string "qdb" are reserved and cannot be added to the cluster.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias to create.
    :type alias: const char *
    :param content: A pointer to a buffer that represents the entry's content to be added to the server.
    :type content: const char *
    :param content_length: The length of the entry's content, in bytes.
    :type content_length: size_t
    :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
    :type expiry_time: qdb_time_t

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_update(qdb_handle_t handle, const char * alias, const char * content, size_t content_length, qdb_time_t expiry_time)

    Updates an entry on the quasardb server. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias to update.
    :type alias: const char *
    :param content: A pointer to a buffer that represents the entry's content to be updated to the server.
    :type content: const char *
    :param content_length: The length of the entry's content, in bytes.
    :type content_length: size_t
    :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
    :type expiry_time: qdb_time_t

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_and_update(qdb_handle_t handle, const char * alias, const char * update_content, size_t update_content_length, qdb_time_t expiry_time, char ** get_content, size_t * get_content_length)

    Atomically gets and updates (in this order) the entry on the quasardb server. The entry must already exist.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias to update.
    :type alias: const char *
    :param update_content: A pointer to a buffer that represents the entry's content to be updated to the server.
    :type update_content: const char *
    :param update_content_length: The length of the buffer, in bytes.
    :type udpate_content_length: const char *
    :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
    :type expiry_time: qdb_time_t
    :param get_content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content, before the update.
    :type get_content: char **
    :param get_content_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type get_content_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_compare_and_swap(qdb_handle_t handle, const char * alias, const char * new_value, size_t new_value_length, const char * comparand, qdb_time_t expiry_time, size_t comparand_length, char ** original_value, size_t * original_value_length)

    Atomically compares the entry with comparand and updates it to new_value if, and only if, they match. Always returns the original value of the entry.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias to compare to.
    :type alias: const char *
    :param new_value: A pointer to a buffer that represents the entry's content to be updated to the server in case of match.
    :type new_value: const char *
    :param new_value_length: The length of the buffer, in bytes.
    :type new_value_length: size_t
    :param comparand: A pointer to a buffer that represents the entry's content to be compared to.
    :type comparand: const char *
    :param comparand_length: The length of the buffer, in bytes.
    :type comparand_length: size_t
    :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
    :type expiry_time: qdb_time_t
    :param original_value: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's original content, before the update, if any.
    :type original_value: char **
    :param original_value_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type original_value_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_remove(qdb_handle_t handle, const char * alias)

    Removes an entry from the quasardb server. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias to delete.
    :type alias: const char *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_remove_if(qdb_handle_t handle, const char * alias, const char * comparand, size_t comparand_length)

    Removes an entry from the quasardb server if it matches comparand. The operation is atomic. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias to delete.
    :type alias: const char *
    :param comparand: A pointer to a buffer that represents the entry's content to be compared to.
    :type comparand: const char *
    :param comparand_length: The length of the buffer, in bytes.
    :type comparand_length: size_t

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_init_operations(qdb_operations_t * operations, size_t operations_count)

    Initializes an array of operations to the default value, making its later usage safe.

    :param operations: Pointer to an array of qdb_operations_t
    :type operations: qdb_operations_t *
    :param operations_count: Size of the array, in entry count
    :type operations_count: size_t

    :returns: An error code of type :c:type:`qdb_error_t` 

.. c:function:: qdb_error_t qdb_run_batch(qdb_handle_t handle, qdb_operations_t * operations, size_t operations_count)

    Runs the provided operations in batch on the cluster. The operations are run in arbitrary order. 

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param operations: Pointer to an array of qdb_operations_t
    :type operations: qdb_operations_t *
    :param operations_count: Size of the array, in entry count
    :type operations_count: size_t

    :returns: The number of successful operations

.. c:function:: qdb_error_t qdb_run_transaction(qdb_handle_t handle, qdb_operations_t * operations, size_t operations_count, size_t * failed_index)

    Runs the provided operations as a transaction on the cluster. The operations are run in the provided order. If any operation fails, all previously run operations are rolled back.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param operations: Pointer to an array of qdb_operations_t
    :type operations: qdb_operations_t *
    :param operations_count: Size of the array, in entry count
    :type operations_count: size_t
    :param failed_index: The index in the operations array for the operation that failed.
    :type failed_index: size_t

    :returns: The number of successful operations

.. c:function:: qdb_error_t qdb_free_operations(qdb_handle_t handle, qdb_operations_t * operations, size_t operations_count)

    Releases all API-allocated memory by a :c:func:`qdb_run_batch` or :c:func:`qdb_run_transaction` call. This function is safe to call even if :c:func:`qdb_run_batch` or :c:func:`qdb_run_transaction` didn't allocate any memory.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param operations: Pointer to an array of qdb_operations_t
    :type operations: qdb_operations_t *
    :param operations_count: Size of the array, in entry count
    :type operations_count: size_t

    :returns: An error code of type :c:type:`qdb_error_t` 


.. c:function:: qdb_error_t qdb_expires_at(qdb_handle_t handle, const char * alias, qdb_time_t expiry_time)

    Sets the expiry time of an existing entry from the quasardb cluster. A value of zero means the entry never expires.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be set.
    :type alias: const char *
    :param expiry_time: Absolute time after which the entry expires, in seconds, relative to epoch
    :type expiry_time: :c:type:`qdb_time_t`

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_expires_from_now(qdb_handle_t handle, const char * alias, qdb_time_t expiry_delta)

    Sets the expiry time of an existing entry from the quasardb cluster. A value of zero means the entry expires as soon as possible.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be set.
    :type alias: const char *
    :param expiry_time: Time in seconds, relative to the call time, after which the entry expires
    :type expiry_time: :c:type:`qdb_time_t`

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_expiry_time(qdb_handle_t handle, const char * alias, qdb_time_t * expiry_time)

    Retrieves the expiry time of an existing entry. A value of zero means the entry never expires.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param expiry_time: A pointer to a qdb_time_t that will receive the absolute expiry time.
    :type expiry_time: :c:type:`qdb_time_t` *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_location(qdb_handle_t handle, const char * alias, qdb_remote_node_t * location)

    Retrieves an array of locations where the entry is stored in the cluster.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param location: A pointer to a qdb_remote_node_t that will receive the entry locations.
    :type location: :c:type:`qdb_remote_node_t` *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_type(qdb_handle_t handle, const char * alias, qdb_entry_type_t * entry_type)

    Retrieves the type of the entry.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param location: A pointer to a qdb_entry_type_t that will receive the entry locations.
    :type location: :c:type:`qdb_entry_type_t` *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_purge_all(qdb_handle_t handle)

    Removes all the entries on all the nodes of the quasardb cluster. The function returns when the command has been dispatched and executed on the whole cluster or an error occurred.

    This call is **not** atomic: if the command cannot be dispatched on the whole cluster, it will be dispatched on as many nodes as possible and the function will return with a qdb_e_ok code. 

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t

    :returns: An error code of type :c:type:`qdb_error_t`

    .. caution:: This function is meant for very specific use cases and its usage is discouraged.

.. c:function:: qdb_error_t qdb_trim_all(qdb_handle_t handle)

    Manually runs the garbage collector, removing stale versions of entries from the cluster. This may free a small portion of disk space or memory.

    This call is **not** atomic: if the command cannot be dispatched on the whole cluster, it will be dispatched on as many nodes as possible and the function will return with a qdb_e_ok code. 

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_node_status(qdb_handle_t handle, const char * uri, const char ** content, size_t * content_length)

    Obtains a node status as a JSON string. 

    The function will allocate a buffer large enough to hold the status string and a terminating zero. This buffer must be released by the caller with a call to :c:func:`qdb_free_buffer`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param uri: A pointer to a null terminated string in the format "qdb://host:port".
    :type uri: const char *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the status string.
    :type content: const char **
    :param content_length: A pointer to a size_t that will be set to the status string length, in bytes.
    :type content_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_node_config(qdb_handle_t handle, const char * uri, const char ** content, size_t * content_length)

    Obtains a node configuration as a JSON string. 

    The function will allocate a buffer large enough to hold the configuration string and a terminating zero. This buffer must be released by the caller with a call to :c:func:`qdb_free_buffer`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param uri: A pointer to a null terminated string in the format "qdb://host:port".
    :type uri: const char *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the configuration string.
    :type content: const char **
    :param content_length: A pointer to a size_t that will be set to the configuration string length, in bytes.
    :type content_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_node_topology(qdb_handle_t handle, const char * uri, const char ** content, size_t * content_length)

    Obtains a node topology as a JSON string. 

    The function will allocate a buffer large enough to hold the topology string and a terminating zero. This buffer must be released by the caller with a call to :c:func:`qdb_free_buffer`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param uri: A pointer to a null terminated string in the format "qdb://host:port".
    :type uri: const char *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the topology string.
    :type content: const char **
    :param content_length: A pointer to a size_t that will be set to the topology string length, in bytes.
    :type content_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_stop_node(qdb_handle_t handle, const char * uri, const char * reason)

    Stops the node designated by its host and port number. This stop is generally effective a couple of seconds after it has been issued, enabling inflight calls to complete successfully.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param uri: A pointer to a null terminated string in the format "qdb://host:port".
    :type uri: const char *
    :param reason: A pointer to a null terminated string detailing the reason for the stop that will appear in the remote node's log.
    :type reason: const char *
    :returns: An error code of type :c:type:`qdb_error_t`

    .. caution:: This function is meant for very specific use cases and its usage is discouraged.

.. c:function:: qdb_error_t qdb_iterator_begin(qdb_handle_t handle, qdb_const_iterator * iterator)

    Initializes an iterator and make it point to the first entry in the cluster. Iteration is unordered. If no entry is found, the function will return qdb_e_alias_not_found.

    The iterator must be released with a call to :c:func:`qdb_iterator_close`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`). 

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param iterator: A pointer to qdb_const_iterator structure that will be initialized.
    :type iterator: qdb_const_iterator *
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_iterator_rbegin(qdb_handle_t handle, qdb_const_iterator * iterator)

    Initializes an iterator and make it point to the last entry in the cluster. Iteration is unordered. If no entry is found, the function will return qdb_e_alias_not_found.

    The iterator must be released with a call to :c:func:`qdb_iterator_close`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`). 

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param iterator: A pointer to qdb_const_iterator structure that will be initialized.
    :type iterator: qdb_const_iterator *
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_iterator_next(qdb_const_iterator_t * iterator)

    Updates the iterator to point to the next available entry in the cluster. Although each entry is returned only once, the order in which entries are returned is undefined. If there is no following entry or it is otherwise unavailable, the function will return qdb_e_alias_not_found.

    The iterator must be initialized (see :c:func:`qdb_iterator_begin` and :c:func:`qdb_iterator_rbegin`). 

    :param iterator: A pointer to a qdb_const_iterator structure that has been previously been initialized.
    :type iterator: qdb_const_iterator *
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_iterator_previous(qdb_const_iterator_t * iterator)

    Updates the iterator to point to the previous available entry in the cluster. Although each entry is returned only once, the order in which entries are returned is undefined. If there is no previous entry or it is otherwise unavailable, the function will return qdb_e_alias_not_found.

    The iterator must be initialized (see :c:func:`qdb_iterator_begin` and :c:func:`qdb_iterator_rbegin`).
    
    :param iterator: A pointer to a qdb_const_iterator structure that has been previously been initialized.
    :type iterator: qdb_const_iterator *
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_iterator_close(qdb_const_iterator_t * iterator)

    Releases all resources associated with the iterator.

    The iterator must be initialized (see :c:func:`qdb_iterator_begin` and :c:func:`qdb_iterator_rbegin`). 

    :param iterator: A pointer to a qdb_const_iterator structure that has been previously been initialized.
    :type iterator: qdb_const_iterator *
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_iterator_copy(const qdb_const_iterator_t * original,  qdb_const_iterator_t * copy)

    Copies the state of the original iterator to a new iterator. Both iterators can afterward be independently operated.

    The iterator copy must be released with a call to :c:func:`qdb_iterator_close`.

    The original iterator must be initialized (see :c:func:`qdb_iterator_begin` and :c:func:`qdb_iterator_rbegin`). 

    :param original: A pointer to a qdb_const_iterator structure that has been previously been initialized.
    :type original: qdb_const_iterator *
    :param copy: A pointer to a qdb_const_iterator structure to which the iterator should be copied.
    :type copy: qdb_const_iterator *
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_hset_insert(qdb_handle_t handle, const char * alias, const char * content, size_t content_length)
    
    Inserts a value into a hset. Creates the hset if it does not already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param content: A pointer to an user allocated buffer with the entry's content.
    :type content: char *
    :param content_length: The length of the target buffer, in bytes.
    :type content_length: size_t *
    :returns: An error code of type :c:type:`qdb_error_t`
    
.. c:function:: qdb_error_t qdb_hset_erase(qdb_handle_t handle, const char * alias, const char * content, size_t content_length)
    
    Removes a value from a hset. The hset must already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param content: A pointer to a buffer to search for and remove.
    :type content: char *
    :param content_length: A pointer to a size_t initialized with the length of the destination buffer, in bytes. It will be updated with the length of the retrieved content, even if the buffer is not large enough to hold all the data.
    :type content_length: size_t *
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_hset_contains (qdb_handle_t handle, const char * alias, const char * content, size_t content_length)
    
    Determines if a hset has a given value. The hset must already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param content: A pointer to a buffer to search for and compare against.
    :type content: char *
    :param content_length: A pointer to a size_t initialized with the length of the destination buffer, in bytes. It will be updated with the length of the retrieved content, even if the buffer is not large enough to hold all the data.
    :type content_length: size_t *    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_int_put(qdb_handle_t handle, const char * alias, qdb_int integer, qdb_time_t expiry_time)
    
    Creates a new integer. Errors if the integer already exists.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param integer: The value of the new qdb_int.
    :type integer: A :c:type:`qdb_int`.
    :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
    :type expiry_time: qdb_time_t
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_int_update(qdb_handle_t handle, const char * alias, qdb_int integer, qdb_time_t expiry_time)
    
    Updates an existing integer or creates one if it does not exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param integer: The value of the new qdb_int.
    :type integer: A :c:type:`qdb_int`.
    :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
    :type expiry_time: qdb_time_t
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_int_get(qdb_handle_t handle, const char * alias, qdb_int * integer)
    
    Retrieves the value of an integer. The integer must already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param integer: The value of the retrieved qdb_int.
    :type integer: A pointer to a :c:type:`qdb_int`.
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_int_add(qdb_handle_t handle, const char * alias, qdb_int addend, qdb_int * result)
    
    Atomically addes the value to the integer. The integer must already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param addend: The value that will be added to the existing qdb_int.
    :type addend: A :c:type:`qdb_int`.
    :param result: A pointer that will be updated to point to the new qdb_int.
    :type result: A pointer to a :c:type:`qdb_int`.
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_queue_size(qdb_handle_t handle, const char * alias, size_t * size)
    
    Retrieves the size of the queue. The queue must already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param size: A pointer that will be updated with the size of the queue.
    :type size: A pointer to a :c:type:`size_t`.
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_queue_at(qdb_handle_t handle, const char * alias, size_t index, const char ** content, size_t * content_length)
    
    Retrieves the value of the queue at the specified index. The queue must already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param index: The index you wish to retrieve.
    :type index: :c:type:`size_t`
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content.
    :type content: char **
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type content_length: size_t *
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_queue_push_front(qdb_handle_t handle, const char * alias, const char * content, size_t content_length)
    
    Inserts the content at the front of the queue. Creates the queue if it does not exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param content: A pointer to the content that will be added to the queue.
    :type content: const char *
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type content_length: size_t *
    
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_queue_push_back(qdb_handle_t handle, const char * alias, const char * content, size_t content_length)
    
    Inserts the content at the back of the queue. Creates the queue if it does not exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param content: A pointer to the content that will be added to the queue.
    :type content: const char *
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type content_length: size_t *
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_queue_pop_front(qdb_handle_t handle, const char * alias, const char ** content, size_t content_length)
    
    Removes and retrieves the item at the front of the queue. The queue must already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content.
    :type content: char **
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type content_length: size_t *
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_queue_pop_back(qdb_handle_t handle, const char * alias, const char ** content, size_t content_length)
    
    Removes and retrieves the item at the back of the queue. The queue must already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content.
    :type content: char **
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type content_length: size_t *
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_queue_front(qdb_handle_t handle, const char * alias, const char ** content, size_t content_length)
    
    Retrieves the item at the front of the queue. The queue must already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content.
    :type content: char **
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type content_length: size_t *
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_queue_back(qdb_handle_t handle, const char * alias, const char ** content, size_t content_length)
    
    Retrives the item at the back of the queue. The queue must already exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content.
    :type content: char **
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.
    :type content_length: size_t *
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_add_tag(qdb_handle_t handle, const char * alias, const char * tag)
    
    Assigns a tag to an entry. The tag is created if it does not exist.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param tag: A pointer to a null terminated string representing the tag.
    :type tag: const char *
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_has_tag(qdb_handle_t handle, const char * alias, const char * tag)
    
    Determines if a given tag has been assigned to an entry.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param tag: A pointer to a null terminated string representing the tag.
    :type tag: const char *
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_remove_tag(qdb_handle_t handle, const char * alias, const char * tag)
    
    Removes a tag assignment from an entry.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param tag: A pointer to a null terminated string representing the tag.
    :type tag: const char *
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_tagged(qdb_handle_t handle, const char * tag, const char *** aliases, size_t aliases_count)
    
    Retrieves the aliases that have been tagged with the given tag.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param tag: A pointer to a null terminated string representing the tag.
    :type tag: const char *
    :param aliases: A pointer to a pointer of an array of alias pointers. This will be set to list each alias tagged with the given tag.
    :type aliases: :c:type:`const char ***`
    :param aliases_count: The number of aliases in the array.
    :type aliases_count: size_t
    
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_tags(qdb_handle_t handle, const char * alias, const char *** tags, size_t tags_count)
    
    Retrieves the tags assigned to the given alias.
    
    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias.
    :type alias: const char *
    :param tags: A pointer to a pointer of an array of tag pointers. This will be set to list each tag assigned to the alias.
    :type tags: :c:type:`const char ***`
    :param aliases_count: The number of tags in the array.
    :type aliases_count: size_t
    
    :returns: An error code of type :c:type:`qdb_error_t`


