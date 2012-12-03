Python
======

.. highlight:: python

Introduction
--------------

The `quasardb` module includes two client implementations.

The :py:class:`quasardb.Client` class uses the standard :py:mod:`pickle` module to serialize your objects to and from the `quasardb` hive.

If you want to manipulate your data directly using strings or binary buffers, you should rather use the :py:class:`quasardb.RawClient` class. This class does not perform any transformation on the data and will store it "as is" on the `quasardb` hive. This may improve performance but most of all enables you to work with the data with different languages.

The API comes with a BSD license and can be freely used in your clients.

Requirements
------------------------

Python 2.5 or higher is required.

Installation
------------

As the Python API relies on our quasardb C API to function, you need to download the package that matches your operating system. For example, you cannot
download the FreeBSD version and compile it on Linux.

All required libraries and extensions are included in the Python package.

Windows
```````

Installers for Python 2.7 on Windows 32-bit and 64-bit are available. You just need to `download the installer <http://www.quasardb.com/downloads.html>`_ and follow the on-screen instructions.

Keep in mind that you need to download the version matching your Python architecture, not the OS.
For example, you may have installed Python 2.7 32-bit on a Windows 64-bit platform, in which case you must get the Python 32-bit quasardb package.

If you have a different Python version or if you want to recompile the extension, `download the source package <http://www.quasardb.com/downloads.html>`_.

To compile it, you need the appropriate Visual Studio version (e.g. Visual Studio 2008 for Python 2.7). Unpack the archive and in the directory run::

    python setup.py build
    python setup.py install

Keep in mind the install phase may require administrative privileges.

Linux and FreeBSD
`````````````````

`Download the package <http://www.quasardb.com/downloads.html>`_ for your operating system (Linux or FreeBSD) and make sure you have both a C compiler and the Python development headers installed.

Unpack the archive and in the directory run::

    python setup.py build
    sudo python setup.py install

or::

    python setup.py build
    su
    python setup.py install
    exit

Testing the installation
````````````````````````

Once the installation is complete, you must be able to import quasardb without any error message::

    Python 2.7.2 (default, Dec  5 2011, 15:17:56)
    [GCC 4.2.1 20070831 patched [FreeBSD]] on freebsd9
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import quasardb
    >>>

.. attention::
    If you built the extension from the sources, do not run the above command from the sources directory as it will attempt to load the local source code instead of the properly configured extension.

If you have a server up and running, you must be able to add and access entries::

    >>> w = quasardb.Client("127.0.0.1")
    >>> w.put("entry", "content")
    >>> print w.get("entry")
    content
    >>>

Examples
--------

Is here a first sample using the :py:class:`quasardb.Client`. This module provides save() and load() methods:

.. literalinclude:: example_client.py

The second example uses the :py:class:`quasardb.RawClient` for direct binary access. This module uses a quasardb hive as a document store, providing upload() and download() methods, with not limit on the file size:

.. literalinclude:: example_raw_client.py

Reference
---------

.. py:module:: quasardb

.. py:class:: Client(hostname, port)

    The classic interface to a quasardb hive.
    It connects to the given hostname at instanciation, disconnects automatically at destruction.
    The connection is dropped and restarted as needed depending on usage.
    The client serializes the keys and the data using the standard :py:mod:`pickle` module.

    :param string hostname: either the DNS name, the IPv4 address or the IPv6 address.
    :param integer port: the port, defaults to 2836.

    .. py:method:: put(key, obj)

        Put an object in the quasardb hive. Raises if the object already exists.

        :param key: any unique item used to identify the object
        :type key: any picklable object
        :param obj: the object to be put in the hive.
        :type obj: any picklable object
        :raise: :py:exc:`quasardb.AliasAlreadyExists` if the **key** already exists in the hive.
        :raise: :py:exc:`pickle.PicklingError` if either the **key** or the **obj** can not be pickled.

    .. py:method:: update(key, obj)

        Update an object in the quasardb hive.
        Create the record if it does not exist at given key.

        :param key: any unique item used to identify the object.
        :type key: any picklable object
        :param obj: the new object to be put in the hive, replacing the old value.
        :type obj: any picklable object
        :raise: :py:exc:`pickle.PicklingError` if either the **key** or the **obj** can not be pickled.

    .. py:method:: get(key)

        Retrieve an object from the quasardb hive.

        :param key: the unique item used to identify the object.
        :type key: any picklable object
        :return: the unpickled object matching the **key**
        :raise: :py:exc:`quasardb.AliasNotFound` if the **key** does not exist in the hive.
        :raise: :py:exc:`pickle.PicklingError` if either the **key** can not be pickled.

    .. py:method:: remove(key)

        Remove an object from the quasardb hive.

        :param key: the unique item used to identify the object.
        :type key: any picklable object
        :raise: :py:exc:`quasardb.AliasNotFound` if the **key** does not exist in the hive.
        :raise: :py:exc:`pickle.PicklingError` if either the **key** can not be pickled.

.. py:class:: RawClient(hostname, port)

    The raw interface to a quasardb hive.
    It has the same methods as the :py:class:`quasardb.Client`, except all **key** and **obj** parameters must be strings.

    :param string hostname: string giving the hostname. Either the DNS name, the IPv4 address or the IPv6 address.
    :param integer port: port, defaults to 2836.

    .. py:method:: put(key, obj)

        Put a string in the quasardb hive.

        :param string key: any unique string used to identify the string
        :param string obj: the string to be put in the hive.
        :raise: :py:exc:`quasardb.AliasAlreadyExists` if the **key** already exists in the hive.

    .. py:method:: update(key, obj)

        Update a string in the quasardb hive.
        Create the record if it does not already exist at given key.

        :param string key: any unique string used to identify the string.
        :param string obj: the new string to be put in the hive, replacing the old value.
        :raise: :py:exc:`quasardb.AliasNotFound` if the **key** does not exist in the hive.

    .. py:method:: get(key)

        Retrieve a string from the quasardb hive.

        :param string key: the unique string used to identify the string.
        :return: the string matching the **key**
        :raise: :py:exc:`quasardb.AliasNotFound` if the **key** does not exist in the hive.

    .. py:method:: remove(key)

        Remove a string from the quasardb hive.

        :param string key: the unique string used to identify the string.
        :raise: :py:exc:`quasardb.AliasNotFound` if the **key** does not exist in the hive.

.. py:exception:: quasardbException

    Base exception for the quasardb module.

.. py:exception:: System

    A system error occurred.
    Can typically be raised if the number of entries on each node is too large.

.. py:exception:: Internal

    An internal error occured in quasardb. Please report it to the quasardb support teams.

.. py:exception:: NoMemory

    Out of memory condition. You can try to set a lower limiter-max-bytes to avoid this.

.. py:exception:: HostNotFound

    The host name could not be resolved.

.. py:exception:: AliasNotFound

    The entry does not exist. Raised when you try to get() an id and quasardb does not find it.

.. py:exception:: AliasAlreadyExists

    The entry already exists. Raised when you try to put() data on an id quasardb already has in its repository.

.. py:exception:: Timeout

    The operation timed out. Can be raised in case of network overload or server failure.

.. py:exception:: InvalidInput

    The key or the obj is invalide. Raised when the key or the obj is empty.

.. py:exception:: ConnectionRefused

    The connection has been refused by the remote host.

.. py:exception:: ConnectionReset

    The connection has been reset.
