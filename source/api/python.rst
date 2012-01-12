
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
A simple module providing save() and load() methods:

.. literalinclude:: example_client.py

This other example uses the :py:class:`wrpme.RawClient` for direct binary access.
This module use a wrpme hive as a document store, providing upload() and download() methods, without imposing limits to the file size:

.. literalinclude:: example_raw_client.py

Reference
---------

.. py:module:: wrpme

.. py:class:: Client(hostname, port)

    The classic interface to a wrpme hive.
    It connects to the given hostname at instanciation, disconnects automatically at destruction.
    The connection is dropped and restarted at need depending of the use frequency.
    The client serializes the keys and the data using the standard :py:mod:`pickle` module.

    :param string hostname: either the DNS name, the IPv4 address or the IPv6 address.
    :param integer port: the port, defaults to 5909.

    .. py:method:: put(key, obj)

        Put an object in the wrpme hive.

        :param key: any unique item used to identify the object
        :type key: any picklable object
        :param obj: the object to be put in the hive.
        :type obj: any picklable object
        :raise: :py:exc:`wrpme.AliasAlreadyExists` if the **key** already exists in the hive.
        :raise: :py:exc:`pickle.PicklingError` if either the **key** or the **obj** can not be pickled.

    .. py:method:: update(key, obj)

        Update an object in the wrpme hive.

        :param key: any unique item used to identify the object.
        :type key: any picklable object
        :param obj: the new object to be put in the hive, replacing the old value.
        :type obj: any picklable object
        :raise: :py:exc:`wrpme.AliasNotFound` if the **key** does not exist in the hive.
        :raise: :py:exc:`pickle.PicklingError` if either the **key** or the **obj** can not be pickled.

    .. py:method:: get(key)

        Retrieve an object from the wrpme hive.

        :param key: the unique item used to identify the object.
        :type key: any picklable object
        :return: the unpickled object matching the **key**
        :raise: :py:exc:`wrpme.AliasNotFound` if the **key** does not exist in the hive.
        :raise: :py:exc:`pickle.PicklingError` if either the **key** can not be pickled.

    .. py:method:: remove(key)

        Remove an object from the wrpme hive.

        :param key: the unique item used to identify the object.
        :type key: any picklable object
        :raise: :py:exc:`wrpme.AliasNotFound` if the **key** does not exist in the hive.
        :raise: :py:exc:`pickle.PicklingError` if either the **key** can not be pickled.

.. py:class:: RawClient(hostname, port)
        
    The raw interface to a wrpme hive.
    It has the same methods as the :py:class:`wrpme.Client`, except all **key** and **obj** parameters must be strings.

    :param string hostname: string giving the hostname. Either the DNS name, the IPv4 address or the IPv6 address.
    :param integer port: port, defaults to 5909.

    .. py:method:: put(key, obj)

        Put a string in the wrpme hive.

        :param string key: any unique string used to identify the string
        :param string obj: the string to be put in the hive.
        :raise: :py:exc:`wrpme.AliasAlreadyExists` if the **key** already exists in the hive.

    .. py:method:: update(key, obj)

        Update a string in the wrpme hive.

        :param string key: any unique string used to identify the string.
        :param string obj: the new string to be put in the hive, replacing the old value.
        :raise: :py:exc:`wrpme.AliasNotFound` if the **key** does not exist in the hive.

    .. py:method:: get(key)

        Retrieve a string from the wrpme hive.

        :param string key: the unique string used to identify the string.
        :return: the string matching the **key**
        :raise: :py:exc:`wrpme.AliasNotFound` if the **key** does not exist in the hive.

    .. py:method:: remove(key)

        Remove a string from the wrpme hive.

        :param string key: the unique string used to identify the string.
        :raise: :py:exc:`wrpme.AliasNotFound` if the **key** does not exist in the hive.

.. py:exception:: WrpmeException

    Base exception for the wrpme module.

.. py:exception:: System 

    A system error occured. 
    Can typically be raised if the number of entries on each node is too large.

.. py:exception:: Internal 

    An internal error occured in wrpme. Please report it to the wrpme support teams.

.. py:exception:: NoMemory 

    Out of memory condition. You can try to set a lower limiter-max-bytes to avoid this.

.. py:exception:: HostNotFound 

    The host name could not be resolved.

.. py:exception:: AliasNotFound 

    The entry does not exist. Raised when you try to get() an id and wrpme does not find it.

.. py:exception:: AliasAlreadyExists 

    The entry already exists. Raised when you try to put() data on an id wrpme already has in its repository.

.. py:exception:: Timeout 

    The operation timed out. Can be raised in case of network overload or server failure.

.. py:exception:: InvalidInput
    
    The key or the obj is invalide. Raised when the key or the obj is empty.

.. py:exception:: ConnectionRefused

    The connection has been refused by the remote host.

.. py:exception:: ConnectionReset

    The connection has been reset.
