Python
======

.. default-domain:: py
.. highlight:: python

.. testsetup:: *

    import datetime
    import quasardb

Introduction
--------------

The `quasardb` module contains multiple classes to make working with a quasardb cluster simple. Data is stored "as is" bit for bit, that is, strings are treated as binary data. 

The Python API is BSD licensed. You may download it from the quasardb site or from GitHub at `<https://github.com/bureau14/qdb-api-python>`_.

Requirements
------------------------

Python 2.6 or higher is required.

Installation
------------

As the Python API relies on our quasardb C API to function, you need to download the package that matches your operating system. For example, you cannot
download the FreeBSD version and compile it on Linux.

All required libraries and extensions are included in the Python package.


Installing the Package
``````````````````````

Windows users can download the installer from the download site. The installers work with Python 2.7 on Windows 32-bit and 64-bit. You need to download the version matching your Python architecture, not the OS. For example, you may have installed Python 2.7 32-bit on a Windows 64-bit platform, in which case you must get the Python 32-bit quasardb package.

Compiling From Source
`````````````````````

If you have a different Python version or you want to recompile the extension, download the source package. To compile the source package, you need the quasardb C library, `CMake <https://cmake.org/>`_, `SWIG <http://www.swig.org/>`_, and the Python :mod:`distutils` installed.

Unpack the archive and in the directory run:

.. code-block:: shell

    mkdir build
    cd build
    cmake -G "<generator>" ..
    make

The generator options for your platform can be shown by running `cmake` with no options.


Testing the installation
````````````````````````

Once the installation is complete, you must be able to import quasardb without any error message::

    Python 2.7.2 (default, Dec  5 2011, 15:17:56)
    [GCC 4.2.1 20070831 patched [FreeBSD]] on freebsd9
    Type "help", "copyright", "credits" or "license" for more information.

.. testcode:: package

    import quasardb

.. attention::
    If you built the extension from the sources, do not run the above command from the sources directory as it will attempt to load the local source code instead of the properly configured extension.

If you have a server up and running, you must be able to add and access entries:

.. testcode:: quasardb

    c = quasardb.Cluster("quasardb://127.0.0.1:2836", datetime.timedelta(minutes=1))
    b = c.blob("entry")
    b.put("content")
    print b.get()

The execution of the above code snippet will output:

.. testoutput:: quasardb

    content

Expiry
------

Expiry is either set at creation or through the `expires_at` and `expires_from_now` methods for the given data type.

.. danger::
    The behavior of `expires_from_now` is undefined if the time zone or the clock of the client computer is improperly configured.

To set the expiry time of an entry to 1 minute, relative to the call time:

.. testcode:: quasardb

    b.expires_from_now(60)

To set the expiry time of an entry to January, 1st 2020:

.. testcode:: quasardb

    b.expires_at(datetime.datetime(year=2020, month=1, day=1))

Or alternatively:

.. testcode:: quasardb

    b.update("content", datetime.datetime(year=2020, month=1, day=1))

To prevent an entry from ever expiring:

.. testcode:: quasardb

    b.expires_at(None);

By default, entries never expire. To obtain the expiry time of an existing entry as a :class:`datetime.datetime` object:

.. doctest:: quasardb
    :hide:

    >>> b.expires_at(datetime.datetime(year=2020, month=1, day=1))

.. testcode:: quasardb

    expiry = b.get_expiry_time()
    print expiry.strftime("%Y-%m-%d")

This will print:

.. testoutput:: quasardb

    2020-01-01

Tags
----

To get the list of tags for an entry, use the `get_tags` method.

.. testcode:: quasardb

    tags = b.get_tags()

To find the list of items matching a tag, you create a tag object. For example, if you want to find all entries having the tag "my_tag". The `get_entries` method will then list the entries matching the tag.

.. testcode:: quasardb

    c = quasardb.Cluster("quasardb://127.0.0.1:2836", datetime.timedelta(minutes=2))
    tag = c.tag("my_tag")
    entries = tag.get_entries()

Example Client
--------------

This module creates a simple save() and load() wrapper around the API:

.. literalinclude:: example_client.py


Reference
---------

.. automodule:: quasardb
    :members:
    :inherited-members:
    :show-inheritance:

