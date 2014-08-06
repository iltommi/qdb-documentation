.NET
====

.. highlight:: csharp

Introduction
--------------

The quasardb .NET API builds on the C++ API and delivers convenience and flexibility with great performance. The logic is similar to that of the C++ API (see :doc:`cpp`).

DLL
---

All object definitions and functions are made available in the ``QdbNetApi.dll`` file. All classes and methods reside in the ``qdb`` namespace.

The library requires the Visual Studio 2012 Update 4 redist to function properly.

Exceptions
------------

The quasardb .NET API will collect and throw Exceptions when the :ref:`Handle.Close() <csharp_handle_close>` method is called, or the :ref:`Handle <csharp_handle>` object goes out of scope.

The handle object
-------------------

Use the Handle object to interact with the cluster. Note that simply having a Handle object does not connect you to a cluster; you need to call :ref:`Handle.Connect() <csharp_handle_connect>`. The following example shows creating a handle, connecting to a cluster, removing an entry, then handling errors::

    try
    {
        // Create a Handle.
        qdb.Handle h = new qdb.Handle();
        
        // Connect to the cluster.
        h.Connect(new System.Net.IPEndPoint(System.Net.IPAddress.Loopback, 2836));
        
        // Removes the entry "myalias" if it exists, errors otherwise
        h.Remove("myalias");
        
        // An explicit Close() is not mandatory but permits catching errors in the surrounding try-catch block.
        h.Close();
    }
    catch (qdb.Exception ex)
    {
        Console.WriteLine("There is something rotten in the kingdom of Denmark: {0}", ex.ToString());
    }


If the handle object goes out of scope, the connection will automatically be terminated and the handle will be garbage collected.

.. caution::
    Concurrent calls to the :ref:`Handle.Connect() <csharp_handle_connect>` method on the same handle object leads to undefined behaviour.

Adding and getting data to and from a cluster
---------------------------------------------

To put and get an entry, the C# way::
    
    try
    {
        // Adds the entry "myalias" with the System.Byte[] value in_data, with no expiration time.
        h.Put("myalias", in_data, 0);
    }
    catch (qdb.Exception ex)
    {
        Console.WriteLine("Putting entry 'myalias' failed: {0}", ex.ToString());
    }

    try
    {
        // Gets the entry "myalias", with no expiration time.
        byte[] out_data = h.Get("myalias", out_data);
    }
    catch (qdb.Exception ex)
    {
        Console.WriteLine("Getting entry 'myalias' failed: {0}", ex.ToString());
    }


Closing a connection
-----------------------

A connection can be explicitly closed and the handle released with the :ref:`Handle.Close() <csharp_handle_close>` method::

    h.Close();

Note that when the :ref:`Handle <csharp_handle>` object leaves scope, :ref:`Handle.Close() <csharp_handle_close>` is automatically called.


Expiry
-------

Expiry is set with :ref:`Handle.ExpiresAt() <csharp_handle_expires_at>` and :ref:`Handle.ExpiresFromNow() <csharp_handle_expires_from_now>`. It is obtained with :ref:`Handle.GetExpiryTime() <csharp_handle_get_expiry_time>`. Expiry time is always in seconds, either relative to epoch (January 1st, 1970 00:00 UTC) when using :ref:`Handle.ExpiresAt() <csharp_handle_expires_at>` or relative to the call time when using :ref:`Handle.ExpiresFromNow() <csharp_handle_expires_from_now>`.

.. danger::
    The behavior of :ref:`Handle.ExpiresFromNow() <csharp_handle_expires_from_now>` is undefined if the time zone or the clock of the client computer is improperly configured.

To set the expiry time of an entry to 1 minute, relative to the call time::

    try
    {
        // Sets the entry "myalias" to an expiry time of 60 seconds from the call time.
        h.ExpiresFromNow("myalias", TimeSpan(0, 1, 0));
    }
    catch (qdb.Exception ex)
    {
        Console.WriteLine("Setting expiry time for 'myalias' failed: {0}", ex.ToString());
    }

Set an absolute exipry::

    try
    {
        // Sets the entry "myalias" to never expire.
        h.ExpiresAt("myalias", System.DateTime(2020, 1, 1));
    }
    catch (qdb.Exception ex)
    {
        Console.WriteLine("Setting expiry time for 'myalias' failed: {0}", ex.ToString());
    }

If an expiry time is not set when the entry is made, entries do not expire. To obtain the expiry time of an existing entry::

    try
    {
        DateTime expiry;

        // Gets the expiry time for "myalias"
        if (!h.GetExpiryTime("myalias", expiry))
        {
            // no expiry
        }
        else
        {
            // expiry, datetime_of_myalias is updated
        }
    }
    catch (qdb.Exception ex)
    {
        Console.WriteLine("Getting expiry time for 'myalias' failed: {0}", ex.ToString());
    }


Prefix based search
---------------------

Prefix based search is a powerful tool that helps you lookup entries efficiently.

For example, if you want to find all entries whose aliases start with "record"::

    try
    {
        System.String[] results = h.PrefixGet("record");
    }
    catch (qdb.Exception ex)
    {
        Console.WriteLine("Getting prefixes for 'record' failed: {0}", ex.ToString());
    }

Batch operations
-------------------

Batch operations are used similarly as in C, except a method :ref:`Handle.RunBatch() <csharp_handle_run_batch>` is provided for convenience.

Reference
----------------

All classes and instance methods reside in the 'qdb' namespace.


.. _csharp_handle:
.. class:: Handle

    .. _csharp_handle_constructor:
    .. function:: Handle()

        Constructor. Creates a qdb.Handle object by which you can manipulate the cluster.

        :returns: A qdb.Handle object.


    .. _csharp_handle_close:
    .. function:: void Close()

        Terminates all connections and releases all client-side allocated resources.


    .. _csharp_handle_connected:
    .. function:: bool Connected()

        Tests if the current handle is properly connected to a quasardb cluster.

        :returns: true if the handle is properly connected to a cluster.


    .. _csharp_handle_set_timeout:
    .. function:: void SetTimeout(System.TimeSpan timeout)

        Sets the timeout for connections.

        :param timeout: The amount of time after which the connection should timeout.


    .. _csharp_handle_connect:
    .. function:: void Connect(System.Net.IPEndPoint host)

        Bind the client instance to a quasardb cluster and connect to the given node within the cluster.

        :param host: The remote host to connect to.


    .. _csharp_handle_multiconnect:
    .. function:: Exception[] Multiconnect(System.Net.IPEndPoint[] hosts)

        Bind the client instance to a quasardb cluster and connect to multiple nodes within the cluster. If the same node (address and port) is present several times in the input array, it will count as only one successful connection. All hosts must belong to the same quasardb cluster. Only one connection to a listed node has to succeed for the connection to the cluster to be successful.

        :param hosts: an array of remote hosts to connect to.
        :returns: an array, matching each provided endpoint, with an exception in case of error or null if no error occurred.


    .. _csharp_handle_put_noexpiry:
    .. function:: void Put(System.String alias, System.Byte[] buffer)

        Adds an entry to the quasardb server. If the entry already exists the function will fail.

        :param alias: The entry's alias to create.
        :param buffer: The entry's content to be added to the server.


    .. _csharp_handle_put:
    .. function:: void Put(System.String alias, System.Byte[] buffer, System.DateTime expiryTime)

        Adds an entry to the quasardb server. If the entry already exists the function will fail.

        :param alias: The entry's alias to create.
        :param buffer: The entry's content to be added to the server.
        :param expiryTime: The absolute expiry time of the entry.


    .. _csharp_handle_update_noexpiry:
    .. function:: void Update(System.String alias, System.Byte[] buffer)

        Updates an entry on the quasardb server. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.

        :param alias: The entry's alias to update.
        :param buffer: The entry's content to be updated to the server.


    .. _csharp_handle_update:
    .. function:: void Update(System.String alias, System.Byte[] buffer, System.DateTime expiryTime)

        Updates an entry on the quasardb server. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.

        :param alias: The entry's alias to update.
        :param buffer: The entry's content to be updated to the server.
        :param expiryTime: The absolute expiry time of the entry.


    .. _csharp_handle_get:
    .. function:: System.Byte[] Get(System.String alias)

        Retrieves an entry's content from the quasardb server. If the entry does not exist, the function will fail.

        :param alias: The entry's alias whose content is to be retrieved.
        :returns: The requested entry's content.


    .. _csharp_handle_get_remove:
    .. function:: System.Byte[] GetRemove(System.String alias)

        Atomically gets an entry from the quasardb server and removes it. If the entry does not exist, the function will fail.

        :param alias: The entry's alias whose content is to be retrieved.
        :returns: The requested entry's content.


    .. _csharp_handle_get_update_no_expiry:
    .. function:: System.Byte[] GetUpdate(System.String alias, System.Byte[] buffer)

        Atomically gets and updates (in this order) the entry on the quasardb server. If the entry does not exist, the function will fail.

        :param alias: The entry's alias to update.
        :param buffer: The entry's content to be updated to the server.
        :returns: The requested entry's content, before the update.


    .. _csharp_handle_get_update:
    .. function:: System.Byte[] GetUpdate(System.String alias, System.Byte[] buffer, System.DateTime expiryTime)

        Atomically gets and updates (in this order) the entry on the quasardb server. If the entry does not exist, the function will fail.

        :param alias: The entry's alias to update.
        :param buffer: The entry's content to be updated to the server.
        :param expiryTime: The absolute expiry time of the entry.
        :returns: The requested entry's content, before the update.


    .. _csharp_handle_compare_and_swap_noexpiry:
    .. function:: System.Byte[] CompareAndSwap(System.String alias, System.Byte[] newValue, System.Byte[] comparand)

        Atomically compares the entry with the comparand and updates it to newValue if, and only if, they match.

        :param alias: The entry's alias to update.
        :param newValue: The entry's content to be updated to the server in case of match.
        :param comparand: The entry's content to be compared to.
        :returns: The original content, before the update, if any.


    .. _csharp_handle_compare_and_swap:
    .. function:: System.Byte[] CompareAndSwap(System.String alias, System.Byte[] newValue, System.Byte[] comparand, System.DateTime expiryTime)

        Atomically compares the entry with the comparand and updates it to newValue if, and only if, they match.

        :param alias: The entry's alias to update.
        :param newValue: The entry's content to be updated to the server in case of match.
        :param comparand: The entry's content to be compared to.
        :param expiryTime: The absolute expiry time of the updated entry.
        :returns: The original content, before the update, if any.


    .. _csharp_handle_remove:
    .. function:: void Remove(System.String alias)

        Removes an entry from the quasardb server. If the entry does not exist, the function will fail.

        :param alias: The entry's alias to delete.


    .. _csharp_handle_remove_if:
    .. function:: bool RemoveIf(System.String alias, System.Byte[] comparand)

        Atomically compares the entry with the comparand and removes it if, and only if, they match.

        :param alias: The entry's alias to delete.
        :param comparand: The entry's content to be compared to.
        :returns: True if the entry was successfully removed, false otherwise.


    .. _csharp_handle_remove_all:
    .. function:: void RemoveAll()

        Removes all the entries on all the nodes of the quasardb cluster. The function returns when the command has been dispatched and executed on the whole cluster or an error occurred.


    .. _csharp_handle_run_batch:
    .. function:: qdb.BatchResult[] RunBatch(qdb.BatchRequest[] requests)

        Runs the provided operations in batch on the cluster. The operations are run in arbitrary order.

        :param requests: An array of operations to run on the cluster in batch.
        :returns: An array of results in the same order of the supplied operations.


    .. _csharp_handle_prefix_get:
    .. function:: System.String[] PrefixGet(System.String prefix)

        Searches the cluster for all entries whose aliases start with "prefix". The method will return an array of strings containing the aliases of matching entries.

        :param prefix: A string representing the search prefix.
        :returns: An array of strings containing the aliases of matching entries.


    .. _csharp_handle_expires_at:
    .. function:: void ExpiresAt(System.String alias, System.DateTime expiryTime)

        Sets the expiry time of an existing entry from the quasardb cluster. A value of null means the entry never expires.

        :param alias: A string representing the entry's alias for which the expiry must be set.
        :param expiryTime: The absolute time at which the entry expires.


    .. _csharp_handle_expires_from_now:
    .. function:: void ExpiresFromNow(System.String alias, System.TimeSpan expiryDelta)

        Sets the expiry time of an existing entry from the quasardb cluster, relative to the current time.

        :param alias: A string representing the entry's alias for which the expiry must be set.
        :param expiryDelta: Time, relative to the call time, after which the entry expires.


    .. _csharp_handle_get_expiry_time:
    .. function:: bool GetExpiryTime(System.String alias, out System.DateTime expiryTime)

        Retrieves the expiry time of an existing entry. A value of null means the entry never expires.

        :param alias: A string representing the entry's alias for which the expiry must be retrieved.
        :param expiryTime: An DateTime that will be updated with the entry expiry time, if any.
        :returns: True if there is an expiry, false otherwise.


    .. _csharp_handle_node_status:
    .. function:: System.String NodeStatus(System.Net.IPEndPoint host)

        Obtains a node status as a JSON string.

        :param host: The remote node to get the status from.
        :returns: The status of the node as a JSON string.


    .. _csharp_handle_node_config:
    .. function:: System.String NodeConfig(System.Net.IPEndPoint host)

        Obtains a node configuration as a JSON string.

        :param host: The remote node to get the configuration from.
        :returns: The configuration of the node as a JSON string.


    .. _csharp_handle_node_topology:
    .. function:: System.String NodeTopology(System.Net.IPEndPoint host)

        Obtains a node topology as a JSON string.

        :param host: The remote node to get the configuration from.
        :returns: The topology of the node as a JSON string.


    .. _csharp_handle_stop_node:
    .. function:: void StopNode(System.Net.IPEndPoint host, System.String reason)

        Stops the node designated by its host and port number. This stop is generally effective within a few seconds of being issued, enabling inflight calls to complete successfully.

        :param host: The remote node to stop.
        :param reason: A string detailing the reason for the stop that will appear in the remote node's log.
