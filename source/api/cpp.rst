C++
====

.. cpp:namespace:: qdb
.. highlight:: cpp

Introduction
--------------

The quasardb C++ API is a wrapper around the C API that brings convenience and flexibility without sacrificing performance. Behaviour is similar to that of the C API (see :doc:`c`).

Installing
--------------

The C++ API package consists of one header and is included with the C API (see :doc:`c`). It is required to link with the C API to use the C++ API.

Header file
--------------

All functions, typedefs and enums are made available in the ``include/qdb/client.hpp`` header file. All classes and methods reside in the ``qdb`` namespace.

Exceptions
------------

The quasardb C++ API does not throw any exception on its behalf.

The handle object
-------------------

The :cpp:class:`handle` object is non-copiable. Move semantics are supported through rvalue references. Rvalue references support is activated in setting the macro QDBAPI_RVALUE_SUPPORT to 1. For example::

    #define QDBAPI_RVALUE_SUPPORT 1
    #include <qdb/client.hpp>

Handle objects can be used directly with the C API thanks to the overload of the cast operator. They will evaluate to false when not initialized::

    qdb::handle h;
    // some code...
    if (!h) // true if h isn't initialized
    {
        // ...
    }

Handle objects can also be encapsulated in smart pointers. A definition as :cpp:type:`handle_ptr` is available. This requires a compiler with std::shared_ptr support.

Connecting to a cluster
--------------------------

The connection requires a :cpp:class:`handle` object and is done with the :cpp:func:`handle::connect` method::

    qdb::handle h;
    qdb_error_t r = h.connect("127.0.0.1", 2836);

Connect will both initialize the handle and connect to the cluster. If the connection failed, the handle will be reset.  Note that when the handle object goes out of scope, the connection will be terminated and the handle will be released.

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

There is however one strong difference as the C call :c:func:`qdb_get_buffer`, which allocates a buffer of the needed size, is replaced with a more convenient method that uses smart pointers to manage allocation. 

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

The :cpp:class:`api_buffer` object is designed to be used via a smart pointer, whose definition is provided, and is returned by methods from the handle object. It is not designed to be used directly.

Closing a connection
-----------------------

A connection can be explicitely closed and the handle released with the :cpp:func:`handle::close` method::

    h.close();

Note that when the :cpp:class:`handle` object is destroyed, :cpp:func:`handle::close` is automatically closed.

Reference
----------------

.. cpp:class:: handle

    .. cpp:function:: void close(void)

        Close the handle and releases all associated resources.

    .. cpp:function:: bool connected(void) const

        :return: true if the handle is connected, false otherwise

    .. cpp:function:: void set_timeout(int timeout)

        Sets the timeout, in milliseconds, for all operations.

        :param timeout: The timeout, in milliseconds.

    .. cpp:function:: qdb_error_t connect(const char * host, unsigned short port)

        Initialize all required resources and connect to a remote host.

        :param host: A null terminated string designating the host to connect to.
        :param port: An unsigned integer designating the port to connect to.

        :return: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: size_t multi_connect(const char ** hosts, const unsigned short * ports, qdb_error_t * errors, size_t count)

        Initialize all required resources and connect to multiple remote hosts.

        :param hosts: An array of null terminated strings designating the hosts to connect to.
        :param ports: An array of unsigned integers designating the corresponding ports for each host to connect to.
        :param errors: An array of error codes that will receive the result for each connection.
        :param count: The size of the input arrays. All arrays must have identical sizes.

        :return: The number of successful connections.

    .. cpp:function:: qdb_error_t put(const char * alias, const char * content, size_t content_length)



        :return: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t update(const char * alias, const char * content, size_t content_length)

        :return: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t get(const char * alias, char * content, size_t * content_length)

        Retrieves an :term:`entry`'s content from the quasardb server. The caller is responsible for allocating and freeing the provided buffer.

        If the entry does not exist, the method will fail and return ``qdb_e_alias_not_found``.

        If the buffer is not large enough to hold the data, the method will fail and return ``qdb_e_buffer_too_small``. The content length will nevertheless be updated so that the caller may resize its buffer and try again.

        The handle must be initialized and connected (see :cpp:func:`connect` and :cpp:func:`multi_connect`).

        :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
        :param content: A pointer to an user allocated buffer that will receive the entry's content.
        :param content_length: A pointer to a size_t initialized with the length of the destination buffer, in bytes. It will be updated with the length of the retrieved content, even if the buffer is not large enough to hold all the data.

        :return: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: api_buffer_ptr get(const char * alias, qdb_error_t & error)

    .. cpp:function:: api_buffer_ptr get_update(const char * alias, const char * update_content, size_t update_content_length, qdb_error_t & error)

    .. cpp:function:: api_buffer_ptr compare_and_swap(const char * alias, const char * new_value, size_t new_value_length, const char * comparand,    size_t comparand_length, qdb_error_t & error)

    .. cpp:function:: qdb_error_t remove(const char * alias)

        :return: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t remove_all(void)

        :return: An error code of type :c:type:`qdb_error_t`

.. cpp:type:: handle_ptr

    A smart pointer to a handle object.

.. cpp:class:: api_buffer

    An API allocated buffer returned by a method from the handle object. Do not use directly.

.. cpp:type:: api_buffer_ptr

    A smart pointer definition used by the handle object.