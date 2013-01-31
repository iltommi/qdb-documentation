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
    When you call :c:func:`qdb_open` and :c:func:`qdb_connect` a lot of initialization and systems calls are made. It is therefore advised to reduce the calls to these functions to the strict minimum, ideally keeping the handle alive for the whole program lifetime.

Connecting to multiple nodes within the same cluster
------------------------------------------------------

Although quasardb is fault tolerant, if the client tries to connect to the cluster through a node that is unavailable, the connection will fail. To prevent that it is advised to use :c:func:`qdb_multi_connect` which takes a list of hosts and ports as input parameters. The call will succeed as long as one connection within the list was successful::

    const char addresses[3] = { "192.168.1.1", "192.168.1.2", "192.168.1.3" };
    const unsigned short ports[3] = { 2836, 2836, 2836 };
    qdb_error_t errors[3];

    // will connect to 192.168.1.1:2836, 192.168.1.2:2836 and 192.168.1.3:2836
    // errors will be updated with the error status for each connection and the
    // function will return the number of successful connections
    size_t connections = qdb_multi_connect(handle, addresses, ports, errors, 3);
    if (!connections)
    {
        // error management...
    }

The list of addresses/ports must be unique, that is, providing the same address/port combination more than one time is an error and will make the call fail.

Adding entries
-----------------

Each entry is identified by an unique :term:`alias`. You pass the alias as a null-terminated string.
The alias may contain arbitrary characters but it's probably more convenient to use printable characters only.

The :term:`content` is a buffer containing arbitrary data. You need to specify the size of the content buffer. There is no built-in limit on the content's size; you just need to ensure you have enough free memory to allocate it at least once on the client side and on the server side.

There are two ways to add entries into the repository. You can use :c:func:`qdb_put`: ::

    char content[100];

    // ...

    r = qdb_put(handle, "myalias", content, sizeof(content));
    if (r != qdb_error_ok)
    {
        // error management
    }

or you can use :c:func:`qdb_update`: ::

    char content[100];

    // ...

    r = qdb_update(handle, "myalias", content, sizeof(content));
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


Streaming entries
--------------------

It is often impractical to download very large entries at once. For these cases, a streaming API is available. For more information, see :doc:`../concepts/streaming`.

Initializing streaming
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

One first start by creating a streaming handle from an existing quasardb handle::

    qdb_stream_tracker_t trk;
    qdb_error_t e = qdb_open_stream(h, alias_name, &trk);

.. note::
    The connection to the remote server must be done before initializing the streaming handle as the API will request information from the remote server.

The stream tracker holds the streaming buffer and maintains information to properly stream data from the server::

    typedef struct
    {
        qdb_handle_t handle;      /* [in] */
        const void * token;         /* [in] */

        const void * buffer;        /* [out] */
        size_t buffer_size;         /* [out] */

        size_t current_offset;      /* [out] */
        size_t last_read_size;      /* [out] */

        size_t entry_size;          /* [out] */
    } qdb_stream_tracker_t;

.. warning::
    The streaming buffer is read only. Freeing or writing to the streaming buffer results in undefined behaviour.

The buffer size can be adjusted with :c:func:`qdb_set_option` and the qdb_o_stream_buffer_size option. It accepts an integer representing the number of bytes the streaming buffer should have. The default size is 1 MiB. The buffer cannot be smaller than 1024 bytes or greater than 10 MiB. The buffer size must be adjusted **prior** to calling :c:func:`qdb_open_stream`.

All streaming handles have a dedicated streaming buffer, it is therefore safe to stream from different handles at the same time. However, having many streaming handles open at the same time may result in an important memory usage.

Streaming data from the server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Once the streaming context is properly initialized, one may start streaming with :c:func:`qdb_get_stream`::

    while(trk.current_offset < trk.entry_size)
    {
        e = qdb_get_stream(&trk);
        if (e != qdb_e_ok)
        {
            // handle error
            break;
        }

        // process content in trk.buffer
        // the size of the data available in the buffer is last_read_size
    }

If the content you are streaming is being modified by another user, :c:func:`qdb_get_stream` will return qdb_e_conflict. If you attempt to stream beyond the end, the function will return qdb_e_out_of_bounds.

After each call, the values in the streaming context are updated. 

Seeking the stream
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It might be desirable to go directly to a specific point in the stream. The user cannot update directly the qdb_stream_tracker_t structure as the values in the structure are ignored by the API (they are *write only* from the point of view of the API). To update the offset, one uses the :c:func:`qdb_set_stream_offset`::

    // go directly to the 1024th byte in the stream
    qdb_set_stream_offset(&trk, 1024);

The offset must be within bounds. The user may refer to the entry_size member field of the qdb_stream_tracker_t to check that it is within bounds. 

Closing the stream
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Once the last byte of the stream has been read, the user may:

    * Rewind with :c:func:`qdb_set_stream_offset` or
    * Close the stream

Calling qdb_get_stream once the end of the stream has been reached will result in a qdb_e_out_of_bounds error.

The stream is closed with :c:func:`qdb_close_stream`::

    qdb_close_stream(&trk);

Closing the stream will free the streaming buffer and release all resources needed to manage the stream. Not closing the stream will result in memory and resources leaks.

.. warning::
    Calling :c:func:`qdb_close` **does not** close all open streams. 

Cleaning up
--------------------

When you are done working with a quasardb repository, call :c:func:`qdb_close`::

    qdb_close(handle);

:c:func:`qdb_close` **does not** release memory allocated by :c:func:`qdb_get_buffer`. You will need to make appropriate calls to :c:func:`qdb_free_buffer` for each call to :c:func:`qdb_get_buffer`.

.. note ::

    Avoid opening and closing connections needlessly. A handle consumes very little memory and resources. It is safe to keep it open for the whole duration of
    your program.

Reference
----------------

.. c:type:: qdb_handle_t

    An opaque handle that represents a quasardb client instance.

.. c:type:: qdb_stream_tracker_t

    A structure used to track a stream state. 

.. c:type:: qdb_error_t

    An enum representing possible error codes returned by the API functions. "No error" evaluates to 0.

.. c:type:: qdb_protocol_t

    An enum representing available network protocols.

.. c:function:: const char * qdb_error(qdb_error_t error, char * message, size_t message_length)

    Translate an error into a meaningful message. If the content does not fit into the buffer, the content is truncated. A null terminator is always appended, except if the buffer is empty. The function never fails and returns a pointer to the translated message for convenience.

    :param error: An error code of type :c:type:`qdb_handle_t`
    :param message: A pointer to a buffer that will received the translated error message.
    :param message_length: The length of the buffer that will received the translated error message, in bytes.
    :return: A pointer to the buffer that received the translated error message.

.. c:function:: const char * qdb_version(void)

    Returns a null terminated string describing the API version. The buffer is API managed and should not be freed or written to by the caller.

    :return: A pointer to a null terminated string describing the API version.

.. c:function:: const char * qdb_build(void)

    Returns a null terminated string with a build number and date. The buffer is API managed and should be be freed or written to by the caller.

    :return: A pointer to a null terminated string describing the build number and date.

.. c:function:: qdb_error_t qdb_open(qdb_handle_t * handle, qdb_protocol_t proto)

    Creates a client instance. To avoid resource and memory leaks, the :c:func:`qdb_close` must be used on the initialized handle when it is no longer needed.

    :param handle: A pointer to a :c:type:`qdb_handle_t` that will be initialized to represent a new client instance.
    :param proto: The protocol to use of type :c:type:`qdb_protocol_t`
    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_handle_t qdb_open_tcp(void)

    Creates a client instance for the TCP network protocol. This is a convenience function.

    :return: A valid handle when successful, 0 in case of failure. The handle must be closed with :c:func:`qdb_close`.

.. c:function:: qdb_error_t qdb_set_option(qdb_handle_t handle, qdb_option_t option, ...)

    Sets an option for the given quasardb handle.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :param option: The option to set.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_connect(qdb_handle_t handle, const char * host, unsigned short port)

    Bind the client instance to a quasardb :term:`cluster` and connect to one node within.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :param host: A pointer to a null terminated string representing the IP address or the name of the server to which to connect
    :param port: The port number used by the server. The default quasardb port is 2836.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: size_t qdb_multi_connect(qdb_handle_t handle, qdb_remote_node_t * servers, size_t count)

    Bind the client instance to a quasardb :term:`cluster` and connect to multiple nodes within. The function returns the number of successful
    unique connections. If the same node (address and port) is present several times in the input array, it will count as only one successful 
    connection.

    The user supplies an array of qdb_remote_node_t and the function updates the error member of each entry according to the result of the operation.

    Only one connection to a listed node has to succeed for the connection to the cluster to be successful.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :param servers: An array of qdb_remote_node_t designating the nodes to connect to. The error member will be updated depending on the result of the operation.
    :param count: The size of the input array.

    :return: The number of unique successful connections.

.. c:function:: qdb_error_t qdb_close(qdb_handle_t handle)

    Terminates all connections and releases all client-side allocated resources.

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get(qdb_handle_t handle, const char * alias, char * content, size_t * content_length)

    Retrieves an :term:`entry`'s content from the quasardb server. The caller is responsible for allocating and freeing the provided buffer.

    If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

    If the buffer is not large enough to hold the data, the function will fail and return ``qdb_e_buffer_too_small``. content_length will nevertheless be updated with entry size so that the caller may resize its buffer and try again.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle
    :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
    :param content: A pointer to an user allocated buffer that will receive the entry's content.
    :param content_length: A pointer to a size_t initialized with the length of the destination buffer, in bytes. It will be updated with the length of the retrieved content, even if the buffer is not large enough to hold all the data.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function::  qdb_error_t qdb_get_buffer(qdb_handle_t handle, const char * alias, char ** content, size_t * content_length)

    Retrieves an :term:`entry`'s content from the quasardb server.

    If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

    The function will allocate a buffer large enough to hold the entry's content. This buffer must be released by the caller with a call to :c:func:`qdb_close`.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content.
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: void qdb_free_buffer(char * buffer)

    Frees a buffer allocated by :c:func:`qdb_get_buffer`.

    :param buffer: A pointer to a buffer to release allocated by :c:func:`qdb_get_buffer`.

    :return: This function does not return a value.

