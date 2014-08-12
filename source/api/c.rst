C
==

.. highlight:: c

Introduction
--------------

The quasardb C API is the lowest-level API offered but also the fastest and the most powerful.

Installing
--------------

The C API package is downloadable from the Bureau 14 download site. All information regarding the Bureau 14 download site are in your welcome e-mail.

All needed libraries are included in the package.

Header file
--------------

All functions, typedefs and enums are made available in the ``include/qdb/client.h`` header file.

Examples
--------------

A couple of examples are available in the ``examples/c`` directory.

Connecting to a cluster
--------------------------

The first thing to do is to initialize a handle.
A handle is an opaque structure that represents a client side instance.
It is initialized by the function :c:func:`qdb_open`: ::

    qdb_handle_t handle = 0;
    qdb_error_t r = qdb_open(&handle, qdb_proto_tcp);
    if (r != qdb_error_ok)
    {
        // error management
    }

We can also use the convenience fonction :c:func:`qdb_open_tcp`: ::

    qdb_handle_t handle = qdb_open_tcp();
    if (!handle)
    {
        // error management
    }

Once the handle is initialized, it can be used to establish a connection. Keep in mind that the API does not actually keep the connection alive all the time. Connections are established and closed as needed. This code will establish a connection to a quasardb server listening on the localhost with the :c:func:`qdb_connect` function: ::

    r = qdb_connect(handle, "localhost", 2836);
    if (r != qdb_error_ok)
    {
        // error management
    }

Note that we could have used the IP address instead: ::

    r = qdb_connect(handle, "127.0.0.1", 2836);
    if (r != qdb_error_ok)
    {
        // error management
    }

.. caution::
    Concurrent calls to :c:func:`qdb_connect` to the same handle results in undefined behaviour.

`IPv6 <http://en.wikipedia.org/wiki/IPv6>`_ is also supported: ::

    r = qdb_connect(handle, "::1", 2836);
    if (r != qdb_error_ok)
    {
        // error management
    }

Of course for the above to work the server needs to listen on an IPv6 address.

.. note::
    When you call :c:func:`qdb_open` and :c:func:`qdb_connect` a lot of initialization and system calls are made. It is therefore advised to reduce the calls to these functions to the strict minimum, ideally keeping the same handle alive for the lifetime of the program.

Connecting to multiple nodes within the same cluster
------------------------------------------------------

Although quasardb is fault tolerant, if the client tries to connect to the cluster through a node that is unavailable, the connection will fail. To prevent that, it is advised to use :c:func:`qdb_multi_connect` which takes an array of qdb_remote_node_t as input and output. Each entry of the array with be updated with an error status reflecting the success or failure of the operation for this specific entry. The call, as a whole, will succeed as long as one connection within the list was successful established::

    qdb_remote_node_t remote_nodes[3];

    // there is no need to update the error member as it will be ignored by the function
    remote_nodes[0].address = "192.168.1.1";
    remote_nodes[0].port = 2836;
    remote_nodes[1].address = "192.168.1.2";
    remote_nodes[1].port = 2836;
    remote_nodes[2].address = "192.168.1.3";
    remote_nodes[2].port = 2836;

    // will connect to 192.168.1.1:2836, 192.168.1.2:2836 and 192.168.1.3:2836
    // the error member of each entry will be updated accordingly to the success
    // of each operation
    // the function will return the number of successful connections
    size_t connections = qdb_multi_connect(handle, remote_nodes, 3);
    if (!connections)
    {
        // error management...
    }

If the same address/port pair is present multiple times within the array, only the first occurrence can be successful.

Adding entries
-----------------

Each entry is identified by an unique :term:`alias`. You pass the alias as a null-terminated string.
The alias may contain arbitrary characters but it's probably more convenient to use printable characters only.

The :term:`content` is a buffer containing arbitrary data. You need to specify the size of the content buffer. There is no built-in limit on the content's size; you just need to ensure you have enough free memory to allocate it at least once on the client side and on the server side.

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

The most convenient way to fetch an entry is :c:func:`qdb_get_buffer`::

    char * allocated_content = 0;
    size_t allocated_content_length = 0;
    r = qdb_get_buffer(handle, "myalias", &allocated_content, &allocated_content_length);
    if (r != qdb_error_ok)
    {
        // error management
    }

The function will allocate the buffer and update the length. You will need to release the memory later with :c:func:`qdb_free_buffer`::

    qdb_free_buffer(allocated_content);

However, for maximum performance you might want to manage allocation yourself and reuse buffers (for example). In which case you will prefer to use :c:func:`qdb_get`::

    char buffer[1024];

    size content_length = sizeof(buffer);

    // ...

    // content_length must be initialized with the buffer's size
    // and will be update with the retrieved content's size
    r = qdb_get(handle, "myalias", buffer, &content_length);
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

:c:func:`qdb_close` **does not** release memory allocated by :c:func:`qdb_get_buffer`. You will need to make appropriate calls to :c:func:`qdb_free_buffer` for each call to :c:func:`qdb_get_buffer`.

.. note ::

    Avoid opening and closing connections needlessly. A handle consumes very little memory and resources. It is safe to keep it open for the duration of your program.

Timeout
-------

It is possible to configure the client-side timeout with the :c:func:`qdb_set_option`::

    // sets the timeout to 5000 ms
    qdb_set_option(h, qdb_o_operation_timeout, 5000);

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

Prefix based search
--------------------

Prefix based search is a powerful tool that helps you lookup entries efficiently. 

For example, if you want to find all entries whose aliases start with "record"::

    const char ** results = 0;
    size_t results_count = 0;

    r = qdb_prefix_get(handle, "record", &results, &results_count);
    if (r != qdb_error_ok)
    {
        // error management
    }

    // results now contains an array of null terminated strings
    // representing the matching entries

The qdb_prefix_get function automatically allocates all required memory. This memory must be released by the caller at a later time::

    qdb_free_results(handle, &results, &results_count);

Batch operations
-----------------

Batch operations can greatly increase performance when it is necessary to run many small operations. Using properly the batch operations requires initializing, running and freeing and array of operations.

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

Let's imagine in our case we have an error, here is a possible error lookup code::

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

    const char * entry1_content = op[0].result;
    size_t entry1_size = op[0].result_size;

    const char * entry2_content = op[1].result;
    size_t entry2_size = op[1].result_size;

The memory is API allocated and the caller must release it with a call to :c:func:`qdb_free_operations`. The call releases all buffers at once::

    r = qdb_free_operations(ops, 3);
    if (r != qdb_error_ok)
    {
        // error management
    }

Iteration
-----------

Iteration on the cluster's entries can be done forward and backward. One initializes the iterator with :c:func:`qdb_iterator_begin` or :c:func:`qdb_iterator_rbegin` depending on whether one would want to start from the first entry or the last entry.

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

It can be useful, for debugging and information purposes, to obtain all logs. The C API provides access to the internal log system through a callback which is called each time the API has to log something.

.. warning::
    Improper usage of the logging API can seriously affect the performance and the reliability of the quasardb API. Make sure your logging callback is as simple as possible.

The thread and context in which the callback is called is undefined and the developer should not assume anything about the memory layout. However, calls to the callback are not concurrent: the user only has to take care of thread safety in the context of its application. In other words, **calls are serialized**.

Logging is asynchronous, however buffers are flushed when :c:func:`qdb_close` is successfully called.

The callback profile is the following::

     void qdb_log_callback(const char * log_level,
                           const unsigned long * date,  // [years, months, day, hours, minute, seconds] (valid only in the context of the callback)
                           unsigned long pid,           // process id
                           unsigned long tid,           // thread id
                           const char * message_buffer,  // message buffer (valid only in the context of the callback)
                           size_t message_size);        // message buffer size


The parameters passed to the callback are:

    * *log_level:* a null-terminated string describing the log level for the message. The possible log levels are: detailed, debug, info, warning, error and panic. The string is static and valid as long as the dynamic library remains loaded in memory.
    * *date:* an array of six unsigned longs describing the timestamp of the log message. They are ordered as such: year, month, day, hours, minutes, seconds. The time is in 24h format.
    * *pid:* the process id of the log message.
    * *tid:* the thread id of the log message.
    * *message_buffer:* a null-terminated buffer that is valid only in the context of the callback. 
    * *message_size:* the size of the buffer, in bytes.

Here is a callback example::

     void my_log_callback(const char * log_level,
                          const unsigned long * date,  // [years, months, day, hours, minute, seconds] (valid only in the context of the callback)
                          unsigned long pid,           // process id
                          unsigned long tid,           // thread id
                          const char * message_buffer,  // message buffer (valid only in the context of the callback)
                          size_t message_size)
    {
        // will print to the console the log message, e.g.
        // 12/31/2013-23:12:01 debug: here is the message
        // note that you don't have to use all provided information, only use what you need!
        printf("%02d/%02d/%04d-%02d:%02d:%02d %s: %s", date[1], date[2], date[0], date[3], date[4], date[5], log_level, message_buffer);
    }

Setting the callback is done with :c:func:`qdb_set_option`::

    qdb_set_option(handle, qdb_o_log_callback, my_log_callback);

.. warning::
    It is not possible to unregister a log callback. Multiple calls to :c:func:`qdb_set_option` will result in several callbacks being registered. Registering the same callback multiple times results in undefined behaviour. 


Reference
----------------

.. c:type:: qdb_handle_t

    An opaque handle that represents a quasardb client instance.

.. c:type:: qdb_remote_node_t

    A structure to represent a remote node with an associated error status updated by the last API call, unless the structure is passed as constant.

.. c:type:: qdb_operation_t

    A structure to represent an operation request with an associated error status updated by the last API call.

.. c:type:: qdb_error_t

    An enum representing possible error codes returned by the API functions. "No error" evaluates to 0. When the error is qdb_e_system, either errno or GetLastError (depending on the platform) will be updated with the corresponding system error.

.. c:type:: qdb_option_t

    An enum representing the available options.

.. c:type:: qdb_protocol_t

    An enum representing available network protocols.

.. c:function:: const char * qdb_error(qdb_error_t error, char * message, size_t message_length)

    Translate an error into a meaningful message. If the content does not fit into the buffer, the content is truncated. A null terminator is always appended, except if the buffer is empty. The function never fails and returns the passed pointer for convenience.

    :param error: An error code 
    :type error: qdb_error_t
    :param message: A pointer to a buffer that will receive the translated error message.
    :type message: char *
    :param message_length: The length of the buffer that will receive the translated error message, in bytes.
    :type message_length: size_t
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
    :type proto: qdb_protocol_t
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_handle_t qdb_open_tcp(void)

    Creates a client instance for the TCP network protocol. This is a convenience function.

    :returns: A valid handle when successful, 0 in case of failure. The handle must be closed with :c:func:`qdb_close`.

.. c:function:: qdb_error_t qdb_set_option(qdb_handle_t handle, qdb_option_t option, ...)

    Sets an option for the given quasardb handle.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param option: The option to set.
    :type option: qdb_option_t

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_connect(qdb_handle_t handle, const char * host, unsigned short port)

    Bind the client instance to a quasardb :term:`cluster` and connect to one node within.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param host: A pointer to a null terminated string representing the IP address or the name of the server to which to connect
    :type host: const char *
    :param port: The port number used by the server. The default quasardb port is 2836.
    :type port: unsigned short

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: size_t qdb_multi_connect(qdb_handle_t handle, qdb_remote_node_t * servers, size_t count)

    Bind the client instance to a quasardb :term:`cluster` and connect to multiple nodes within the cluster. The function returns the number of successful
    unique connections. If the same node (address and port) is present several times in the input array, it will count as only one successful 
    connection.

    The user supplies an array of qdb_remote_node_t and the function updates the error member of each entry according to the result of the operation.

    Only one connection to a listed node has to succeed for the connection to the cluster to be successful.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param servers: An array of qdb_remote_node_t designating the nodes to connect to. The error member will be updated depending on the result of the operation.
    :type servers: qdb_remote_node_t *
    :param count: The size of the input array.
    :type count: size_t

    :returns: The number of unique successful connections.

.. c:function:: qdb_error_t qdb_close(qdb_handle_t handle)

    Terminates all connections and releases all client-side allocated resources.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_prefix_get(qdb_handle_t handle, const char * prefix, const char *** results, size_t * results_count)

    Search the cluster for entries with the provided prefix. The function will return the list of matching aliases, but not the associated content.

    The returned results must be freed with :c:func:`qdb_free_results`

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the prefix to use for the search
    :type alias: const char ``*``
    :param results: A pointer to a const char ** that will receive an API allocated array of NULL terminated strings representing the list of matching aliases
    :type results: const char ``*````*````*``
    :param results_count: A pointer to a size_t that will receive the number of results
    :type  results_count: size_t ``*``

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get(qdb_handle_t handle, const char * alias, char * content, size_t * content_length)

    Retrieves an :term:`entry`'s content from the quasardb server. The caller is responsible for allocating and freeing the provided buffer.

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

.. c:function::  qdb_error_t qdb_get_buffer(qdb_handle_t handle, const char * alias, char ** content, size_t * content_length)

    Retrieves an :term:`entry`'s content from the quasardb server.

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

.. c:function:: qdb_error_t qdb_get_remove(qdb_handle_t handle, const char * alias, const char ** content, size_t * content_length)

    Atomically gets an :term:`entry` from the quasardb server and removes it. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

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

    Frees a buffer allocated by :c:func:`qdb_get_buffer`.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param buffer: A pointer to a buffer to release allocated by :c:func:`qdb_get_buffer`.
    :type buffer: char *

    :returns: This function does not return a value.

.. c:function:: void qdb_free_results(qdb_handle_t handle, const char ** results, size_t results_count)

    Frees a buffer allocated by :c:func:`qdb_prefix_get`.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param results: A pointer to a buffer to release allocated by :c:func:`qdb_prefix_get`
    :type results: const char **
    :param results_count: The number of entries in results
    :type results_count: size_t

.. c:function:: qdb_error_t qdb_prefix_get(qdb_handle_t handle, const char * prefix, const char *** results, size_t * results_count)

    Searches the cluster for all entries whose aliases start with "prefix". The function will allocate an array of strings containing the aliases of matching entries. This array must be freed later with :c:func:`qdb_free_results`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param prefix: A pointer to a null terminated string representing the search prefix
    :type prefix: const char *
    :param results: A pointer to an array of results to be freed with :c:func:`qdb_free_results`
    :type results: const char **
    :param results_count: A pointer to a size_t that will receive the number of results
    :type results_count: size_t *

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

.. c:function:: qdb_error_t qdb_free_operations(qdb_handle_t handle, qdb_operations_t * operations, size_t operations_count)

    Releases all API-allocated memory by a :c:func:`qdb_run_batch` call. This function is safe to call even if :c:func:`qdb_run_batch` didn't allocate any memory.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param operations: Pointer to an array of qdb_operations_t
    :type operations: qdb_operations_t *
    :param operations_count: Size of the array, in entry count
    :type operations_count: size_t

    :returns: An error code of type :c:type:`qdb_error_t` 

.. c:function:: qdb_error_t qdb_put(qdb_handle_t handle, const char * alias, const char * content, size_t content_length, qdb_time_t expiry_time, qdb_time_t expiry_time)

    Adds an :term:`entry` to the quasardb server. If the entry already exists the function will fail and will return ``qdb_e_alias_already_exists``. Keys beginning with the string "qdb" are reserved and cannot be added to the cluster.

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

    Updates an :term:`entry` on the quasardb server. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.

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

.. c:function:: qdb_error_t qdb_get_buffer_update(qdb_handle_t handle, const char * alias, const char * update_content, size_t update_content_length, qdb_time_t expiry_time, char ** get_content, size_t * get_content_length)

    Atomically gets and updates (in this order) the :term:`entry` on the quasardb server. The entry must already exist.

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

    Atomically compares the :term:`entry` with comparand and updates it to new_value if, and only if, they match. Always returns the original value of the entry.

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

    Removes an :term:`entry` from the quasardb server. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias to delete.
    :type alias: const char *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_remove_if(qdb_handle_t handle, const char * alias, const char * comparand, size_t comparand_length)

    Removes an :term:`entry` from the quasardb server if it matches comparand. The operation is atomic. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

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

.. c:function:: qdb_error_t qdb_expires_at(qdb_handle_t handle, const char * alias, qdb_time_t expiry_time)

    Sets the expiry time of an existing :term:`entry` from the quasardb cluster. A value of zero means the entry never expires.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be set.
    :type alias: const char *
    :param expiry_time: Absolute time after which the entry expires, in seconds, relative to epoch
    :type expiry_time: :c:type:`qdb_time_t`

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_expires_from_now(qdb_handle_t handle, const char * alias, qdb_time_t expiry_delta)

    Sets the expiry time of an existing :term:`entry` from the quasardb cluster. A value of zero means the entry expires as soon as possible.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be set.
    :type alias: const char *
    :param expiry_time: Time in seconds, relative to the call time, after which the entry expires
    :type expiry_time: :c:type:`qdb_time_t`

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_expiry_time(qdb_handle_t handle, const char * alias, qdb_time_t * expiry_time)

    Retrieves the expiry time of an existing :term:`entry`. A value of zero means the entry never expires.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be get.
    :type alias: const char *
    :param expiry_time: A pointer to a qdb_time_t that will receive the absolute expiry time.
    :type expiry_time: :c:type:`qdb_time_t` *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_remove_all(qdb_handle_t handle)

    Removes all the entries on all the nodes of the quasardb cluster. The function returns when the command has been dispatched and executed on the whole cluster or an error occurred.

    This call is **not** atomic: if the command cannot be dispatched on the whole cluster, it will be dispatched on as many nodes as possible and the function will return with a qdb_e_ok code. 

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t

    :returns: An error code of type :c:type:`qdb_error_t`

    .. caution:: This function is meant for very specific use cases and its usage is discouraged.

.. c:function:: qdb_error_t qdb_node_status(qdb_handle_t handle, const qdb_remote_node_t * node, const char ** content, size_t * content_length)

    Obtains a node status as a JSON string. 

    The function will allocate a buffer large enough to hold the status string and a terminating zero. This buffer must be released by the caller with a call to :c:func:`qdb_free_buffer`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param node: A pointer to a qdb_remote_node_t structure designating the node to get the status from
    :type node: const qdb_remote_node_t *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the status string.
    :type content: const char **
    :param content_length: A pointer to a size_t that will be set to the status string length, in bytes.
    :type content_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_node_config(qdb_handle_t handle, const qdb_remote_node_t * node, const char ** content, size_t * content_length)

    Obtains a node configuration as a JSON string. 

    The function will allocate a buffer large enough to hold the configuration string and a terminating zero. This buffer must be released by the caller with a call to :c:func:`qdb_free_buffer`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param node: A pointer to a qdb_remote_node_t structure designating the node to get the configuration from
    :type node: const qdb_remote_node_t *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the configuration string.
    :type content: const char **
    :param content_length: A pointer to a size_t that will be set to the configuration string length, in bytes.
    :type content_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_node_topology(qdb_handle_t handle, const qdb_remote_node_t * node, const char ** content, size_t * content_length)

    Obtains a node topology as a JSON string. 

    The function will allocate a buffer large enough to hold the topology string and a terminating zero. This buffer must be released by the caller with a call to :c:func:`qdb_free_buffer`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param node: A pointer to a qdb_remote_node_t structure designating the node to get the topology from
    :type node: const qdb_remote_node_t *
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the topology string.
    :type content: const char **
    :param content_length: A pointer to a size_t that will be set to the topology string length, in bytes.
    :type content_length: size_t *

    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_stop_node(qdb_handle_t handle, const qdb_remote_node_t * node, const char * reason)

    Stops the node designated by its host and port number. This stop is generally effective a couple of seconds after it has been issued, enabling inflight calls to complete successfully.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param node: A pointer to a qdb_remote_node_t structure designating the node to stop
    :type node: const qdb_remote_node_t *
    :param reason: A pointer to a null terminated string detailing the reason for the stop that will appear in the remote node's log.
    :type reason: const char *
    :returns: An error code of type :c:type:`qdb_error_t`

    .. caution:: This function is meant for very specific use cases and its usage is discouraged.

.. c:function:: qdb_error_t qdb_iterator_begin(qdb_handle_t handle, qdb_const_iterator *iterator)

    Initializes an iterator and make it point to the first entry in the cluster. Iteration is unordered. If no entry is found, the function will return qdb_e_alias_not_found.

    The iterator must be released with a call to :c:func:`qdb_iterator_close`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`). 

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param iterator: A pointer to qdb_const_iterator structure that will be initialized.
    :type iterator: qdb_const_iterator *
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_iterator_rbegin(qdb_handle_t handle, qdb_const_iterator *iterator)

    Initializes an iterator and make it point to the last entry in the cluster. Iteration is unordered. If no entry is found, the function will return qdb_e_alias_not_found.

    The iterator must be released with a call to :c:func:`qdb_iterator_close`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`). 

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :type handle: qdb_handle_t
    :param iterator: A pointer to qdb_const_iterator structure that will be initialized.
    :type iterator: qdb_const_iterator *
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_iterator_next(qdb_const_iterator_t * iterator)

    Updates the iterator to point to the next available entry in the cluster. Iteration is unordered. If no other entry is available, the function will return qdb_e_alias_not_found.

    The iterator must be initialized (see :c:func:`qdb_iterator_begin` and :c:func:`qdb_iterator_rbegin`). 

    :param iterator: A pointer to a qdb_const_iterator structure that has been previously been initialized.
    :type iterator: qdb_const_iterator *
    :returns: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_iterator_previous(qdb_const_iterator_t * iterator)

    Updates the iterator to point to the previous available entry in the cluster. Iteration is unordered. If no other entry is available, the function will return qdb_e_alias_not_found.

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

.. c:function:: qdb_error_t qdb_iterator_close(qdb_const_iterator_t * iterator)

    Releases all resources associated with the iterator.

    The iterator must be initialized (see :c:func:`qdb_iterator_begin` and :c:func:`qdb_iterator_rbegin`). 

    :param iterator: A pointer to a qdb_const_iterator structure that has been previously been initialized.
    :type iterator: qdb_const_iterator *
    :returns: An error code of type :c:type:`qdb_error_t`