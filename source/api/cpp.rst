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
  ..                                     :cpp:class:`const_iterator`;                       ..
  :cpp:type:`qdb_error_t`                :cpp:func:`const_iterator::last_error`             (:c:type:`void`) const;
  :c:type:`bool`                         :cpp:func:`const_iterator::valid`                  (:c:type:`void`) const;
  ..                                     :cpp:class:`const_reverse_iterator`;               ..
  :cpp:type:`qdb_error_t`                :cpp:func:`const_reverse_iterator::last_error`     (:c:type:`void`) const;
  :c:type:`bool`                         :cpp:func:`const_reverse_iterator::valid`          (:c:type:`void`) const;
  ..                                     :cpp:class:`handle`;                               ..
  :cpp:type:`const_iterator`             :cpp:func:`handle::begin`                          (:c:type:`void`);
  :cpp:type:`const_iterator`             :cpp:func:`handle::end`                            (:c:type:`void`);
  :cpp:type:`const_reverse_iterator`     :cpp:func:`handle::rbegin`                         (:c:type:`void`);
  :cpp:type:`const_reverse_iterator`     :cpp:func:`handle::rend`                           (:c:type:`void`);
  :c:type:`void`                         :cpp:func:`handle::close`                          (:c:type:`void`);
  :c:type:`bool`                         :cpp:func:`handle::connected`                      (:c:type:`void`) const;
  :c:type:`void`                         :cpp:func:`handle::set_timeout`                    (:c:type:`int` timeout);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::connect`                        (:c:type:`const char *` uri);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::put`                            (:c:type:`const char *` alias, :c:type:`const char *` content, :cpp:type:`size_t` content_length, :cpp:type:`qdb_time_t` expiry_time);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::update`                         (:c:type:`const char *` alias, :c:type:`const char *` content, :cpp:type:`size_t` content_length, :cpp:type:`qdb_time_t` expiry_time);
  :cpp:type:`qdb_error_t`                :cpp:func:`handle::get`                            (:c:type:`const char *` alias, :c:type:`char *` content, :c:type:`size_t *` content_length);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::get`                            (:c:type:`const char *` alias, :c:type:`qdb_error_t &` error);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::get_and_remove`                 (:c:type:`const char *` alias, :c:type:`qdb_error_t &` error);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::get_and_update`                 (:c:type:`const char *` alias, :c:type:`const char *` update_content, :cpp:type:`size_t` update_content_length, :cpp:type:`qdb_time_t` expiry_time, :c:type:`qdb_error_t &` error);
  :cpp:type:`api_buffer_ptr`             :cpp:func:`handle::compare_and_swap`               (:c:type:`const char *` alias, :c:type:`const char *` new_value, :cpp:type:`size_t` new_value_length, :c:type:`const char *` comparand, :cpp:type:`size_t` comparand_length, :cpp:type:`qdb_time_t` expiry_time, :c:type:`qdb_error_t &` error);
  :c:type:`qdb_error_t`                  :cpp:func:`handle::remove`                         (:c:type:`const char *` alias);
  :c:type:`qdb_error_t`                  :cpp:func:`handle::remove_if`                      (:c:type:`const char *` alias, :c:type:`const char *` comparand, :cpp:type:`size_t` comparand_length);
  :c:type:`qdb_error_t`                  :cpp:func:`handle::remove_all`                     (:c:type:`void`);
  :cpp:type:`size_t`                     :cpp:func:`handle::run_batch`                      (:cpp:type:`qdb_operation_t` operations, :cpp:type:`size_t` operations_count);
  :cpp:type:`std::vector<std::string>`   :cpp:func:`handle::prefix_get`                     (:c:type:`const char *` prefix, :c:type:`qdb_error_t &` error);
  :c:type:`qdb_error_t`                  :cpp:func:`handle::expires_at`                     (:c:type:`const char *` alias, :cpp:type:`qdb_time_t` expiry_time);
  :c:type:`qdb_error_t`                  :cpp:func:`handle::expires_from_now`               (:c:type:`const char *` alias, :cpp:type:`qdb_time_t` expiry_delta);
  :c:type:`qdb_error_t`                  :cpp:func:`handle::get_expiry_time`                (:c:type:`const char *` alias, :c:type:`qdb_time_t &` expiry_time);
  :c:type:`qdb_error_t`                  :cpp:func:`handle::node_status`                    (:c:type:`const char *` uri, :c:type:`qdb_error_t &` error);
  :c:type:`qdb_error_t`                  :cpp:func:`handle::node_config`                    (:c:type:`const char *` uri, :c:type:`qdb_error_t &` error);
  :c:type:`qdb_error_t`                  :cpp:func:`handle::node_topology`                  (:c:type:`const char *` uri, :c:type:`qdb_error_t &` error);
  :c:type:`qdb_error_t`                  :cpp:func:`handle::stop_node`                      (:c:type:`const char *` uri, :c:type:`const char *` reason);
  ..                                     :cpp:type:`handle_ptr`;                            ..
  ..                                     :cpp:class:`api_buffer`;                           ..
  :c:type:`const char *`                 :cpp:func:`api_buffer::data`                       (:c:type:`void`) const;
  :cpp:type:`size_t`                     :cpp:func:`api_buffer::size`                       (:c:type:`void`) const;
  ..                                     :cpp:type:`api_buffer_ptr`;                        ..

 ====================================== ================================================== ===================



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
    size_t allocated_content_length = 0;
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


