C++
====

.. cpp:namespace:: qdb
.. highlight:: cpp


.. // Can't pull the same :type: instead of :func: trick like I did in c.rst.
.. // The CPP parser is too smart to be fooled. We'll have to live with the extra ().

Quick Reference
---------------

 ====================================== ================================================== ===================
        Return Type                                  Name                                       Arguments     
 ====================================== ================================================== ===================
  ..                                     :cpp:class:`api_buffer`;                           ..
  :cpp:type:`bool`                       :cpp:func:`api_buffer::operator==`                 (:cpp:type:`const api_buffer &` other) const;
  :cpp:type:`bool`                       :cpp:func:`api_buffer::operator!=`                 (:cpp:type:`const api_buffer &` other) const;
  :cpp:type:`const char *`               :cpp:func:`api_buffer::data`                       (:cpp:type:`void`) const;
  :cpp:type:`qdb_size_t`                 :cpp:func:`api_buffer::size`                       (:cpp:type:`void`) const;
  ..                                     :cpp:type:`api_buffer_ptr`;                        ..
  ..                                     :cpp:class:`const_iterator`;                       ..
  :cpp:type:`bool`                       :cpp:func:`const_iterator::operator==`             (:cpp:type:`const const_iterator &` other) const;
  :cpp:type:`bool`                       :cpp:func:`const_iterator::operator!=`             (:cpp:type:`const const_iterator &` other) const;
  :cpp:type:`bool`                       :cpp:func:`const_iterator::operator++`             (:cpp:type:`void`);
  :cpp:type:`bool`                       :cpp:func:`const_iterator::operator--`             (:cpp:type:`void`);
  :cpp:type:`const value_type &`         :cpp:func:`const_iterator::operator*`              (:cpp:type:`void`) const;
  :cpp:type:`const value_type *`         :cpp:func:`const_iterator::operator->`             (:cpp:type:`void`) const;
  :cpp:type:`qdb_error_t`                :cpp:func:`const_iterator::last_error`             (:cpp:type:`void`) const;
  :cpp:type:`bool`                       :cpp:func:`const_iterator::valid`                  (:cpp:type:`void`) const;
  :cpp:type:`void`                       :cpp:func:`const_iterator::close`                  (:cpp:type:`void`);
  ..                                     :cpp:class:`const_reverse_iterator`;               ..
  :cpp:type:`bool`                       :cpp:func:`const_reverse_iterator::operator==`     (:cpp:type:`const const_reverse_iterator &` other) const;
  :cpp:type:`bool`                       :cpp:func:`const_reverse_iterator::operator!=`     (:cpp:type:`const const_reverse_iterator &` other) const;
  :cpp:type:`bool`                       :cpp:func:`const_reverse_iterator::operator++`     (:cpp:type:`void`);
  :cpp:type:`bool`                       :cpp:func:`const_reverse_iterator::operator--`     (:cpp:type:`void`);
  :cpp:type:`const value_type &`         :cpp:func:`const_reverse_iterator::operator*`      (:cpp:type:`void`) const;
  :cpp:type:`const value_type *`         :cpp:func:`const_reverse_iterator::operator->`     (:cpp:type:`void`) const;
  :cpp:type:`qdb_error_t`                :cpp:func:`const_reverse_iterator::last_error`     (:cpp:type:`void`) const;
  :cpp:type:`bool`                       :cpp:func:`const_reverse_iterator::valid`          (:cpp:type:`void`) const;
  :cpp:type:`void`                       :cpp:func:`const_reverse_iterator::close`          (:cpp:type:`void`);
  ..                                     :cpp:class:`handle`;                               ..
  :cpp:type:`handle &`                   :cpp:func:`handle::operator=`                      (:cpp:type:`handle &&` h) const;
  :cpp:type:`const_iterator`             :cpp:func:`handle::begin`                          (:cpp:type:`void`);
  :cpp:type:`const_iterator`             :cpp:func:`handle::end`                            (:cpp:type:`void`);
  :cpp:type:`const_reverse_iterator`     :cpp:func:`handle::rbegin`                         (:cpp:type:`void`);
  :cpp:type:`const_reverse_iterator`     :cpp:func:`handle::rend`                           (:cpp:type:`void`);
  :cpp:type:`void`                       :cpp:func:`handle::close`                          (:cpp:type:`void`);
  :cpp:type:`bool`                       :cpp:func:`handle::connected`                      (:cpp:type:`void`) const;
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::set_timeout`                    (:cpp:type:`int` timeout);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::set_compression`                (:cpp:type:`qdb_compression_t` comp_level);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::connect`                        (:cpp:type:`const char *` uri);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::put`                            (:cpp:type:`const char *` alias, :cpp:type:`const char *` content, :cpp:type:`qdb_size_t` content_length, :cpp:type:`qdb_time_t` expiry_time);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::int_get`                        (:cpp:type:`const char *` alias, :cpp:type:`qdb_int_t *` number);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::int_put`                        (:cpp:type:`const char *` alias, :cpp:type:`qdb_int_t` number, :cpp:type:`qdb_time_t` expiry_time);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::int_update`                     (:cpp:type:`const char *` alias, :cpp:type:`qdb_int_t` number, :cpp:type:`qdb_time_t` expiry_time);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::int_add`                        (:cpp:type:`const char *` alias, :cpp:type:`qdb_int_t` addend, :cpp:type:`qdb_int_t *` result = NULL);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::queue_size`                     (:cpp:type:`const char *` alias, :cpp:type:`qdb_size_t *` size);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::queue_get_at`                   (:cpp:type:`const char *` alias, :cpp:type:`qdb_size_t` index, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::queue_set_at`                   (:cpp:type:`const char *` alias, :cpp:type:`qdb_size_t` index, :cpp:type:`const char *` content, :cpp:type:`qdb_size_t` content_length);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::queue_push_front`               (:cpp:type:`const char *` alias, :cpp:type:`const char *` content, qdb_size_t content_length);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::queue_push_back`                (:cpp:type:`const char *` alias, :cpp:type:`const char *` content, qdb_size_t content_length);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::queue_pop_front`                (:cpp:type:`const char *` alias, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::queue_pop_back`                 (:cpp:type:`const char *` alias, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::queue_front`                    (:cpp:type:`const char *` alias, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::queue_back`                     (:cpp:type:`const char *` alias, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::hset_insert`                    (:cpp:type:`const char *` alias, :cpp:type:`const char *` content, :cpp:type:`qdb_size_t` content_length);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::hset_erase`                     (:cpp:type:`const char *` alias, :cpp:type:`const char *` content, :cpp:type:`qdb_size_t` content_length);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::hset_contains`                  (:cpp:type:`const char *` alias, :cpp:type:`const char *` content, :cpp:type:`qdb_size_t` content_length);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::update`                         (:cpp:type:`const char *` alias, :cpp:type:`const char *` content, :cpp:type:`qdb_size_t` content_length, :cpp:type:`qdb_time_t` expiry_time);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::get_noalloc`                    (:cpp:type:`const char *` alias, :cpp:type:`char *` content, :cpp:type:`qdb_size_t *` content_length);
  :cpp:type:`qdb_size_t`                 :cpp:func:`handle::run_batch`                      (:cpp:type:`qdb_operation_t` operations, :cpp:type:`qdb_size_t` operations_count);
  :cpp:type:`std::vector<batch_result>`  :cpp:func:`handle::run_batch`                      (:cpp:type:`const std::vector<batch_request> &` requests, :cpp:type:`qdb_size_t &` successes_count);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::run_transaction`                (:cpp:type:`qdb_operation_t *` operations, :cpp:type:`qdb_size_t` operations_count, :cpp:type:`qdb_size_t &` fail_index);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::get`                            (:cpp:type:`const char *` alias, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::get_and_remove`                 (:cpp:type:`const char *` alias, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::get_and_update`                 (:cpp:type:`const char *` alias, :cpp:type:`const char *` update_content, :cpp:type:`qdb_size_t` update_content_length, :cpp:type:`qdb_time_t` expiry_time, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::compare_and_swap`               (:cpp:type:`const char *` alias, :cpp:type:`const char *` new_value, :cpp:type:`qdb_size_t` new_value_length, :cpp:type:`const char *` comparand, :cpp:type:`qdb_size_t` comparand_length, :cpp:type:`qdb_time_t` expiry_time, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::expires_at`                     (:cpp:type:`const char *` alias, :cpp:type:`qdb_time_t` expiry_time);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::expires_from_now`               (:cpp:type:`const char *` alias, :cpp:type:`qdb_time_t` expiry_delta);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::get_expiry_time`                (:cpp:type:`const char *` alias, :cpp:type:`qdb_time_t &` expiry_time);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::get_location`                   (:cpp:type:`const char *` alias, :cpp:type:`remote_node &` location);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::get_type`                       (:cpp:type:`const char *` alias, :cpp:type:`qdb_entry_type *` entry_type);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::node_status`                    (:cpp:type:`const char *` uri, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::node_config`                    (:cpp:type:`const char *` uri, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::node_topology`                  (:cpp:type:`const char *` uri, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::stop_node`                      (:cpp:type:`const char *` uri, :cpp:type:`const char *` reason);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::remove`                         (:cpp:type:`const char *` alias);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::remove_if`                      (:cpp:type:`const char *` alias, :cpp:type:`const char *` comparand, :cpp:type:`qdb_size_t` comparand_length);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::add_tag`                        (:cpp:type:`const char *` alias, :cpp:type:`const char *` tag);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::has_tag`                        (:cpp:type:`const char *` alias, :cpp:type:`const char *` tag);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::remove_tag`                     (:cpp:type:`const char *` alias, :cpp:type:`const char *` tag);
  :cpp:type:`std::vector<std::string>`   :cpp:func:`handle::get_tagged`                     (:cpp:type:`const char *` tag, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`std::vector<std::string>`   :cpp:func:`handle::get_tags`                       (:cpp:type:`const char *` alias, :cpp:type:`qdb_error_t &` error);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::purge_all`                      (:cpp:type:`void`);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::trim_all`                       (:cpp:type:`void`);
  ..                                     :cpp:type:`handle_ptr`;                            ..
  :cpp:type:`std::string`                :cpp:func:`make_error_string`                      (qdb_error_t err);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`make_api_buffer_ptr`                    (qdb_handle_t h, const char * data, qdb_size_t length);
  
 ====================================== ================================================== ===================



Introduction
--------------

The quasardb C++ API is a wrapper around the C API that brings convenience and flexibility without sacrificing performance. Because the behaviour is similar to the C API, you may wish to familiarize yourself with the C API before working with the C++ API (see :doc:`c`).

Installing
--------------

The C++ API package is qdb-capi-<version>, and can be downloaded from the Bureau 14 download site. All information regarding the Bureau 14 download site is in your welcome e-mail. The contents of the C++ API package are::
    
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

.. cpp:class:: api_buffer

    An API allocated buffer returned by a method from the handle object. This object is meant to be used through the handle methods only.

    .. cpp:function:: bool operator == (const api_buffer & other) const
        
        Determine if two API buffers are identical.
        
        :param other: The api_buffer to compare against.
        :returns: True if the buffers are identical, false otherwise.
    
    .. cpp:function:: bool operator != (const api_buffer & other) const
        
        Determine if two API buffers are not identical.
        
        :param other: The api_buffer to compare against.
        :returns: True if the buffers are not identical, false otherwise.
    
    .. cpp:function:: const char * data(void) const

        Access the managed buffer, read-only.

        :returns: A pointer to the managed buffer.

    .. cpp:function:: qdb_size_t size(void) const

        Gives the size of the managed buffer.

        :returns: The size of the managed buffer.

    .. cpp:function:: qdb_size_t size(void) const

        Gives the size of the managed buffer.

        :returns: The size of the managed buffer.

.. cpp:type:: api_buffer_ptr

    A smart pointer to an api_buffer used by the handle object.


.. cpp:class:: const_iterator

    A forward iterator.

    .. cpp:function:: bool operator == (const const_iterator & other) const
        
        Determine if two const_iterators are identical.
        
        :param other: The const_iterator to compare against.
        :returns: True if the iterators are identical, false otherwise.
    
    .. cpp:function:: bool operator != (const const_iterator & other) const
        
        Determine if two const_iterators are not identical.
        
        :param other: The const_iterator to compare against.
        :returns: True if the const_iterators are not identical, false otherwise.
    
    .. cpp:function:: const_iterator & operator ++ (void)

        Moves the iterator one entry forward. If no entry is available, error code will be set to qdb_e_alias_not_found.

        :returns: The updated iterator

    .. cpp:function:: const_iterator & operator -- (void)

        Moves the iterator one entry backward. If no entry is available, error code will be set to qdb_e_alias_not_found.

    .. cpp:function:: const value_type & operator * (void) const
    
        Gets the value of the object at the iterator.

        :returns: A key/value pair.

    .. cpp:function:: const value_type & operator -> (void) const
    
        Gets a pointer to the object at the iterator.

        :returns: A pointer to a key/value pair.

    .. cpp:function:: qdb_error_t last_error(void) const

        :returns: The error code of the last iterator operation

    .. cpp:function:: bool valid(void) const

        :returns: true if the iterator is valid and points to an entry

    .. cpp:function:: void close(void)
    
        Closes the connection to the iterator.


.. cpp:class:: const_reverse_iterator

    A reverse iterator.

    .. cpp:function:: bool operator == (const const_reverse_iterator & other) const
        
        Determine if two const_reverse_iterators are identical.
        
        :param other: The const_reverse_iterator to compare against.
        :returns: True if the iterators are identical, false otherwise.
    
    .. cpp:function:: bool operator != (const const_reverse_iterator & other) const
        
        Determine if two const_reverse_iterators are not identical.
        
        :param other: The const_reverse_iterator to compare against.
        :returns: True if the const_reverse_iterators are not identical, false otherwise.
    
    .. cpp:function:: const_reverse_iterator & operator ++ (void)

        Moves the iterator one entry backward. If no entry is available, error code will be set to qdb_e_alias_not_found.

        :returns: The updated iterator

    .. cpp:function:: const_reverse_iterator & operator -- (void)

        Moves the iterator one entry forward. If no entry is available, error code will be set to qdb_e_alias_not_found.

    .. cpp:function:: const value_type & operator * (void) const
    
        Gets the value of the object at the iterator.

        :returns: A key/value pair.

    .. cpp:function:: const value_type & operator -> (void) const
    
        Gets a pointer to the object at the iterator.

        :returns: A pointer to a key/value pair.

    .. cpp:function:: qdb_error_t last_error(void) const

        :returns: The error code of the last iterator operation

    .. cpp:function:: bool valid(void) const

        :returns: true if the iterator is valid and points to an entry

    .. cpp:function:: qdb_error_t last_error(void) const

        :returns: The error code of the last iterator operation

    .. cpp:function:: void close(void)
    
        Closes the connection to the iterator.


.. cpp:class:: handle

    .. cpp:function:: handle & operator = (handle && h) const
        
        Move constructor for handle. Requires ```#define QDBAPI_RVALUE_SUPPORT 1```.
        
        :param h: The original handle pointer.
        :returns: The new handle pointer.
    
    .. cpp:function:: const_iterator begin(void)

       :returns: A forward iterator pointing to the first entry in the cluster.

    .. cpp:function:: const_iterator end(void)

       :returns: A forward iterator pointing beyond the last entry in the cluster.

    .. cpp:function:: const_reverse_iterator rbegin(void)

       :returns: A reverse iterator pointing to the last entry in the cluster.

    .. cpp:function:: const_reverse_iterator rend(void)

       :returns: A reverse iterator pointing before the first entry in the cluster.

    .. cpp:function:: void close(void)

        Close the handle and release all associated resources.

    .. cpp:function:: bool connected(void) const

        Determine if the handle is connected or not.

        :returns: true if the handle is connected, false otherwise

    .. cpp:function:: void set_timeout(int timeout)

        Set the timeout, in milliseconds, for all operations.

        :param timeout: The timeout, in milliseconds.

    .. cpp:function:: void set_compression(qdb_compression_t comp_level)

        Sets the compression level for all network calls.

        :param comp_level: The compression level.

    .. cpp:function:: qdb_error_t connect(const char * uri)

        Initialize all required resources and connect to a remote host.

        :param host: A pointer to a null terminated string in the format "qdb://host:port[,host:port]".

        :returns: An error code of type :cpp:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t put(const char * alias, const char * content, qdb_size_t content_length, qdb_time_t expiry_time)

        Adds an entry to the quasardb server. If the entry already exists the method will fail and will return ``qdb_e_alias_already_exists``. Keys beginning with the string "qdb" are reserved and cannot be added to the cluster.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to create.
        :param content: A pointer to a buffer that represents the entry's content to be added to the server.
        :param content_length: The length of the entry's content, in bytes.
        :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch

        :returns: An error code of type :cpp:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t int_get(const char * alias, qdb_int_t * number)
    
        Retrieves the value of an integer. The integer must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param number: The value of the retrieved qdb_int_t.
        
        :returns: An error code of type :cpp:type:`qdb_error_t`
    
    .. cpp:function:: qdb_error_t int_put(const char * alias, qdb_int_t number, qdb_time_t expiry_time)
    
        Creates a new integer. Errors if the integer already exists.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param number: The value of the retrieved qdb_int_t.
        :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
        
        :returns: An error code of type :cpp:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t int_update(const char * alias, qdb_int_t number, qdb_time_t expiry_time)
    
        Updates an existing integer or creates one if it does not exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param number: The value of the retrieved qdb_int_t.
        :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
        
        :returns: An error code of type :cpp:type:`qdb_error_t`
        
    .. cpp:function:: qdb_error_t int_add(const char * alias, qdb_int_t addend, qdb_int_t * result = NULL)
    
        Atomically addes the value to the integer. The integer must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param addend: The value that will be added to the existing qdb_int_t.
        :param result: A pointer that will be updated to point to the new qdb_int_t.
        
        :returns: An error code of type :cpp:type:`qdb_error_t`
        
    .. cpp:function:: qdb_error_t queue_size(const char * alias, qdb_size_t * size)
    
        Retrieves the size of the queue. The queue must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param size: A pointer to a qdb_size_t that will be set to the content's size, in bytes.
        
        :returns: An error code of type :cpp:type:`qdb_error_t`
    
    .. cpp:function:: api_buffer_ptr queue_get_at(const char * alias, qdb_size_t index, qdb_error_t & error)
        
        Retrieves the value of the queue at the specified index. The queue must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param index: The index you wish to retrieve.
        :param error: A reference to an error that will receive the result of the operation.
        
        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.
        
    .. cpp:function:: qdb_error_t queue_set_at(const char * alias, qdb_size_t index, const char * content, qdb_size_t content_length)
        
        Sets the value of the queue at the specified index. The queue must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param index: The index you wish to retrieve.
        :param content: A pointer to a buffer that represents the entry's content to be added to the server.
        :param content_length: The length of the entry's content, in bytes.
        
        :returns: An error code of type :cpp:type:`qdb_error_t`
        
    .. cpp:function:: qdb_error_t queue_push_front(const char * alias, const char * content, qdb_size_t content_length)
        
        Inserts the content at the front of the queue. Creates the queue if it does not exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param content: A pointer to the content that will be added to the queue.
        :param content_length: A pointer to a qdb_size_t that will be set to the content's size, in bytes.
        
        :returns: An error code of type :cpp:type:`qdb_error_t`
        
    .. cpp:function:: qdb_error_t queue_push_back(const char * alias, const char * content, qdb_size_t content_length)
        
        Inserts the content at the back of the queue. Creates the queue if it does not exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param content: A pointer to the content that will be added to the queue.
        :param content_length: A pointer to a qdb_size_t that will be set to the content's size, in bytes.
        
        :returns: An error code of type :c:type:`qdb_error_t`
    
    .. cpp:function:: api_buffer_ptr queue_pop_front(const char * alias, qdb_error_t & error)
        
        Removes and retrieves the item at the front of the queue. The queue must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param error: A reference to an error that will receive the result of the operation.
        
        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.
    
    .. cpp:function:: api_buffer_ptr queue_pop_back(const char * alias, qdb_error_t & error)
        
        Removes and retrieves the item at the back of the queue. The queue must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param error: A reference to an error that will receive the result of the operation.
        
        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.
    
    .. cpp:function:: api_buffer_ptr queue_front(const char * alias, qdb_error_t & error)
        
        Retrieves the item at the front of the queue. The queue must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param error: A reference to an error that will receive the result of the operation.
        
        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.
    
    .. cpp:function:: api_buffer_ptr queue_back(const char * alias, qdb_error_t & error)
        
        Retrieves the item at the back of the queue. The queue must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param error: A reference to an error that will receive the result of the operation.
        
        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.
    
    .. cpp:function:: qdb_error_t hset_insert(const char * alias, const char * content, qdb_size_t content_length)
        
        Inserts a value into a hset. Creates the hset if it does not already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param content: A pointer to the content that will be added to the hset.
        :param content_length: A qdb_size_t with the length of the target buffer, in bytes.
        
        :returns: An error code of type :c:type:`qdb_error_t`
    
    .. cpp:function:: qdb_error_t hset_erase(const char * alias, const char * content, qdb_size_t content_length)
        
        Removes a value from a hset. The hset must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param content: A pointer to the content that will be removed from the hset.
        :param content_length: A qdb_size_t with the length of the target buffer, in bytes.
        
        :returns: An error code of type :c:type:`qdb_error_t`
    
    .. cpp:function:: qdb_error_t hset_contains(const char * alias, const char * content, qdb_size_t content_length)
    
        Determines if a hset has a given value. The hset must already exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param content: A pointer to a buffer to search for and compare against.
        :param content_length: A qdb_size_t with the length of the target buffer, in bytes.
        
        :returns: An error code of type :c:type:`qdb_error_t`
    
    .. cpp:function:: qdb_error_t update(const char * alias, const char * content, qdb_size_t content_length, qdb_time_t expiry_time)

        Updates an entry on the quasardb server. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to update.
        :param content: A pointer to a buffer that represents the entry's content to be updated to the server.
        :param content_length: The length of the entry's content, in bytes.
        :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch

        :returns: An error code of type :cpp:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t get_noalloc(const char * alias, char * content, qdb_size_t * content_length)

        Retrieves an entry's content from the quasardb server. The caller is responsible for allocating and freeing the provided buffer.

        If the entry does not exist, the method will fail and return ``qdb_e_alias_not_found``.

        If the buffer is not large enough to hold the data, the function will fail and return ``qdb_e_buffer_too_small``. content_length will nevertheless be updated with entry size so that the caller may resize its buffer and try again.

        The handle must be initialized and connected (see :cpp:func`connect`).

        :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
        :param content: A pointer to an user allocated buffer that will receive the entry's content.
        :param content_length: A pointer to a qdb_size_t initialized with the length of the destination buffer, in bytes. It will be updated with the length of the retrieved content, even if the buffer is not large enough to hold all the data.

        :returns: An error code of type :cpp:type:`qdb_error_t`
        
    .. cpp:function:: qdb_size_t run_batch(qdb_operation_t * operations, qdb_size_t operations_count)

        Runs the provided operations in batch on the cluster. The operations are run in arbitrary order.

        It is preferred to use the std::vector version of run_batch where possible.

        :param operations: Pointer to an array of qdb_operations_t
        :param operations_count: Size of the array, in entry count

        :returns: The number of successful operations
        
    .. cpp:function:: std::vector run_batch(const std::vector<batch_request> & requests, qdb_size_t & successes_count)
        
        Runs the provided operations in batch on the cluster. The operations are run in arbitrary order.
        
        :param requests: A vector containing the batch requests to run on the cluster.
        :param operations_count: A reference that will be set to the number of successful operations.

        :returns: A vector containing the batch results.
        
    .. cpp:function:: qdb_error_t run_transaction(qdb_operation_t * operations, qdb_size_t operations_count, qdb_size_t & fail_index)
    
        Runs the provided operations as a transaction on the cluster. The operations are run in the provided order. If any operation fails, all previously run operations are rolled back.

        :param operations: Pointer to an array of qdb_operations_t
        :param operations_count: Size of the array, in entry count
        :param fail_index: The index in the operations array for the operation that failed.

        :returns: An error code of type :c:type:`qdb_error_t` 

    .. cpp:function:: api_buffer_ptr get(const char * alias, qdb_error_t & error)

        Retrieves an entry's content from the quasardb server.

        If the entry does not exist, the function will fail and update error to ``qdb_e_alias_not_found``.

        The function will allocate a buffer large enough to hold the entry's content.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
        :param error: A reference to an error that will receive the result of the operation.

        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.

    .. cpp:function:: api_buffer_ptr get_and_remove(const char * alias, qdb_error_t & error)

        Atomically gets an entry from the quasardb server and removes it. If the entry does not exist, the function will fail and update error to ``qdb_e_alias_not_found``.

        The function will allocate a buffer large enough to hold the entry's content.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
        :param error: A reference to an error that will receive the result of the operation.

        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.

    .. cpp:function:: api_buffer_ptr get_and_update(const char * alias, const char * update_content, qdb_size_t update_content_length, qdb_time_t expiry_time, qdb_error_t & error)

        Atomically gets and updates (in this order) the entry on the quasardb server. The entry must already exist.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to update.
        :param update_content: A pointer to a buffer that represents the entry's content to be updated to the server.
        :param update_content_length: The length of the buffer, in bytes.
        :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
        :param error: A reference to an error that will receive the result of the operation.

        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.

    .. cpp:function:: api_buffer_ptr compare_and_swap(const char * alias, const char * new_value, qdb_size_t new_value_length, const char * comparand, qdb_size_t comparand_length, qdb_time_t expiry_time, qdb_error_t & error)

        Atomically compares the entry with comparand and updates it to new_value if, and only if, they match. Always return the original value of the entry.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to compare to.
        :param new_value: A pointer to a buffer that represents the entry's content to be updated to the server in case of match.
        :param new_value_length: The length of the buffer, in bytes.
        :param comparand: A pointer to a buffer that represents the entry's content to be compared to.
        :param comparand_length: The length of the buffer, in bytes.
        :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
        :param error: A reference to an error that will receive the result of the operation.

        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.

    .. cpp:function:: qdb_error_t expires_at(const char * alias, qdb_time_t expiry_time)

        Sets the expiry time of an existing entry from the quasardb cluster. A value of zero means the entry never expires.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be set.
        :param expiry_time: Absolute time after which the entry expires

        :returns: An error code of type :cpp:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t expires_from_now(const char * alias, qdb_time_t expiry_delta)

        Sets the expiry time of an existing entry from the quasardb cluster. A value of zero means the entry expires as soon as possible.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be set.
        :param expiry_time: Time in seconds, relative to the call time, after which the entry expires

        :returns: An error code of type :cpp:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t get_expiry_time(const char * alias, qdb_time_t & expiry_time)

        Retrieves the expiry time of an existing entry. A value of zero means the entry never expires.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be get.
        :param expiry_time: A pointer to a qdb_time_t that will receive the absolute expiry time.

        :returns: An error code of type :cpp:type:`qdb_error_t`
    
    .. cpp:function:: qdb_error_t get_location(const char * alias, remote_node & location)
        
        Retrieves an array of locations where the entry is stored in the cluster.

        The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param location: A pointer to a qdb_remote_node_t that will receive the entry locations.

        :returns: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t get_type(const char * alias, qdb_entry_type_t * entry_type)
        
        Retrieves the type of the entry.

        The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param location: A pointer to a qdb_entry_type_t that will receive the entry locations.

        :returns: An error code of type :c:type:`qdb_error_t`
    
    .. cpp:function:: qdb_error_t node_status(const char * uri, qdb_error_t & error)

        Obtains a node status as a JSON string.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param node: A pointer to a null terminated string in the format "qdb://host:port".
        :param error: A reference to an error code that will be updated according to the success of the operation

        :returns: The status of the node as a JSON string.

    .. cpp:function:: qdb_error_t node_config(const char * uri, qdb_error_t & error)

        Obtains a node configuration as a JSON string.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param node: A pointer to a null terminated string in the format "qdb://host:port".
        :param error: A reference to an error code that will be updated according to the success of the operation

        :returns: The configuration of the node as a JSON string.

    .. cpp:function:: qdb_error_t node_topology(const char * uri, qdb_error_t & error)

        Obtains a node topology as a JSON string.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param node: A pointer to a null terminated string in the format "qdb://host:port".
        :param error: A reference to an error code that will be updated according to the success of the operation

        :returns: The topology of the node as a JSON string.

    .. cpp:function:: qdb_error_t stop_node(const char * uri, const char * reason)

        Stops the node designated by its host and port number. This stop is generally effective a couple of seconds after it has been issued,
        enabling inflight calls to complete successfully.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param node: A pointer to a null terminated string in the format "qdb://host:port".
        :param reason: A pointer to a null terminated string detailling the reason for the stop that will appear in the remote node's log.

        :returns: An error code of type :cpp:type:`qdb_error_t`

        .. caution:: This function is meant for very specific use cases and its usage is discouraged.
    
    .. cpp:function:: qdb_error_t remove(const char * alias)

        Removes an entry from the quasardb server. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to delete.

        :returns: An error code of type :cpp:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t remove_if(const char * alias, const char * comparand, qdb_size_t comparand_length)

        Removes an entry from the quasardb server if it matches comparand. The operation is atomic. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to delete.
        :param comparand: A pointer to a buffer that represents the entry's content to be compared to.
        :param comparand_length: The length of the buffer, in bytes.

        :returns: An error code of type :cpp:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t add_tag(const char * alias, const char * tag)
    
        Assigns a tag to an entry. The tag is created if it does not exist.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param tag: A pointer to a null terminated string representing the tag.
        
        :returns: An error code of type :c:type:`qdb_error_t`
    
    .. cpp:function:: qdb_error_t has_tag(const char * alias, const char * tag)

    Determines if a given tag has been assigned to an entry.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param tag: A pointer to a null terminated string representing the tag.
        
        :returns: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t remove_tag(const char * alias, const char * tag)
        
        Removes a tag assignment from an entry.
        
        :param alias: A pointer to a null terminated string representing the entry's alias.
        :param tag: A pointer to a null terminated string representing the tag.
        
        :returns: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: std::vector<std::string> get_tagged(const char * tag, qdb_error_t & error)
    
        Retrieves the aliases that have been tagged with the given tag.
        
        :param tag: A pointer to a null terminated string representing the tag.
        :param error: A qdb_error_t reference that will be set to the error code, if any.
        
        :returns: A std::vector containing the aliases tagged with the tag.
    
    .. cpp:function:: std::vector<std::string> get_tags(const char * alias, qdb_error_t & error)
    
        Retrieves the tags assigned to the given alias.
        
        :param alias: A pointer to a null terminated string representing the alias.
        :param error: A qdb_error_t reference that will be set to the error code, if any.
        
        :returns: A std::vector containing the tags assigned to the alias.

    .. cpp:function:: qdb_error_t purge_all(void)

        Removes all the entries on all the nodes of the quasardb cluster. The function returns when the command has been dispatched and executed on the whole cluster or an error occurred.

        This call is *not* atomic; if the command cannot be dispatched on the whole cluster, it will be dispatched on as many nodes as possible and the function will return with a qdb_e_ok code.

        The handle must be initialized and connected (see :cpp:func`connect).

        :returns: An error code of type :cpp:type:`qdb_error_t`

        .. caution:: This function is meant for very specific use cases and its usage is discouraged.

    .. cpp:function:: qdb_error_t trim_all(void)
        
        Manually runs the garbage collector, removing stale versions of entries from the cluster. This may free a small portion of disk space or memory.
        
        This call is **not** atomic: if the command cannot be dispatched on the whole cluster, it will be dispatched on as many nodes as possible and the function will return with a qdb_e_ok code. 

        The handle must be initialized (see :c:func:`qdb_open` and :c:func:`qdb_open_tcp`) and the connection established (see :c:func:`qdb_connect`).

        :returns: An error code of type :c:type:`qdb_error_t`
    
    
    
    
.. cpp:type:: handle_ptr

    A smart pointer to a handle object.

.. cpp:function:: std::string make_error_string(qdb_error_t err)

    Translate an error code into a meaningful English message. This function never fails.

    :param err: The error code to translate

    :returns: A STL string containing an English sentence describing the error.

.. cpp:function:: api_buffer_ptr make_api_buffer_ptr(qdb_handle_t h, const char * data, qdb_size_t length)
    
    Allocates an api_buffer_ptr.
    
    :param h: A qdb handle.
    :param data: A pointer to a buffer that represents the entry's content.
    :param length: The length of the buffer, in bytes.
