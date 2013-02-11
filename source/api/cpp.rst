C++
====

.. cpp:namespace:: qdb
.. highlight:: cpp

Introduction
--------------

The quasardb C++ API is a wrapper around the C API that brings convenience and flexibility without sacrificing performance. Behaviour is similar to that of the C API (see :doc:`c`).

Installing
--------------

The C++ API package consists of one header and is included in the C API package (see :doc:`c`). It is required to link with the C API to use the C++ header, but no additional linking is required.

Header file
--------------

All functions, typedefs and enums are made available in the ``include/qdb/client.hpp`` header file. All classes and methods reside in the ``qdb`` namespace.

Exceptions
------------

The quasardb C++ API does not throw any exception on its behalf, however situations such as low memory conditions may cause exceptions to be thrown.

The handle object
-------------------

The :cpp:class:`handle` object is non-copiable. Move semantics are supported through rvalue references. Rvalue references support is activated in setting the macro ``QDBAPI_RVALUE_SUPPORT`` to 1. For example::

    #define QDBAPI_RVALUE_SUPPORT 1
    #include <qdb/client.hpp>

Handle objects can be used directly with the C API thanks to the overload of the cast operator. They will evaluate to false when not initialized::

    qdb::handle h;
    // some code...
    if (!h) // true if h isn't initialized
    {
        // ...
    }

    // initialization and connection

    // removes the entry "myalias" if it exists
    qdb_error_t r = qdb_remove(h, "myalias");
    if (r != qdb_e_ok)
    {
        // error management
    }


.. caution::
    Calling :c:func:`qdb_close` on a :cpp:class:`handle` leads to undefined behaviour. Generally speaking it is advised to use the methods provided rather than the C API functions. The cast operator is provided for compatibility only.

Handle objects can also be encapsulated in smart pointers. A definition as :cpp:type:`handle_ptr` is available. This requires a compiler with std::shared_ptr support.

Connecting to a cluster
--------------------------

The connection requires a :cpp:class:`handle` object and is done with the :cpp:func:`handle::connect` method::

    qdb::handle h;
    qdb_error_t r = h.connect("127.0.0.1", 2836);

Connect will both initialize the handle and connect to the cluster. If the connection failed, the handle will be reset.  Note that when the handle object goes out of scope, the connection will be terminated and the handle will be released.

.. caution::
    Concurrent calls to connect on the same handle object leads to undefined behaviour.

Adding and getting data to and from a cluster
---------------------------------------------

Although one may use the handle object with the C API, methods are provided for convenience. The usage is close to the original C API. For example to add and get an entry, the C++ way::

    const char in_data[10];

    qdb_error_t r = h.put("entry", in_data);
    if (r != qdb_e_ok)
    {
        // error management
    }

    // ...

    char out_data[10];
    qdb_error_t = r = h.get("entry", out_data, 10);
    if (r != qdb_e_ok)
    {
        // error management
    }

There is however one strong difference as the C call :c:func:`qdb_get_buffer` - which allocates a buffer of the needed size - is replaced with a more convenient method that uses smart pointers to manage allocations lifetime. 

In C, one would write::

    char * allocated_content = 0;
    size_t allocated_content_length = 0;
    r = qdb_get_buffer(handle, "entry", &allocated_content, &allocated_content_length);
    if (r != qdb_e_ok)
    {
        // error management
    }

    // ...
    // later
    // ...

    qdb_free_buffer(allocated_content);

In C++, one writes::

    qdb_error_t r = qdb_e_ok;
    qdb::api_buffer_ptr allocated_content = h.get("entry", r);
    if (r != qdb_e_ok)
    {
        // error management
    }

    // allocated_content will be released when its usage count reaches zero

The api_buffer object
-----------------------

The :cpp:class:`api_buffer` object is designed to be used via a smart pointer - whose definition is provided - and is returned by methods from the :cpp:class:`handle` object. It is possible to access the managed buffer directly (read-only) and query its size (see :cpp:func:`api_buffer::data` and :cpp:func:`api_buffer::size`).

Closing a connection
-----------------------

A connection can be explicitely closed and the handle released with the :cpp:func:`handle::close` method::

    h.close();

Note that when the :cpp:class:`handle` object is destroyed, :cpp:func:`handle::close` is automatically closed.

.. caution::
    The usage of :c:func:`qdb_close` with :cpp:class:`handle` object results in undefined behaviour.

Reference
----------------

.. cpp:function: std::string make_error_string(qdb_error_t err)

    Translate an error code into a meaningful English message. This function never fails.

    :param err: The error code to translate

    :return: A STL string containing an explicit English sentence describing the error. 

.. cpp:class:: handle

    .. cpp:function:: void close(void)

        Close the handle and release all associated resources.

    .. cpp:function:: bool connected(void) const

        Determine if the handle is connected or not.

        :return: true if the handle is connected, false otherwise

    .. cpp:function:: void set_timeout(int timeout)

        Set the timeout, in milliseconds, for all operations.

        :param timeout: The timeout, in milliseconds.

    .. cpp:function:: qdb_error_t connect(const char * host, unsigned short port)

        Initialize all required resources and connect to a remote host.

        :param host: A null terminated string designating the host to connect to.
        :param port: An unsigned integer designating the port to connect to.

        :return: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: size_t multi_connect(qdb_remote_node_t * servers, size_t count)

        Initialize all required resources, bind the client instance to a quasardb :term:`cluster` and connect to multiple nodes within. The function returns the number of successful connections. If the same node (address and port) is present several times in the input array, it will count as only one successful connection.

        The user supplies an array of qdb_remote_node_t and the function updates the error member of each entry according to the result of the operation.

        Only one connection to a listed node has to succeed for the connection to the cluster to be successful.

        :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
        :param servers: An array of qdb_remote_node_t designating the nodes to connect to. The error member will be updated depending on the result of the operation.
        :param count: The size of the input array.

        :return: The number of successful connections.

    .. cpp:function:: qdb_error_t put(const char * alias, const char * content, size_t content_length)

        Adds an :term:`entry` to the quasardb server. If the entry already exists the method will fail and will return ``qdb_e_alias_already_exists``.

        The handle must be initialized and connected (see :cpp:func:`connect` and :cpp:func:`multi_connect`).

        :param alias: A pointer to a null terminated string representing the entry's alias to create.
        :param content: A pointer to a buffer that represents the entry's content to be added to the server.
        :param content_length: The length of the entry's content, in bytes.

        :return: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t update(const char * alias, const char * content, size_t content_length)

        Updates an :term:`entry` on the quasardb server. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.

        The handle must be initialized and connected (see :cpp:func:`connect` and :cpp:func:`multi_connect`).

        :param handle: An initialized handle (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`)
        :param alias: A pointer to a null terminated string representing the entry's alias to update.
        :param content: A pointer to a buffer that represents the entry's content to be updated to the server.
        :param content_length: The length of the entry's content, in bytes.

        :return: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t get(const char * alias, char * content, size_t * content_length)

        Retrieves an :term:`entry`'s content from the quasardb server. The caller is responsible for allocating and freeing the provided buffer.

        If the entry does not exist, the method will fail and return ``qdb_e_alias_not_found``.

        If the buffer is not large enough to hold the data, the function will fail and return ``qdb_e_buffer_too_small``. content_length will nevertheless be updated with entry size so that the caller may resize its buffer and try again.

        The handle must be initialized and connected (see :cpp:func:`connect` and :cpp:func:`multi_connect`).

        :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
        :param content: A pointer to an user allocated buffer that will receive the entry's content.
        :param content_length: A pointer to a size_t initialized with the length of the destination buffer, in bytes. It will be updated with the length of the retrieved content, even if the buffer is not large enough to hold all the data.

        :return: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: api_buffer_ptr get(const char * alias, qdb_error_t & error)

        Retrieves an :term:`entry`'s content from the quasardb server.

        If the entry does not exist, the function will fail and update error to ``qdb_e_alias_not_found``.

        The function will allocate a buffer large enough to hold the entry's content.

        The handle must be initialized and connected (see :cpp:func:`connect` and :cpp:func:`multi_connect`).

        :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
        :param error: A reference to an error that will receive the result of the operation.

        :return: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.

    .. cpp:function:: api_buffer_ptr get_update(const char * alias, const char * update_content, size_t update_content_length, qdb_error_t & error)

        Atomically gets and updates (in this order) the :term:`entry` on the quasardb server. The entry must already exists.

        The handle must be initialized and connected (see :cpp:func:`connect` and :cpp:func:`multi_connect`).

        :param alias: A pointer to a null terminated string representing the entry's alias to update.
        :param update_content: A pointer to a buffer that represents the entry's content to be updated to the server.
        :param update_content_length: The length of the buffer, in bytes.
        :param error: A reference to an error that will receive the result of the operation.

        :return: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.

    .. cpp:function:: api_buffer_ptr compare_and_swap(const char * alias, const char * new_value, size_t new_value_length, const char * comparand, size_t comparand_length, qdb_error_t & error)

        Atomically compares the :term:`entry` with comparand and updates it to new_value if, and only if, they match. Always return the original value of the entry.

        The handle must be initialized and connected (see :cpp:func:`connect` and :cpp:func:`multi_connect`).

        :param alias: A pointer to a null terminated string representing the entry's alias to compare to.
        :param new_value: A pointer to a buffer that represents the entry's content to be updated to the server in case of match.
        :param new_value: The length of the buffer, in bytes.
        :param comparand: A pointer to a buffer that represents the entry's content to be compared to.
        :param new_value: The length of the buffer, in bytes.
        :param error: A reference to an error that will receive the result of the operation.

        :return: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.

    .. cpp:function:: qdb_error_t remove(const char * alias)

        Removes an :term:`entry` from the quasardb server. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

        The handle must be initialized and connected (see :cpp:func:`connect` and :cpp:func:`multi_connect`).

        :param alias: A pointer to a null terminated string representing the entry's alias to delete.

        :return: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t remove_all(void)

        Removes all the entries on all the nodes of the quasardb cluster. The function returns when the command has been dispatched and executed on the whole cluster or an error occurred.

        This call is *not* atomic: if the command cannot be dispatched on the whole cluster, it will be dispatched on as many nodes as possible and the function will return with a qdb_e_ok code. 

        The handle must be initialized and connected (see :cpp:func:`connect` and :cpp:func:`multi_connect`).

        :return: An error code of type :c:type:`qdb_error_t`

        .. caution:: This function is meant for very specific use cases and its usage is discouraged.

.. cpp:type:: handle_ptr

    A smart pointer to a handle object.

.. cpp:class:: api_buffer

    An API allocated buffer returned by a method from the handle object. This object is meant to be used through the handle methods only.

    .. cpp:function:: const char * data(void) const

        Access the managed buffer, read-only.

        :return: A pointer to the managed buffer.

    .. cpp:function:: size_t size(void) const

        Gives the size of the managed buffer.

        :return: The size of the managed buffer.

.. cpp:type:: api_buffer_ptr

    A smart pointer definition used by the handle object.