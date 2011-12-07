
Python
===============

.. highlight:: python

Requirements
------------------------

Python 2.4 or higher is required.

Reference
-----------------------

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

