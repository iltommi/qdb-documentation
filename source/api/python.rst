
Python
======

.. highlight:: python

**Python 2.5 or higher** is required.
The `wrpme` module includes two client implementation. 
The :py:class:`wrpme.Client` class uses the standard :py:mod:`pickle` module to serialize your objects to and from the `wrpme` hive.
If you want to directly put your data inside the hive using strings or binary buffers, you can use the :py:class:`wrpme.RawClient` class.
In this case, no transformation is done between the data you provide and the `wrpme` hive, which can improve performances.

Examples
--------

There is a simple sample using the :py:class:`wrpme.Client`.
A simple module providing save() and load() methods::
    
    import wrpme

    # Assuming we have a wrpme server running on dataserver.mydomain:3001
    # Note this will throw an exception at import time if the wrpme hive is not available.
    cl = wrpme.Client('dataserver.mydomain', 3001)

    # We want to silently create or update the object
    # depending on the existence of the id in the hive.
    def save(id, obj):
        try:
            cl.put(id, obj)
        except wrpme.AliasAlreadyExists:
            cl.update(id, obj)
    
    # We want to simply return None if the id is not found in the hive.
    def load(id):
        try:
            return cl.get(id)
        except wrpme.AliasNotFound:
            return None

This other example uses the :py:class:`wrpme.RawClient` for direct binary access.
This module use a wrpme hive as a document store, providing upload() and download() methods, 
without imposing limits to the file size::

    import uuid
    import wrpme

    # If the document is bigger than 10 MiB, we slice it
    SIZE_LIMIT = 10 * 1024 * 1024
    
    # Note given what we are doing here, the server should be configure with
    # a limiter-max-bytes of 1 GiB at least for proper caching
    cl = wrpme.RawClient('docserver.mydomain', 3002)

    # We expect a readable file-like object with size() and read(size) methods
    def upload(f):
        id = uuid.uuid4()
        
        # If we need to slice, suffix the entry id and 
        # push the slices count, then push the slices themselves. 
        # Note in this case we do not push the actual id we return
        # so we can distinguish sliced files from the others.
        if f.size() > SIZE_LIMIT:
            div = divmod(f.size(), SIZE_LIMIT)
            slices_count = div[0] + 1 if div[1] else div[0]

            # wrpme will ensure a good distribution
            # of the slices even if their names are close.
            cl.put(id.hex + '-slice_count', str(slices_count)
            for i in range(slices_count):
                cl.put(id.hex + str(i), f.read(SIZE_LIMIT))
        
        # else just put the file directly.
        else:
            cl.put(id.hex, f.read(SIZE_LIMIT))
            
        return id

    # We expect an UUID and a writable file-like object with write() method
    def download(id, f):
        # We optimze for little files, 
        # try to fetch them directly with no overhead
        try:
            f.write(cl.get(id.hex))
        
        # If this fails, maybe we have slices
        except wrpme.AliasNotFound:
            slices_count = int(cl.get(id.hex + '-slice_count'))
            for i in range(slices_count):
                f.write(cl.get(id.hex) + str(i))

Reference
---------

.. py:module:: wrpme

.. py:data:: error_ok

    Indicates that the function returned successfully.

.. py:data:: error_system 

    A system error occured.

.. py:data:: error_internal 

    An internal error occured.

.. py:data:: error_no_memory 

    Out of memory condition.

.. py:data:: error_invalid_protocol 

    The requested protocol is invalid.

.. py:data:: error_host_not_found 

    The host name could not be resolved.

.. py:data:: error_invalid_option

    The supplied option is invalid.

.. py:data:: error_alias_too_long

    The alias name is too long.

.. py:data:: error_alias_not_found 

    The entry does not exist.

.. py:data:: error_alias_already_exists 

    The entry already exists.

.. py:data:: error_timeout 

    The operation timed out.

.. py:data:: error_buffer_too_small 

    The provided buffer is too small.

.. py:data:: error_invalid_command 

    The requested command is invalid.

.. py:data:: error_invalid_input

    The input is invalid.

.. py:data:: error_connection_refused

    The connection has been refused by the remote host.

.. py:data:: error_connection_reset

    The connection has been reset.

.. py:data:: error_unexpected_reply

    An unexpected reply has been received.

.. py:function:: open

    Creates a client instance. The :py:func:`close` will be automatically called when the session is no longer used.

    :return: A wrpme session.

.. py:function:: close(handle)

    Terminates all connections and releases all client-side allocated resources.
    
    :param handle: An initialized handle (see :py:func:`open`)

.. py:function:: connect(handle, address, port)

    Binds the client instance to a wrpme :term:`server` and connects to it.

    :param handle: An initialized handle (see :py:func:`open`)
    :param host: A string representing the IP address or the name of the server to which to connect
    :param port: The port number used by the server. The default wrpme port is 5909.

    :return: An error code 

.. py:function:: get(handle, alias)

    Retrieves an :term:`entry`'s content from the wrpme server. 
    
    If the entry does not exist, the function will fail and return :py:data:`error_alias_not_found`.

    The handle must be initialized (see :py:func:`open`) and the connection established (see :py:func:`connect`).

    :param handle: An initialized handle (see :py:func:`open`)
    :param alias: A string representing the entry's alias whose content is to be retrived
    
    :return: A :term:`pair` (error code, string). If the operation is successful, the right element will be the content as a string object.

.. py:function:: put(handle, alias, content)

    Adds an :term:`entry` to the wrpme server. If the entry already exists the function will fail and will return :py:data:`error_alias_already_exists`.

    The handle must be initialized (see :py:func:`open`) and the connection established (see :py:func:`connect`).

    :param handle: An initialized handle (see :py:func:`open`)
    :param alias: A string representing the entry's alias whose content is to be retrived
    :param content: A string that represents the entry's content to be added to the server.
    
    :return: An error code 

.. py:function:: update(handle, alias, content)

    Updates an :term:`entry` of the wrpme server. If the entry already exists, the content will be update. If the entry does not exist, it will be created.

     The handle must be initialized (see :py:func:`open`) and the connection established (see :py:func:`connect`).

    :param handle: An initialized handle (see :py:func:`open`)
    :param alias: A string representing the entry's alias whose content is to be retrived
    :param content: A string that represents the entry's content to be added to the server.
    
    :return: An error code 

.. py:function:: delete(handle, alias)
    
    Removes an :term:`entry` from the wrpme server. If the entry does not exist, the function will fail and return `:py:data:`error_alias_not_found`.
    
    The handle must be initialized (see :py:func:`open`) and the connection established (see :py:func:`connect`).

    :param handle: An initialized handle (see :py:func:`open`)
    :param alias: A string representing the entry's alias whose content is to be deleted.
    
    :return: An error code 