Prefix based search
---------------------

Prefix based search is a powerful tool that helps you lookup entries efficiently.

For example, if you want to find all entries whose aliases start with "record"::

    qdb_error_t err = qdb_e_uninitialized;
    std::vector<std::string> results = h.prefix_get("record", err);
    if (err != qdb_e_ok)
    {
        // error management
    }

    // you now have in results an array string representing the matching entries

The method takes care of allocating all necessary intermediate buffers. The caller does not need to do any explicit memory release.

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

.. cpp:function: std::string make_error_string(qdb_error_t err)

    Translate an error code into a meaningful English message. This function never fails.

    :param err: The error code to translate
    :type err: qdb_error_t

    :returns: A STL string containing an English sentence describing the error.

.. cpp:class:: const_iterator

    A forward iterator.

    .. cpp:function: const_iterator & operator ++ (void)

        Moves the iterator one entry forward. If no entry is available, error code will be set to qdb_e_alias_not_found.

        :returns: The updated iterator

    .. cpp:function: const_iterator & operator -- (void)

        Moves the iterator one entry backward. If no entry is available, error code will be set to qdb_e_alias_not_found.

    .. cpp:function:: qdb_error_t last_error(void) const

        :returns: The error code of the last iterator operation

    .. cpp:function:: bool valid(void) const

        :returns: true if the iterator is valid and points to an entry

.. cpp:class:: const_reverse_iterator

    A reverse iterator.

    .. cpp:function: const_iterator & operator ++ (void)

        Moves the iterator one entry backward. If no entry is available, error code will be set to qdb_e_alias_not_found.

        :returns: The updated iterator

    .. cpp:function: const_iterator & operator -- (void)

        Moves the iterator one entry forward. If no entry is available, error code will be set to qdb_e_alias_not_found.

    .. cpp:function:: qdb_error_t last_error(void) const

        :returns: The error code of the last iterator operation

    .. cpp:function:: bool valid(void) const

        :returns: true if the iterator is valid and points to an entry

.. cpp:class:: handle

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
        :type timeout: int

    .. cpp:function:: qdb_error_t connect(const char * uri)

        Initialize all required resources and connect to a remote host.

        :param host: A pointer to a null terminated string in the format "qdb://host:port[,host:port]".

        :returns: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t put(const char * alias, const char * content, size_t content_length, qdb_time_t expiry_time)

        Adds an entry to the quasardb server. If the entry already exists the method will fail and will return ``qdb_e_alias_already_exists``. Keys beginning with the string "qdb" are reserved and cannot be added to the cluster.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to create.
        :param content: A pointer to a buffer that represents the entry's content to be added to the server.
        :param content_length: The length of the entry's content, in bytes.
        :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch

        :returns: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t update(const char * alias, const char * content, size_t content_length, qdb_time_t expiry_time)

        Updates an entry on the quasardb server. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to update.
        :param content: A pointer to a buffer that represents the entry's content to be updated to the server.
        :param content_length: The length of the entry's content, in bytes.
        :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch

        :returns: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t get(const char * alias, char * content, size_t * content_length)

        Retrieves an entry's content from the quasardb server. The caller is responsible for allocating and freeing the provided buffer.

        If the entry does not exist, the method will fail and return ``qdb_e_alias_not_found``.

        If the buffer is not large enough to hold the data, the function will fail and return ``qdb_e_buffer_too_small``. content_length will nevertheless be updated with entry size so that the caller may resize its buffer and try again.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
        :param content: A pointer to an user allocated buffer that will receive the entry's content.
        :param content_length: A pointer to a size_t initialized with the length of the destination buffer, in bytes. It will be updated with the length of the retrieved content, even if the buffer is not large enough to hold all the data.

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

        Atomically gets an entry from the quasardb server and removes it.

        If the entry does not exist, the function will fail and update error to ``qdb_e_alias_not_found``.

        The function will allocate a buffer large enough to hold the entry's content.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias whose content is to be retrieved.
        :param error: A reference to an error that will receive the result of the operation.

        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.

    .. cpp:function:: api_buffer_ptr get_and_update(const char * alias, const char * update_content, size_t update_content_length, qdb_time_t expiry_time, qdb_error_t & error)

        Atomically gets and updates (in this order) the entry on the quasardb server. The entry must already exist.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to update.
        :param update_content: A pointer to a buffer that represents the entry's content to be updated to the server.
        :param update_content_length: The length of the buffer, in bytes.
        :param expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch
        :param error: A reference to an error that will receive the result of the operation.

        :returns: An api_buffer_ptr holding the entry content, if it exists, a null pointer otherwise.

    .. cpp:function:: api_buffer_ptr compare_and_swap(const char * alias, const char * new_value, size_t new_value_length, const char * comparand, size_t comparand_length, qdb_time_t expiry_time, qdb_error_t & error)

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

    .. cpp:function:: qdb_error_t remove(const char * alias)

        Removes an entry from the quasardb server. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to delete.

        :returns: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t remove_if(const char * alias, const char * comparand, size_t comparand_length)

        Removes an entry from the quasardb server if it matches comparand. The operation is atomic. If the entry does not exist, the function will fail and return ``qdb_e_alias_not_found``.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias to delete.
        :param comparand: A pointer to a buffer that represents the entry's content to be compared to.
        :param comparand_length: The length of the buffer, in bytes.

        :returns: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t remove_all(void)

        Removes all the entries on all the nodes of the quasardb cluster. The function returns when the command has been dispatched and executed on the whole cluster or an error occurred.

        This call is *not* atomic; if the command cannot be dispatched on the whole cluster, it will be dispatched on as many nodes as possible and the function will return with a qdb_e_ok code.

        The handle must be initialized and connected (see :cpp:func`connect).

        :returns: An error code of type :c:type:`qdb_error_t`

        .. caution:: This function is meant for very specific use cases and its usage is discouraged.

    .. cpp:function:: size_t run_batch(qdb_operation_t * operations, size_t operations_count)

        Runs the provided operations in batch on the cluster. The operations are run in arbitrary order.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param operations: Pointer to an array of qdb_operations_t
        :param operations_count: Size of the array, in entry count

        :returns: The number of successful operations

    .. cpp:function:: std::vector<std::string> prefix_get(const char * prefix, qdb_error_t & error)

        Searches the cluster for all entries whose aliases start with "prefix". The method will return a std::vector of std::string containing the aliases of matching entries.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param prefix: A pointer to a null terminated string representing the search prefix
        :param error: A reference to an error that will receive the result of the operation.

        :returns: A std::vector of std::string containing the aliases of matching entries.

    .. cpp:function:: qdb_error_t expires_at(const char * alias, qdb_time_t expiry_time)

        Sets the expiry time of an existing entry from the quasardb cluster. A value of zero means the entry never expires.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be set.
        :param expiry_time: Absolute time after which the entry expires

        :returns: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t expires_from_now(const char * alias, qdb_time_t expiry_delta)

        Sets the expiry time of an existing entry from the quasardb cluster. A value of zero means the entry expires as soon as possible.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be set.
        :param expiry_time: Time in seconds, relative to the call time, after which the entry expires
        :type expiry_time: :c:type:`qdb_time_t`

        :returns: An error code of type :c:type:`qdb_error_t`

    .. cpp:function:: qdb_error_t get_expiry_time(const char * alias, qdb_time_t & expiry_time)

        Retrieves the expiry time of an existing entry. A value of zero means the entry never expires.

        The handle must be initialized and connected (see :cpp:func`connect).

        :param alias: A pointer to a null terminated string representing the entry's alias for which the expiry must be get.
        :param expiry_time: A pointer to a qdb_time_t that will receive the absolute expiry time.

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

        :returns: An error code of type :c:type:`qdb_error_t`

        .. caution:: This function is meant for very specific use cases and its usage is discouraged.

.. cpp:type:: handle_ptr

    A smart pointer to a handle object.

.. cpp:class:: api_buffer

    An API allocated buffer returned by a method from the handle object. This object is meant to be used through the handle methods only.

    .. cpp:function:: const char * data(void) const

        Access the managed buffer, read-only.

        :returns: A pointer to the managed buffer.

    .. cpp:function:: size_t size(void) const

        Gives the size of the managed buffer.

        :returns: The size of the managed buffer.

.. cpp:type:: api_buffer_ptr

    A smart pointer definition used by the handle object.
