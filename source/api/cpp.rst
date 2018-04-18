C++
====

.. default-domain:: cpp
.. cpp:namespace:: qdb
.. highlight:: cpp

.. // Can't pull the same :type: instead of :func: trick like I did in c.rst.
.. // The CPP parser is too smart to be fooled. We'll have to live with the extra ().

Quick Reference
---------------

.. |CONST| replace:: ``const``
..

.. |VOID_ARGS| replace:: ``(``\ :c:type:`void`\ ``);``
..

.. |VOID_ARGS_CONST| replace:: ``(``\ :c:type:`void`\ ``) const;``
..

.. |CHAR_P| replace:: :c:type:`char` ``*``
..

.. |CONST_CHAR_P| replace:: |CONST| :c:type:`char` ``*``
..

.. TODO: batch_request
.. TODO: batch_result
.. TODO: remote_node
..

 ======================================= ================================================== ===================
        Return Type                                  Name                                       Arguments
 ======================================= ================================================== ===================
  ..                                     :class:`api_buffer`\ ``;``                         ..
  :c:type:`bool`                         :func:`api_buffer::operator==`                     ``(const`` :type:`api_buffer` ``& other) const;``
  :c:type:`bool`                         :func:`api_buffer::operator!=`                     ``(const`` :type:`api_buffer` ``& other) const;``
  |CONST_CHAR_P|                         :func:`api_buffer::data`                           |VOID_ARGS_CONST|
  :c:type:`qdb_size_t`                     :func:`api_buffer::size`                           |VOID_ARGS_CONST|
  ..                                     :type:`api_buffer_ptr`\ ``;``                      ..
  ..                                     :class:`const_iterator`\ ``;``                     ..
  :c:type:`bool`                         :func:`const_iterator::operator==`                 ``(const`` :type:`const_iterator` ``& other) const;``
  :c:type:`bool`                         :func:`const_iterator::operator!=`                 ``(const`` :type:`const_iterator` ``& other) const;``
  :c:type:`bool`                         :func:`const_iterator::operator++`                 |VOID_ARGS|
  :c:type:`bool`                         :func:`const_iterator::operator--`                 |VOID_ARGS|
  :c:type:`const value_type &`           :func:`const_iterator::operator*`                  |VOID_ARGS_CONST|
  :c:type:`const value_type *`           :func:`const_iterator::operator->`                 |VOID_ARGS_CONST|
  :c:type:`qdb_error_t`                  :func:`const_iterator::last_error`                 |VOID_ARGS_CONST|
  :c:type:`bool`                         :func:`const_iterator::valid`                      |VOID_ARGS_CONST|
  :c:type:`void`                         :func:`const_iterator::close`                      |VOID_ARGS|
  ..                                     :class:`const_reverse_iterator`\ ``;``             ..
  :c:type:`bool`                         :func:`const_reverse_iterator::operator==`         ``(const`` :type:`const_reverse_iterator` ``& other) const;``
  :c:type:`bool`                         :func:`const_reverse_iterator::operator!=`         ``(const`` :type:`const_reverse_iterator` ``& other) const;``
  :c:type:`bool`                         :func:`const_reverse_iterator::operator++`         |VOID_ARGS|
  :c:type:`bool`                         :func:`const_reverse_iterator::operator--`         |VOID_ARGS|
  :c:type:`const value_type &`           :func:`const_reverse_iterator::operator*`          |VOID_ARGS_CONST|
  :c:type:`const value_type *`           :func:`const_reverse_iterator::operator->`         |VOID_ARGS_CONST|
  :c:type:`qdb_error_t`                  :func:`const_reverse_iterator::last_error`         |VOID_ARGS_CONST|
  :c:type:`bool`                         :func:`const_reverse_iterator::valid`              |VOID_ARGS_CONST|
  :c:type:`void`                         :func:`const_reverse_iterator::close`              |VOID_ARGS|
  ..                                     :class:`handle`\ ``;``                             ..
  :c:type:`qdb_error_t`                  :func:`handle::attach_tag`                         ``(``\ |CONST_CHAR_P| ``alias,`` |CONST_CHAR_P| ``tag);``
  :type:`const_iterator`                 :func:`handle::begin`                              |VOID_ARGS|
  :c:type:`qdb_error_t`                  :func:`handle::blob_put`                           ``(``\ |CONST_CHAR_P| ``alias,`` |CONST_CHAR_P| ``content,`` :c:type:`qdb_size_t` ``content_length,`` :c:type:`qdb_time_t` ``expiry_time);``
  :c:type:`qdb_error_t`                  :func:`handle::blob_update`                        ``(``\ |CONST_CHAR_P| ``alias,`` |CONST_CHAR_P| ``content,`` :c:type:`qdb_size_t` ``content_length,`` :c:type:`qdb_time_t` ``expiry_time);``
  :c:type:`qdb_error_t`                  :func:`handle::blob_get_noalloc`                   ``(``\ |CONST_CHAR_P| ``alias,`` |CHAR_P| ``content,`` :c:type:`qdb_size_t *` ``content_length);``
  :type:`api_buffer_ptr`                 :func:`handle::blob_get`                           ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :type:`api_buffer_ptr`                 :func:`handle::blob_get_and_remove`                ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :type:`api_buffer_ptr`                 :func:`handle::blob_get_and_update`                ``(``\ |CONST_CHAR_P| ``alias,`` |CONST_CHAR_P| ``update_content,`` :c:type:`qdb_size_t` ``update_content_length,`` :c:type:`qdb_time_t` ``expiry_time,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :type:`api_buffer_ptr`                 :func:`handle::blob_compare_and_swap`              ``(``\ |CONST_CHAR_P| ``alias,`` |CONST_CHAR_P| ``new_value,`` :c:type:`qdb_size_t` ``new_value_length,`` |CONST_CHAR_P| ``comparand,`` :c:type:`qdb_size_t` ``comparand_length,`` :c:type:`qdb_time_t` ``expiry_time,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :c:type:`qdb_error_t`                  :func:`handle::blob_remove_if`                     ``(``\ |CONST_CHAR_P| ``alias,`` |CONST_CHAR_P| ``comparand,`` :c:type:`qdb_size_t` ``comparand_length);``
  :c:type:`void`                         :func:`handle::close`                              |VOID_ARGS|
  :c:type:`qdb_error_t`                  :func:`handle::connect`                            ``(``\ |CONST_CHAR_P| ``uri);``
  :c:type:`bool`                         :func:`handle::connected`                          |VOID_ARGS_CONST|
  :type:`api_buffer_ptr`                 :func:`handle::deque_back`                         ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :type:`api_buffer_ptr`                 :func:`handle::deque_front`                        ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :type:`api_buffer_ptr`                 :func:`handle::deque_get_at`                       ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_size_t` ``index,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :type:`api_buffer_ptr`                 :func:`handle::deque_pop_back`                     ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :type:`api_buffer_ptr`                 :func:`handle::deque_pop_front`                    ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :c:type:`qdb_error_t`                  :func:`handle::deque_push_back`                    ``(``\ |CONST_CHAR_P| ``alias,`` |CONST_CHAR_P| ``content,`` :c:type:`qdb_size_t` ``content_length);``
  :c:type:`qdb_error_t`                  :func:`handle::deque_push_front`                   ``(``\ |CONST_CHAR_P| ``alias,`` |CONST_CHAR_P| ``content,`` :c:type:`qdb_size_t` ``content_length);``
  :c:type:`qdb_error_t`                  :func:`handle::deque_set_at`                       ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_size_t` ``index,`` |CONST_CHAR_P| ``content,`` :c:type:`qdb_size_t` ``content_length);``
  :c:type:`qdb_error_t`                  :func:`handle::deque_size`                         ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_size_t *` ``size);``
  :c:type:`qdb_error_t`                  :func:`handle::detach_tag`                         ``(``\ |CONST_CHAR_P| ``alias,`` |CONST_CHAR_P| ``tag);``
  :type:`const_iterator`                 :func:`handle::end`                                |VOID_ARGS|
  :c:type:`qdb_error_t`                  :func:`handle::expires_at`                         ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_time_t` ``expiry_time);``
  :c:type:`qdb_error_t`                  :func:`handle::expires_from_now`                   ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_time_t` ``expiry_delta);``
  :c:type:`qdb_error_t`                  :func:`handle::get_expiry_time`                    ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_time_t` ``&`` ``expiry_time);``
  :c:type:`qdb_error_t`                  :func:`handle::get_location`                       ``(``\ |CONST_CHAR_P| ``alias,`` :type:`remote_node` ``&`` ``location);``
  :type:`std::vector\<std::string>`      :func:`handle::get_tagged`                         ``(``\ |CONST_CHAR_P| ``tag,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :type:`std::vector\<std::string>`      :func:`handle::get_tags`                           ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :c:type:`qdb_error_t`                  :func:`handle::get_type`                           ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_entry_type_t *` ``entry_type);``
  :c:type:`qdb_error_t`                  :func:`handle::int_get`                            ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_int_t *` ``number);``
  :c:type:`qdb_error_t`                  :func:`handle::int_put`                            ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_int_t` ``number,`` :c:type:`qdb_time_t` ``expiry_time);``
  :c:type:`qdb_error_t`                  :func:`handle::int_update`                         ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_int_t` ``number,`` :c:type:`qdb_time_t` ``expiry_time);``
  :c:type:`qdb_error_t`                  :func:`handle::int_add`                            ``(``\ |CONST_CHAR_P| ``alias,`` :c:type:`qdb_int_t` ``addend,`` :c:type:`qdb_int_t *` ``result = NULL);``
  :c:type:`qdb_error_t`                  :func:`handle::has_tag`                            ``(``\ |CONST_CHAR_P| ``alias,`` |CONST_CHAR_P| ``tag);``
  :type:`std::string`                    :func:`handle::node_config`                        ``(``\ |CONST_CHAR_P| ``uri,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :type:`std::string`                    :func:`handle::node_status`                        ``(``\ |CONST_CHAR_P| ``uri,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :type:`std::string`                    :func:`handle::node_topology`                      ``(``\ |CONST_CHAR_P| ``uri,`` :c:type:`qdb_error_t` ``&`` ``error);``
  :c:type:`handle &`                     :func:`handle::operator=`                          ``(``\ :type:`handle` ``&& h);``
  :c:type:`qdb_error_t`                  :func:`handle::purge_all`                          |VOID_ARGS|
  :type:`const_reverse_iterator`         :func:`handle::rbegin`                             |VOID_ARGS|
  :c:type:`qdb_error_t`                  :func:`handle::remove`                             ``(``\ |CONST_CHAR_P| ``alias);``
  :type:`const_reverse_iterator`         :func:`handle::rend`                               |VOID_ARGS|
  :c:type:`qdb_size_t`                   :func:`handle::run_batch`                          ``(``:c:type:`qdb_operation_t *` ``operations,`` :c:type:`qdb_size_t` ``operation_count);``
  :type:`std::vector\<batch_result>`     :func:`handle::run_batch`                          ``(``:c:type:`const std::vector\<batch_request> &` ``requests,`` :c:type:`qdb_size_t` ``&`` ``success_count);``
  :c:type:`qdb_error_t`                  :func:`handle::run_transaction`                    ``(``:c:type:`qdb_operation_t *` ``operations,`` :c:type:`qdb_size_t` ``operation_count,`` :c:type:`qdb_size_t` ``&`` ``fail_index);``
  :c:type:`qdb_error_t`                  :func:`handle::set_compression`                    ``(``\ :c:type:`qdb_compression_t` ``comp_level);``
  :c:type:`qdb_error_t`                  :func:`handle::set_timeout`                        ``(``\ :c:type:`int` ``timeout);``
  :c:type:`qdb_error_t`                  :func:`handle::stop_node`                          ``(``\ |CONST_CHAR_P| ``uri,`` |CONST_CHAR_P| ``reason);``
  :c:type:`qdb_error_t`                  :func:`handle::trim_all`                           |VOID_ARGS|
  ..                                     :type:`handle_ptr`\ ``;``                          ..
  :type:`std::string`                    :func:`make_error_string`                          ``(``:c:type:`qdb_error_t` ``err);``
  :type:`api_buffer_ptr`                 :func:`make_api_buffer_ptr`                        ``(``:c:type:`qdb_handle_t` ``h,`` |CONST_CHAR_P| ``data,`` :c:type:`qdb_size_t` ``length);``

 ======================================= ================================================== ===================



Introduction
--------------

The quasardb C++ API is a wrapper around the C API that brings convenience and flexibility without sacrificing performance. Because the behaviour is similar to the C API, you may wish to familiarize yourself with the C API before working with the C++ API (see :doc:`c`).

Installing
--------------

The C++ API package is qdb-capi-<version>, and can be downloaded from the Bureau 14 download site. All information regarding the Bureau 14 download site is in your welcome e-mail. The contents of the C++ API package are:

.. code-block:: none

    \qdb-capi-<version>
          \doc        // This documentation
          \example    // C and C++ API examples
          \include    // C and C++ header files
          \lib        // QDB API shared libraries

All functions, typedefs and enums are made available in the ``include/qdb/client.hpp`` header file. All classes and methods reside in the ``qdb`` namespace.

Both the C and C++ header files must be linked into the client executable. No other linking is required.

The handle object
-------------------

The :cpp:class:`handle` object is non-copiable. Move semantics are supported through rvalue references but must be enabled by setting the  ``QDBAPI_RVALUE_SUPPORT`` macro to 1. For example::

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
    Calling :c:func:`qdb_close` on a :cpp:class:`handle` leads to undefined behaviour. Generally speaking it is advised to use the handle object's methods rather than the C API functions. The cast operator is provided for compatibility only.

Handle objects can also be encapsulated in smart pointers. A definition as :cpp:type:`handle_ptr` is available. This requires a compiler with std::shared_ptr support.

The api_buffer object
-----------------------

The :cpp:class:`api_buffer` object is designed to be used via a smart pointer - whose definition is provided - and is returned by methods from the :cpp:class:`handle` object. It is possible to access the managed buffer directly (read-only) and query its size (see :cpp:func:`api_buffer::data` and :cpp:func:`api_buffer::size`).

Connecting to a cluster
--------------------------

The connection requires a :cpp:class:`handle` object and is done with the :cpp:func:`handle::connect` method::

    qdb::handle h;
    qdb_error_t r = h.connect("qdb://127.0.0.1:2836");

Handle::connect will both initialize the handle and connect to the cluster. If the connection fails, the handle will be reset.  Note that when the handle object goes out of scope, the connection will be terminated and the handle will be released.

.. caution::
    Concurrent calls to connect on the same handle object leads to undefined behaviour.

Adding and getting data to and from a cluster
---------------------------------------------

Although you may use the handle object with the C API, using the handle object's methods is recommended. For example, to put and get an entry, the C++ way::

    const char in_data[10];

    qdb_error_t r = h.put("entry", in_data, 0);
    if (r != qdb_e_ok)
    {
        // error management
    }

    // ...

    char out_data[10];
    qdb_error_t r = h.get("entry", out_data, 10);
    if (r != qdb_e_ok)
    {
        // error management
    }

The largest difference between the C and C++ get calls are their memory allocation lifetimes. The C call :c:func:`qdb_get` allocates a buffer of the needed size and must be explicitly freed. The C++ handle.get() method uses uses smart pointers to manage allocations lifetime.

In C, you would write::

    char * allocated_content = 0;
    qdb_size_t allocated_content_length = 0;
    r = qdb_get(handle, "entry", &allocated_content, &allocated_content_length);
    if (r != qdb_e_ok)
    {
        // error management
    }

    // ...
    // later
    // ...

    qdb_free_buffer(allocated_content);

In C++, you allocate an api_buffer_ptr and it is released when its reference count reaches zero, like a smart pointer::

    qdb_error_t r = qdb_e_ok;
    qdb::api_buffer_ptr allocated_content = h.get("entry", r);
    if (r != qdb_e_ok)
    {
        // error management
    }

Closing a connection
-----------------------

A connection can be explicitly closed and the handle released with the :cpp:func:`handle::close` method::

    h.close();

Note that when the :cpp:class:`handle` object is destroyed, :cpp:func:`handle::close` is automatically called.

.. caution::
    The usage of :c:func:`qdb_close` with :cpp:class:`handle` object results in undefined behaviour.

Expiry
-------

Expiry is set with :cpp:func:`handle::expires_at` and :cpp:func:`expires_from_now`. It is obtained with :cpp:func:`handle::get_expiry_time`. Expiry time is always in seconds, either relative to epoch (January 1st, 1970 00:00 UTC) when using :cpp:func:`handle::expires_at` or relative to the call time when using :cpp:func:`expires_from_now`.

.. danger::
    The behavior of :cpp:func:`expires_from_now` is undefined if the time zone or the clock of the client computer is improperly configured.

To set the expiry time of an entry to 1 minute, relative to the call time::

    char content[100];

    // ...

    r = h.put("myalias", content, sizeof(content), 0);
    if (r != qdb_error_ok)
    {
        // error management
    }

    r = h.expires_from_now("myalias", 60);
    if (r != qdb_error_ok)
    {
        // error management
    }

To prevent an entry from ever expiring::

    r = h.expires_at("myalias", 0);
    if (r != qdb_error_ok)
    {
        // error management
    }

By default, entries do not expire. To obtain the expiry time of an existing entry::

    qdb_time_t expiry_time = 0;
    r = h.get_expiry_time("myalias", &expiry_time);
    if (r != qdb_error_ok)
    {
        // error management
    }


Batch operations
-------------------

Batch operations are used similarly as in C, except a method :cpp:func:`handle::run_batch` is provided for convenience.

Iteration
-------------

Iteration on the cluster's entries can be done forward and backward.

An STL-like iterator API is provided which is compatible with STL algorithms::

    // forward loop
    std::for_each(h.begin(), h.end(), [](const qdb::const_iterator::value_type & v)
    {
        // work on the entry
        // v.first is an std::string refering to the entry's alias
        // v.second is qdb::api_buffer_ptr with the entry's content
    });

    // backward loop
    std::for_each(h.rbegin(), h.rend(), [](const qdb::const_reverse_iterator::value_type & v) { /* work on the entry */ });

There is however a significant difference with regular STL iterators: since entries are accessed remotely, an error may prevent the next entry from being retrieved, in which case the iterator will be considered to have reached the "end" of the iteration.

It is however possible to query the last error through the last_error() member function. The qdb_e_alias_not_found indicates the normal end of the iteration whereas other error statuses indicate that the iteration could not successfully complete. It is up to the programmer to decide what to do in case of error.

Iterators' value is a std::pair<std::string, qdb::api_buffer_ptr> which makes the manipulation of iterator associated data safe in most scenarii. Associated resources will be freed automatically through RAII.

The iterator api may throw the std::bad_alloc exception should a memory allocation fail.

.. note::
    Although each entry is returned only once, the order in which entries are returned is undefined.

Exceptions
------------

The quasardb C++ API does not throw any exception on its behalf, however situations such as low memory conditions may cause exceptions to be thrown.


Reference
----------------

.. doxygennamespace:: qdb
  :project: qdb_cpp_api
  :members:
