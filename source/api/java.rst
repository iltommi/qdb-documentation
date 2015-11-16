Java
====


.. highlight:: java

Introduction
------------

The quasardb Java API uses JNI to bring the power and speed of quasardb to the Java world without compromising performance.

You can access your cluster using either the high level Java classes or the low level JNI API. In almost all cases you should use the high level classes.

You may download the Java package from the quasardb download site or build it from the sourcecode `https://github.com/bureau14/qdb-api-java <https://github.com/bureau14/qdb-api-java>`_.  All information regarding the quasardb download site is in your welcome e-mail.

The .jar package is qdb-java-api-<os>-<version>.jar and contains both the base Java classes and support for the JNI interface. The classes reside in the ``net.quasardb.qdb`` package.


Requirements
------------

One of the following Java Development Kits:

    * Oracle Java JDK SE 1.6
    * Oracle Java JDK EE 1.6
    * Oracle Java JDK SE 1.7
    * Oracle Java JDK EE 1.7
    * OpenJDK 6
    * OpenJDK 7u

Run the Example
------------------

The Java API example can be downloaded from `https://github.com/bureau14/qdb-api-java/tree/master/example <https://github.com/bureau14/qdb-api-java/tree/master/example>`_.

  1. Compile the example with ``javac``. Assuming ``quasardb-java-<os>-<version>.jar`` is in ``/tmp``::

      javac -classpath /tmp/quasardb-java-<os>-<version>.jar QuasardbExample.java

  2. Run the example::

      java -classpath /tmp/quasardb-java-<os>-<version>.jar:. QuasardbExample

The example requires a quasardb server listening on ``127.0.0.1`` (IPV4 localhost) port 2836. Should you wish to run the example on a different server, you need but to edit it! See :doc:`../reference/qdbd` to configure a quasardb cluster.

Using the high-level API
------------------------

The high-level API is recommended because:

  * It is object oriented
  * It loads native libraries no matter which OS you are running (FreeBSD, Linux, Win32 or Win64).
  * It is thread-safe, unlike the low-level API.


Configuring the quasardb instance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To connect to a quasardb cluster, create a new Qdbcluster object. Pass in the IP address and port of an online node in the qdb:// string format::

    cluster = new QdbCluster("qdb://127.0.0.1:2836");

If the cluster object is not null, your quasardb instance is ready to use.

Using the quasardb instance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Entries in the cluster are stored and retrieved by their aliases, in the form of Strings. Their content is stored and retrieved as a `ByteBuffer <http://docs.oracle.com/javase/7/docs/api/java/nio/ByteBuffer.html>`_. See :ref:`java-memory-management`.

For example, to get an existing Blob named "obj1" or create it if the entry does not exist::

    String content = "Content";
    cluster.getBlob("obj1").put(ByteBuffer.allocateDirect(content.getBytes().length).put(content.getBytes()));

To get the value of an object, get and convert the ByteBuffer::

    ByteBuffer buffer = cluster.getBlob("obj1").get();
    byte[] bytes = new byte[buffer.limit()];
    buffer.get(bytes, 0, buffer.limit());
    String value = new String(bytes);
    
To remove an entry::

    cluster.getBlob("obj1").remove();

Quasardb also supports other object types than Blobs, including Double-Ended Queues, Hash Sets, and Integers. These have get/put/update methods on the cluster object as well as their own convenience methods.

.. _java-memory-management:

Memory management
^^^^^^^^^^^^^^^^^^

The API uses a logic very close to the QuasarDB C API (Feel free to review the C API documentation for useful background information, see :doc:`c`).

In particular, to avoid pressuring the garbage collector, and to minimize useless copies, entries' content are wrapped in `ByteBuffer <http://docs.oracle.com/javase/7/docs/api/java/nio/ByteBuffer.html>`_ objects instead of byte arrays or `String <http://docs.oracle.com/javase/7/docs/api/java/lang/String.html>`_ objects.

Aliases, on the other hand, use regular String objects for convenience.

The ByteBuffer must be initialized with `allocateDirect <http://docs.oracle.com/javase/7/docs/api/java/nio/ByteBuffer.html#allocateDirect%28int%29>`_ so that the JNI may access the memory. The buffer *must* be large enough to hold all the content, otherwise the call will fail.

When adding entries, this is generally not an issue as the caller knows the size of the content it will add, however when retrieving entries this may be more problematic. Either the caller can allocate more data than required or it can use the ByteBuffer limit() to obtain the size of an entry.

Reference
---------

* `Javadoc website <https://doc.quasardb.net/java/>`_
