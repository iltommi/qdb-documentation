Python
======

.. highlight:: python

Introduction
--------------

The `qdb` module includes two client implementations.

The :py:class:`qdb.Client` class uses the standard :py:mod:`pickle` module to serialize your objects to and from the `quasardb` cluster.

If you want to manipulate your data directly using strings or binary buffers, you should rather use the :py:class:`qdb.RawClient` class. This class does not perform any transformation on the data and will store it "as is" on the `quasardb` cluster. This may improve performance but most of all enables you to work with the data with different languages.

The API comes with a BSD license and can be freely used in your clients.

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

Installers for Python 2.7 on Windows 32-bit and 64-bit are available. You just need to download the installerand follow the on-screen instructions.

Keep in mind that you need to download the version matching your Python architecture, not the OS.
For example, you may have installed Python 2.7 32-bit on a Windows 64-bit platform, in which case you must get the Python 32-bit qdb package.

If you have a different Python version or if you want to recompile the extension, download the source package.

To compile it, you need the appropriate Visual Studio version (e.g. Visual Studio 2008 for Python 2.7). Unpack the archive and in the directory run::

    python setup.py build
    python setup.py install

Keep in mind the install phase may require administrative privileges.

Linux and FreeBSD
`````````````````

`Download the package <http://www.qdb.net/downloads.html>`_ for your operating system (Linux or FreeBSD) and make sure you have both a C compiler and the Python development headers installed.

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
    >>> import qdb
    >>>

.. attention::
    If you built the extension from the sources, do not run the above command from the sources directory as it will attempt to load the local source code instead of the properly configured extension.

If you have a server up and running, you must be able to add and access entries::

    >>> w = qdb.Client("127.0.0.1")
    >>> w.put("entry", "content")
    >>> print w.get("entry")
    content
    >>>

Examples
--------

Is here a first sample using the :py:class:`qdb.Client`. This module provides save() and load() methods:

.. literalinclude:: example_client.py

The second example uses the :py:class:`qdb.RawClient` for direct binary access. This module uses a quasardb cluster as a document store, providing upload() and download() methods, with not limit on the file size:

.. literalinclude:: example_raw_client.py

Reference
---------

.. automodule:: qdb
    :members:
    :show-inheritance:

