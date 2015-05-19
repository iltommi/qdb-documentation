Python
======

.. highlight:: python

Introduction
--------------

The `qdb` module includes two client implementations.

The :py:class:`qdb.Client` class uses the standard :py:mod:`pickle` module to serialize your objects to and from the `quasardb` cluster.

If you want to manipulate your data directly using strings or binary buffers, you should use the :py:class:`qdb.RawClient` class. This class does not perform any transformation on the data and will store it "as is" on the `quasardb` cluster. This may improve performance but most of all enables you to have a cross-language data approach.

The API is BSD licensed.

You may download the Python API from the quasardb site or from GitHub at `https://github.com/bureau14/qdb-api-python <https://github.com/bureau14/qdb-api-python>`_.

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

You need to download the version matching your Python architecture, not the OS. For example, you may have installed Python 2.7 32-bit on a Windows 64-bit
platform, in which case you must get the Python 32-bit quasardb package.

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
    su
    python setup.py install
    exit

GCC 4.6.0 or later is required to build the extension. You can specify the compiler with the following command::

    setenv CC gcc46
    python setup.py build

Provided that g++46 is the name of your GCC 4.6 compiler.

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

    >>> c = qdb.Client("qdb://127.0.0.1:2836"))
    >>> c.put("entry", "content")
    >>> print c.get("entry")
    content
    >>>

Expiry
------

Expiry is either set at creation or through the :py:func:`qdb.Client.expires_at` and :py:func:`qdb.Client.expires_from_now` methods.

.. danger::
    The behavior of :py:func:`qdb.Client.expires_from_now` is undefined if the time zone or the clock of the client computer is improperly configured.

To set the expiry time of an entry to 1 minute, relative to the call time::

    c = qdb.Client("qdb://127.0.0.1:2836")
    c.put("entry", "content")
    c.expires_from_now("entry", 60)

To set the expiry time of an entry to January, 1st 2020::

    c.put("entry", "content")
    c.expires_at("entry", datetime.datetime(year=2020, month=1, day=1))

Or alternatively::

    c.put("entry", "content", datetime.datetime(year=2020, month=1, day=1))

To prevent an entry from ever expiring::

    c.expires_at("entry", None);

By default, entries never expire. To obtain the expiry time of an existing entry as a :py:class:`datetime.datetime` object::

    expiry = c.get_expiry_time("entry")

Prefix based search
---------------------

Prefix based search is a powerful tool that helps you lookup entries efficiently.

For example, if you want to find all entries whose aliases start with "record"::

    c = qdb.Client("qdb://127.0.0.1:2836")
    res = c.prefix_get("record")

The method returns an array of strings matching the provided prefix.

Iteration
---------

Iteration is supported in a pythonesque way::

    c = qdb.Client("qdb://127.0.0.1:2836")
    for e in c:
        print e

Each entry will be automatically *pickled* as you iterate. It is currently not possible to specify the range of iteration: you can only iterate on all entries.

Batch operations
----------------

A batch is run by providing the run_batch method with an array of :py:class:`qdb.BatchRequest`::

    requests = [ qdb.BatchRequest(qdb.Operations.get_alloc, "my_entry1"), qdb.BatchRequest(qdb.Operations.get_alloc, "my_entry2") ]

    c = qdb.Client("qdb://127.0.0.1:2836")
    successes, results = c.run_batch(requests)

The run_batch method returns a couple. The left member is the number of successful operations and the right member is an array of :py:class:`qdb.BatchResult`. For example to get the content for the first entry::

    mycontent1 = results[0].result

The error member of each :py:class:`qdb.BatchResult` is updated to reflect the success of the operation. If the success count returned by run_batch isn't equal to the number of requests, the error field of each entry can be inspected to isolate the faulty requests.

All batchable operations are supported in Python, namely:  get, put, update, remove, compare and swap (cas), get and update, get and remove and conditional remove (remove_if).

Examples
--------

Is here a first sample using the :py:class:`qdb.Client`. This module provides save() and load() methods:

.. literalinclude:: example_client.py

The second example uses the :py:class:`qdb.RawClient` for direct binary access. This module uses a quasardb cluster as a document store, providing upload() and download() methods, without any file size limit:

.. literalinclude:: example_raw_client.py

Reference
---------

.. automodule:: qdb
    :members:
    :show-inheritance:

