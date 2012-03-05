C
==

.. highlight:: c

Introduction
--------------

The wrpme C API is the lowest-level API offered but also the fastest and the most powerful.

Installing
--------------

Download the C API from `the wrpme website <http://www.wrpme.com/downloads.html>`_ and unpack the archive.

All needed libraries are included in the package.

Header file
--------------

All functions, typedefs and enums are made available in the ``include/wrpme/client.h`` header file.

Examples
--------------

A couple of examples are available in the ``examples/c`` directory.

Connecting to a cluster
--------------------------

The first thing to do is to initialize a handle.
A handle is an opaque structure that represents a client side instance.
It is initialized by the function :c:func:`wrpme_open`: ::

    wrpme_handle_t handle = 0;
    wrpme_error_t r = wrpme_open(&handle, wrpme_proto_tcp);
    if (r != wrpme_error_ok)
    {
        // error management
    }

We can also use the convenience fonction :c:func:`wrpme_open_tcp`: ::

    wrpme_handle_t handle = wrpme_open_tcp();
    if (!handle)
    {
        // error management
    }

Once the handle is initialized, it can be used to establish a connection. Keep in mind that the API does not actually keep the connection alive all the time. Connections are established and closed as needed. This code will establish a connection to a wrpme server listening on the localhost with the :c:func:`wrpme_connect` function: ::

    r = wrpme_connect(handle, "localhost", 5909);
    if (r != wrpme_error_ok)
    {
        // error management
    }

Note that we could have used the IP address instead: ::

    r = wrpme_connect(handle, "127.0.0.1", 5909);
    if (r != wrpme_error_ok)
    {
        // error management
    }

`IPv6 <http://en.wikipedia.org/wiki/IPv6>`_ is also supported: ::

    r = wrpme_connect(handle, "::1", 5909);
    if (r != wrpme_error_ok)
    {
        // error management
    }

Of course for the above to work the server needs to listen on an IPv6 address.

.. note::
    When you call :c:func:`wrpme_open` and :c:func:`wrpme_connect` a lot of initialization and systems calls are made. It is therefore advised to reduce the calls to these function to the strict minimum, ideally keeping the handle alive for the whole program lifetime.


Adding entries
-----------------

Each entry is identified by an unique :term:`alias`. You pass the alias as a null-terminated string.
The alias may contain arbitrary characters but it's probably more convenient to use printable characters only.

The :term:`content` is a buffer containing arbitrary data. You need to specify the size of the content buffer. There is no  built-in limit on the content's size, you just need to ensure you have enough free memory to allocate it at least once on the client side and on the server side.

There are two ways to add entries into the repository. You can use :c:func:`wrpme_put`: ::

    char content[100];

    // ...

    r = wrpme_put(handle, "myalias", content, sizeof(content));
    if (r != wrpme_error_ok)
    {
        // error management
    }

or you can use :c:func:`wrpme_update`: ::

    char content[100];

    // ...

    r = wrpme_update(handle, "myalias", content, sizeof(content));
    if (r != wrpme_error_ok)
    {
        // error management
    }

The difference is that :c:func:`wrpme_put` fails when the entry already exists. :c:func:`wrpme_update` will create the entry if it does not, or update its content if it does.

Getting entries
--------------------

The most convenient way to fetch an entry is :c:func:`wrpme_get_buffer`::

    char * allocated_content = 0;
    size_t allocated_content_length = 0;
    r = wrpme_get_buffer(handle, "myalias", &allocated_content, &allocated_content_length);
    if (r != wrpme_error_ok)
    {
        // error management
    }

The function will allocate the buffer and update the length. You will need to release the memory later with :c:func:`wrpme_free_buffer`::

    wrpme_free_buffer(allocated_content);

However, for maximum performance you might want to manage allocation yourself and reuse buffers (for example). In which case you will prefer to use :c:func:`wrpme_get`::

    char buffer[1024];

    size content_length = sizeof(buffer);

    // ...

    // content_length must be initialized with the buffer's size
    // and will be update with the retrieved content's size
    r = wrpme_get(handle, "myalias", buffer, &content_length);
    if (r != wrpme_error_ok)
    {
        // error management
    }

The function will update content_length even if the buffer isn't large enough, giving you a chance to increase the buffer's size and try again.


Removing entries
---------------------

Removing is done with the function :c:func:`wrpme_delete`::

    r = wrpme_delete(handle, "myalias");
    if (r != wrpme_error_ok)
    {
        // error management
    }

The function fails if the entry does not exist.

Cleaning up
--------------------

When you are done working with a wrpme repository, call :c:func:`wrpme_close`::

    wrpme_close(handle);

:c:func:`wrpme_close` **does not** release memory allocated by :c:func:`wrpme_get_buffer`. You will need to make appropriate calls to :c:func:`wrpme_free_buffer` for each call to :c:func:`wrpme_get_buffer`.

.. note ::

    Avoid opening and closing connections needlessly. A handle consumes very little memory and resources. It is safe to keep it open for the whole duration of
    your program.

Reference
----------------

.. c:type:: wrpme_handle_t

    An opaque handle that represents a wrpme client instance.

.. c:type:: wrpme_error_t

    An enum representing possible error codes returned by the API functions. "No error" evaluates to 0.

.. c:type:: wrpme_protocol_t

    An enum representing available network protocols.

.. c:function:: const char * wrpme_error(wrpme_error_t error, char * message, size_t message_length)

    Translates an error into a meaningful message.

    :param error: An error code of type :c:type:`wrpme_handle_t`
    :param message: A pointer to a buffer that will received the translated error message.
    :param message_length: The length of the buffer that will received the translated error message, in bytes.
    :return: A pointer to the buffer that received the translated error message.

.. c:function:: const char * wrpme_version(void)

    Returns a null terminated string describing the API version. The buffer is API managed and should not be freed or written to by the caller.

    :return: A pointer to a null terminated string describing the API version.

.. c:function:: const char * wrpme_build(void)

    Returns a null terminated string with a build number and date. The buffer is API managed and should be be freed or written to by the caller.

    :return: A pointer to a null terminated string describing the build number and date.

.. c:function:: wrpme_error_t wrpme_open(wrpme_handle_t * handle, wrpme_protocol_t proto)

    Creates a client instance. To avoir resource and memory leaks, the :c:func:`wrpme_close` must be used on the initialized handle when it is no longer needed.

    :param handle: A pointer to a :c:type:`wrpme_handle_t` that will be initialized to represent a new client instance.
    :param proto: The protocol to use of type :c:type:`wrpme_protocol_t`
    :return: An error code of type :c:type:`wrpme_error_t`

.. c:function:: wrpme_handle_t wrpme_open_tcp(void)

    Creates a client instance for the TCP network protocol. This is a convenience function.

    :return: A valid handle when successful, 0 in case of failure. The handle must be closed with :c:func:`wrpme_close`.

.. c:function:: wrpme_error_t wrpme_set_option(wrpme_handle_t handle, wrpme_option_t option, ...)

    Sets an option for the given wrpme handle.

    :param handle: An initialized handle (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`)
    :param option: The option to set.

    :return: An error code of type :c:type:`wrpme_error_t`

.. c:function:: wrpme_error_t wrpme_connect(wrpme_handle_t handle, const char * host, unsigned short port)

    Binds the client instance to a wrpme :term:`server` and connects to it.

    :param handle: An initialized handle (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`)
    :param host: A pointer to a null terminated string representing the IP address or the name of the server to which to connect
    :param port: The port number used by the server. The default wrpme port is 5909.

    :return: An error code of type :c:type:`wrpme_error_t`

.. c:function:: wrpme_error_t wrpme_close(wrpme_handle_t handle)

    Terminates all connections and releases all client-side allocated resources.

    :param handle: An initialized handle (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`)

    :return: An error code of type :c:type:`wrpme_error_t`

.. c:function:: wrpme_error_t wrpme_get(wrpme_handle_t handle, const char * alias, char * content, size_t * content_length)

    Retrieves an :term:`entry`'s content from the wrpme server. The caller is responsible for allocating and freeing the provided buffer.

    If the entry does not exist, the function will fail and return ``wrpme_e_alias_not_found``.

    If the buffer is not large enough to hold the data, the function will fail and return ``wrpme_e_buffer_too_small``. The content length will nevertheless be updated so that the caller may resize its buffer and try again.

    The handle must be initialized (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`) and the connection established (see :c:func:`wrpme_connect`).

    :param handle: An initialized handle
    :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
    :param content: A pointer to an user allocated buffer that will receive the entry's content.
    :param content_length: A pointer to a size_t initialized with the length of the destination buffer, in bytes. It will be updated with the length of the retrieved content, even if the buffer is not large enough to hold all the data.

    :return: An error code of type :c:type:`wrpme_error_t`

.. c:function::  wrpme_error_t wrpme_get_buffer(wrpme_handle_t handle, const char * alias, char ** content, size_t * content_length)

    Retrieves an :term:`entry`'s content from the wrpme server.

    If the entry does not exist, the function will fail and return ``wrpme_e_alias_not_found``.

    The function will allocate a buffer large enough to hold the entry's content. This buffer must be released by the caller with a call to :c:func:`wrpme_close`.

    The handle must be initialized (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`) and the connection established (see :c:func:`wrpme_connect`).

    :param handle: An initialized handle (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
    :param content: A pointer to a pointer that will be set to a function-allocated buffer holding the entry's content.
    :param content_length: A pointer to a size_t that will be set to the content's size, in bytes.

    :return: An error code of type :c:type:`wrpme_error_t`

.. c:function:: void wrpme_free_buffer(char * buffer)

    Frees a buffer allocated by :c:func:`wrpme_get_buffer`.

    :param buffer: A pointer to a buffer to release allocated by :c:func:`wrpme_get_buffer`.

    :return: This function does not return a value.

.. c:function:: wrpme_error_t wrpme_put(wrpme_handle_t handle, const char * alias, const char * content, size_t content_length)

    Adds an :term:`entry` to the wrpme server. If the entry already exists the function will fail and will return ``wrpme_e_alias_already_exists``.

    The handle must be initialized (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`) and the connection established (see :c:func:`wrpme_connect`).

    :param handle: An initialized handle (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias to create.
    :param content: A pointer to a buffer that represents the entry's content to be added to the server.
    :param content_length: The length of the entry's content, in bytes.

    :return: An error code of type :c:type:`wrpme_error_t`

.. c:function:: wrpme_error_t wrpme_update(wrpme_handle_t handle, const char * alias, const char * content, size_t content_length)

    Updates an :term:`entry` of the wrpme server. If the entry already exists, the content will be update. If the entry does not exist, it will be created.

    The handle must be initialized (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`) and the connection established (see :c:func:`wrpme_connect`).

    :param handle: An initialized handle (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias to update.
    :param content: A pointer to a buffer that represents the entry's content to be updated to the server.
    :param content_length: The length of the entry's content, in bytes.

    :return: An error code of type :c:type:`wrpme_error_t`


.. c:function:: wrpme_error_t wrpme_delete(wrpme_handle_t handle, const char * alias)

    Removes an :term:`entry` from the wrpme server. If the entry does not exist, the function will fail and return ``wrpme_e_alias_not_found``.

    The handle must be initialized (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`) and the connection established (see :c:func:`wrpme_connect`).

    :param handle: An initialized handle (see :c:func:`wrpme_open` and :c:func:`wrpme_open_tcp`)
    :param alias: A pointer to a null terminated string representing the entry's alias to delete.

    :return: An error code of type :c:type:`wrpme_error_t`

