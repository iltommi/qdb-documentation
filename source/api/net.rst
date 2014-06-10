.NET
====

.. cpp:namespace:: qdb
.. highlight:: csharp

Introduction
--------------

The quasardb C++ API is a wrapper around the C API that brings convenience and flexibility without sacrificing performance. Behaviour is similar to that of the C API (see :doc:`c`).

Installing
--------------

The C++ API package consists of one header and is included in the C API package (see :doc:`c`). Both the C and C++ header files must be linked into the client executable, but no additional linking is required.

Header file
--------------

All functions, typedefs and enums are made available in the ``include/qdb/client.hpp`` header file. All classes and methods reside in the ``qdb`` namespace.

Exceptions
------------

The quasardb C++ API does not throw any exception on its behalf, however situations such as low memory conditions may cause exceptions to be thrown.

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

Although one may use the handle object with the C API, using the handle object's methods is recommended. For example, to put and get an entry, the C++ way::

    const char in_data[10];

    qdb_error_t r = h.put("entry", in_data, 0);
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

The largest difference between the C and C++ get calls are their memory allocation lifetimes. The C call :c:func:`qdb_get_buffer` allocates a buffer of the needed size and must be explicitly freed. The C++ handle.get() method uses uses smart pointers to manage allocations lifetime.

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

Reference
----------------

.. cpp:class:: Exception

    .. cpp:function:: Exception::ctor(System::Int32 error)
        
        Constructs an exception from a quasardb exception code. Do not use this constructor with codes that are not proper quasardb error codes.
        
        :param: error: The quasardb error code to convert to an Exception.
        :returns: An exception.


.. cpp:class:: Handle

    .. cpp:function:: Handle Handle()
        
        Constructor. Creates a qdb.Handle object by which you can manipulate the cluster.
        
        :returns: A qdb.Handle object.


    .. cpp:function:: void ~Handle()
        
        Destructor. Destroys a qdb.Handle object. Automatically calls Close() on the handle before releasing the memory.


    .. cpp:function:: void Close()
        
        Terminates all connections and releases all client-side allocated resources.


    .. cpp:function:: bool Connected()
        
        Tests if the current handle is properly connected to a quasardb cluster.
        
        :returns: true if the handle is properly connected to a cluster.


    .. cpp:function:: void SetTimeout(System::TimeSpan timeout)
        
        Sets the timeout for connections.
        
        :param: timeout: The amount of time after which the connection should timeout.
        :type timeout: System::TimeSpan


    .. cpp:function:: void Connect(System::Net::IPEndPoint host)
        
        Bind the client instance to a quasardb cluster and connect to the given node within the cluster.
        
        :param: host: The remote host to connect to.
        :type host: System::Net::IPEndPoint


    .. cpp:function:: Exception[] Multiconnect(System::Net::IPEndPoint[] hosts)
        
        Bind the client instance to a quasardb cluster and connect to multiple nodes within the cluster. If the same node (address and port) is present several times in the input array, it will count as only one successful connection. All hosts must belong to the same quasardb cluster. Only one connection to a listed node has to succeed for the connection to the cluster to be successful.
        
        :param: hosts: an array of remote hosts to connect to.
        :returns: an array of Exceptions, matching each provided endpoint, or nullptr if no error occurred.


    .. cpp:function:: void Put(System::String alias, System::Byte[] buffer)
        
        Adds an entry to the quasardb server. If the entry already exists the function will fail.
        
        :param: alias: The entry's alias to create.
        :param: buffer: The entry's content to be added to the server.


    .. cpp:function:: void Put(System::String alias, System::Byte[] buffer, System::DateTime expiryTime)
        
        Adds an entry to the quasardb server. If the entry already exists the function will fail.
        
        :param: alias: The entry's alias to create.
        :param: buffer: The entry's content to be added to the server.
        :param: expiryTime: The absolute expiry time of the entry.


    .. cpp:function:: void Update(System::String alias, System::Byte[] buffer)
        
        Updates an entry on the quasardb server. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.
        
        :param: alias: The entry's alias to update.
        :param: buffer: The entry's content to be updated to the server.


    .. cpp:function:: void Update(System::String alias, System::Byte[] buffer, System::DateTime expiryTime)
        
        Updates an entry on the quasardb server. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.
        
        :param: alias: The entry's alias to update.
        :param: buffer: The entry's content to be updated to the server.
        :param: expiryTime: The absolute expiry time of the entry.


    .. cpp:function:: System::Byte[] Get(System::String alias)
        
        Retrieves an entry's content from the quasardb server. If the entry does not exist, the function will fail.
        
        :param: alias: The entry's alias whose content is to be retrieved.
        :returns: The requested entry's content.


    .. cpp:function:: System::Byte[] GetRemove(System::String alias)
        
        Atomically gets an entry from the quasardb server and removes it. If the entry does not exist, the function will fail.
        
        :param: alias: The entry's alias whose content is to be retrieved.
        :returns: The requested entry's content.


    .. cpp:function:: System::Byte[] GetUpdate(System::String alias, System::Byte[] buffer)
        
        Atomically gets and updates (in this order) the entry on the quasardb server. If the entry does not exist, the function will fail.
        
        :param: alias: The entry's alias to update.
        :param: buffer: The entry's content to be updated to the server.
        :returns: The requested entry's content, before the update.


    .. cpp:function:: System::Byte[] GetUpdate(System::String alias, System::Byte[] buffer, System::DateTime expiryTime)
        
        Atomically gets and updates (in this order) the entry on the quasardb server. If the entry does not exist, the function will fail.
        
        :param: alias: The entry's alias to update.
        :param: buffer: The entry's content to be updated to the server.
        :param: expiryTime: The absolute expiry time of the entry.
        :returns: The requested entry's content, before the update.


    .. cpp:function:: System::Byte[] CompareAndSwap(System::String alias, System::Byte[] newValue, System::Byte[] comparand)
        
        Atomically compares the entry with the comparand and updates it to newValue if, and only if, they match.
        
        :param: alias: The entry's alias to update.
        :param: newValue: The entry's content to be updated to the server in case of match.
        :param: comparand: The entry's content to be compared to.
        :returns: The original content, before the update, if any.


    .. cpp:function:: System::Byte[] CompareAndSwap(System::String alias, System::Byte[] newValue, System::Byte[] comparand, System::DateTime expiryTime)
        
        Atomically compares the entry with the comparand and updates it to newValue if, and only if, they match.
        
        :param: alias: The entry's alias to update.
        :param: newValue: The entry's content to be updated to the server in case of match.
        :param: comparand: The entry's content to be compared to.
        :param: expiryTime: The absolute expiry time of the updated entry.
        :returns: The original content, before the update, if any.


    .. cpp:function:: void Remove(System::String alias)
        
        Removes an entry from the quasardb server. If the entry does not exist, the function will fail.
        
        :param: alias: The entry's alias to delete.


    .. cpp:function:: bool RemoveIf(System::String alias, System::Byte[] comparand)
        
        Atomically compares the entry with the comparand and updates it to newValue if, and only if, they match.
        
        :param: alias: The entry's alias to delete.
        :param: comparand: The entry's content to be compared to.
        :returns: True if the entry was successfully removed, false otherwise.


    .. cpp:function:: void RemoveAll()
        
        Removes all the entries on all the nodes of the quasardb cluster. The function returns when the command has been dispatched and executed on the whole cluster or an error occurred.


    .. cpp:function:: qdb::BatchResult[] RunBatch(qdb::BatchRequest[] requests)
        
        Runs the provided operations in batch on the cluster. The operations are run in arbitrary order.
        
        :param: requests: An array of operations to run on the cluster in batch.
        :returns: An array of results in the same order of the supplied operations.


    .. cpp:function:: System::String[] PrefixGet(System::String prefix)
        
        Searches the cluster for all entries whose aliases start with "prefix". The method will return an array of strings containing the aliases of matching entries.
        
        :param: prefix: A string representing the search prefix.
        :returns: An array of strings containing the aliases of matching entries.


    .. cpp:function:: void ExpiresAt(System::String alias, System::DateTime expiryTime)
        
        Sets the expiry time of an existing entry from the quasardb cluster. A value of null means the entry never expires.
        
        :param: alias: A string representing the entry's alias for which the expiry must be set.
        :param: expiryTime: The absolute time at which the entry expires.


    .. cpp:function:: void ExpiresFromNow(System::String alias, System::TimeSpan expiryDelta)
        
        Sets the expiry time of an existing entry from the quasardb cluster, relative to the current time.
        
        :param: alias: A string representing the entry's alias for which the expiry must be set.
        :param: expiryDelta: Time, relative to the call time, after which the entry expires.


    .. cpp:function:: System::DateTime GetExpiryTime(System::String alias)
        
        Retrieves the expiry time of an existing entry. A value of null means the entry never expires.
        
        :param: alias: A string representing the entry's alias for which the expiry must be retrieved.
        :returns: The absolute expiry time, null if there is no expiry.


    .. cpp:function:: System::String NodeStatus(System::Net::IPEndPoint host)
        
        Obtains a node status as a JSON string.
        
        :param: host: The remote node to get the status from.
        :returns: The status of the node as a JSON string.


    .. cpp:function:: System::String Handle::NodeConfig(System::Net::IPEndPoint host)
        
        Obtains a node configuration as a JSON string.
        
        :param: host: The remote node to get the configuration from.
        :returns: The configuration of the node as a JSON string.


    .. cpp:function:: System::String Handle::NodeTopology(System::Net::IPEndPoint host)
        
        Obtains a node topology as a JSON string.
        
        :param: host: The remote node to get the configuration from.
        :returns: The topology of the node as a JSON string.


    .. cpp:function:: void Handle::StopNode(System::Net::IPEndPoint host, System::String reason)
        
        Stops the node designated by its host and port number. This stop is generally effective within a few seconds of being issued, enabling inflight calls to complete successfully.
        
        :param: host: The remote node to stop.
        :param: reason: A string detailing the reason for the stop that will appear in the remote node's log.