.. c:function:: qdb_error_t qdb_put(qdb_handle_t handle, const char * alias, const char * content, size_t content_length)

    Adds an :term:`entry` to the quasardb server. If the entry already exists the function will fail and will return ``qdb_e_alias_already_exists``.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias to create.
    :param content: A pointer to a buffer that represents the entry's content to be added to the server.
    :param content_length: The length of the entry's content, in bytes.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_update(qdb_handle_t handle, const char * alias, const char * content, size_t content_length)

    Updates an :term:`entry` on the quasardb server. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias to update.
    :param content: A pointer to a buffer that represents the entry's content to be updated to the server.
    :param content_length: The length of the entry's content, in bytes.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_buffer_update(qdb_handle_t handle, const char * alias, const char * update_content, size_t update_content_length, char ** get_content, size_t * get_content_length)

    Atomically gets and updates (in this order) the :term:`entry` on the quasardb server. The entry must already exists.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias to update.
    :param update_content: A pointer to a buffer that represents the entry's content to be updated to the server.
    :param update_content_length: The length of the buffer, in bytes.
    :param get_content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content, before the update.
    :param get_content_length: A pointer to a size_t that will be set to the content's size, in bytes.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_compare_and_swap(qdb_handle_t handle, const char * alias, const char * new_value, size_t new_value_length, const char * comparand, size_t comparand_length, char ** original_value, size_t * original_value_length)

    Atomically compares the :term:`entry` with comparand and updates it to new_value if, and only if, they match. Always return the original value of the entry.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias to compare to.
    :param new_value: A pointer to a buffer that represents the entry's content to be updated to the server in case of match.
    :param new_value: The length of the buffer, in bytes.
    :param comparand: A pointer to a buffer that represents the entry's content to be compared to.
    :param comparand_length: The length of the buffer, in bytes.
    :param original_value: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's original content, before the update, if any.
    :param original_value_length: A pointer to a size_t that will be set to the content's size, in bytes.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_open_stream(qdb_handle_t handle, const char * alias, qdb_stream_tracker_t * stream_tracker)

    Opens, allocates and initializes all resources necessary to stream the :term:`entry` from the server. The size of the streaming buffer is specified by the qdb_o_stream_buffer_size option (see :c:func:`qdb_set_option`).

    The entry_size field of the stream_tracker structure will be updated to the total size, in bytes, of the entry on the remote server. The offset is initially set to 0.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias to stream.
    :param stream_tracker: A pointer to a caller allocated structure that will receive the stream tracker handle and information.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_get_stream(qdb_stream_tracker_t * stream_tracker)

    Streams bytes from the buffer into the stream buffer. It will get at most as many bytes as the stream buffer may old, or the remainder if it cannot fill the stream buffer. 

    It will stream at current_offset as informed in the stream_tracker structure. Note that, however, the api will ignore changes made by the user to this value and update it to the correct value when it returns from the call.

    Once the end of the buffer has been reached, it must be either closed or rewound.

    The stream_tracker structure must have been initialized by :c:func:`qdb_open_stream`.

    :param stream_tracker: An initialized stream handle (see :c:func:`qdb_open_stream`).

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_set_stream_offset(qdb_stream_tracker_t * stream_tracker, size_t new_offset)

    Sets the streaming offset to the value specified by new_offset, in bytes. The offset may not point at or beyond the end of the :term:`entry`.

    :param stream_tracker: An initialized stream handle (see :c:func:`qdb_open_stream`).
    :param new_offset: The offset to stream from, in bytes.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_close_stream(qdb_stream_tracker_t * stream_tracker)

    Closes the stream and frees all allocated resources. 

    :param stream_tracker: An initialized stream handle (see :c:func:`qdb_open_stream`).

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_remove(qdb_handle_t handle, const char * alias)

    Removes an :term:`entry` from the quasardb server. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias to delete.

    :return: An error code of type :c:type:`qdb_error_t`

.. c:function:: qdb_error_t qdb_remove_all(qdb_handle_t handle)

    Removes all the entries on all the nodes of the quasardb cluster. The function returns when the command has been dispatched and executed on the whole cluster or an error occurred.

    This call is *not* atomic: if the command cannot be dispatched on the whole cluster, it will be dispatched on as many nodes as possible and the function will return with a qdb_e_ok code. 

    The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

    :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)

    :return: An error code of type :c:type:`qdb_error_t`

    .. caution:: This function is meant for very specific use cases and its usage is discouraged.
