Python
======

.. highlight:: python

Introduction
--------------

The `qdb` module contains multiple classes to make working with a quasardb cluster simple. It uses the standard :py:mod:`pickle` module to serialize your objects to and from the `quasardb` cluster.

The Python API is BSD licensed. You may download it from the quasardb site or from GitHub at `https://github.com/bureau14/qdb-api-python <https://github.com/bureau14/qdb-api-python>`_.

Requirements
------------------------

Python 2.6 or higher is required.

Installation
------------

As the Python API relies on our quasardb C API to function, you need to download the package that matches your operating system. For example, you cannot
download the FreeBSD version and compile it on Linux.

All required libraries and extensions are included in the Python package.

Windows
```````

Installers for Python 2.7 on Windows 32-bit and 64-bit are available. You just need to download the installer and follow the on-screen instructions.

You need to download the version matching your Python architecture, not the OS. For example, you may have installed Python 2.7 32-bit on a Windows 64-bit platform, in which case you must get the Python 32-bit quasardb package.

If you have a different Python version or if you want to recompile the extension, download the source package.

To compile it, you need the appropriate Visual Studio version (e.g. Visual Studio 2008 for Python 2.7). Unpack the archive and in the directory run::

    python setup.py build
    python setup.py install

The install phase may require administrative privileges.

Linux and FreeBSD
`````````````````

Download the source package for your operating system (Linux or FreeBSD) and make sure you have both a C compiler and the Python development headers installed.

Unpack the archive and in the directory run::

    python setup.py build
    sudo python setup.py install

or::

    python setup.py build
    sudo python setup.py install

GCC 4.6.0 or later is required to build the extension. You can specify the compiler with the following command::

    setenv CC gcc46
    python setup.py build

Provided that gcc46 is the name of your GCC 4.6 compiler.

It is also possible - and even recommended on FreeBSD - to build the extension with clang::

    setenv CC clang
    python setup.py build

Testing the installation
````````````````````````

Once the installation is complete, you must be able to import quasardb without any error message::

    Python 2.7.2 (default, Dec  5 2011, 15:17:56)
    [GCC 4.2.1 20070831 patched [FreeBSD]] on freebsd9
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import qdb
    >>>

.. attention::
    If you built the extension from the sources, do not run the above command from the sources directory as it will attempt to load the local source code instead of the properly configured extension.

If you have a server up and running, you must be able to add and access entries::

    >>> c = qdb.Cluster("qdb://127.0.0.1:2836"))
    >>> b = c.blob("entry")
    >>> b.put("content")
    >>> print b.get()
    content
    >>>

Expiry
------

Expiry is either set at creation or through the `expires_at` and `expires_from_now` methods for the given data type.

.. danger::
    The behavior of `expires_from_now` is undefined if the time zone or the clock of the client computer is improperly configured.

To set the expiry time of an entry to 1 minute, relative to the call time::

    c = qdb.Cluster("qdb://127.0.0.1:2836")
    b = c.blob("entry")
    b.put("content")
    b.expires_from_now(60)

To set the expiry time of an entry to January, 1st 2020::

    b.put("content")
    b.expires_at(datetime.datetime(year=2020, month=1, day=1))

Or alternatively::

    b.put("content", datetime.datetime(year=2020, month=1, day=1))

To prevent an entry from ever expiring::

    b.expires_at(None);

By default, entries never expire. To obtain the expiry time of an existing entry as a :py:class:`datetime.datetime` object::

    expiry = b.get_expiry_time("entry")

Example Client
--------------

This module creates a simple save() and load() wrapper around the API:

.. literalinclude:: example_client.py


Reference
---------

.. automodule:: qdb
    :members:
    :inherited-members:
    :show-inheritance:

