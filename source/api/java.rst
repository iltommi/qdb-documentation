Java
====


.. highlight:: java

Introduction
------------

The quasardb Java API uses JNI to bring the power and speed of quasardb to the Java world without compromising performances.

It fully integrates itself into the Java environment thanks to a wrapper (also called 'high-level API'). The wrapper itself comes with a BSD license and can be freely used in your clients. The wrapper uses a low-level API that is also directly useable although with severe restrictions.

Requirements
------------

One of the following Java Development Kits:

    * Oracle Java JDK SE 1.6
    * Oracle Java JDK EE 1.6
    * Oracle Java JDK SE 1.7
    * Oracle Java JDK EE 1.7
    * OpenJDK 6
    * OpenJDK 7u


Installation
------------

The Java API package is downloadable from the Bureau 14 download site. All information regarding the Bureau 14 download site is in your welcome e-mail.

The archive contains a JAR named ``quasardb-java-api-master.jar`` that contains all the dependencies including the required binaries for FreeBSD, Linux and Windows. It is not necessary to download another archive to use the Java API.

You will also find two examples in the ``examples`` directory, one for the high-level API, one for the low-level API.

Package
-------

The API resides in the ``com.b14.quasardb`` package.

Running the examples
-----------------------

You first need to compile the example with ``javac``. Assuming ``quasardb-java-api-master.jar`` is in ``/tmp``::

    javac -classpath /tmp/quasardb-java-api-master.jar QuasardbExample.java

Then you run the example::

    java -classpath /tmp/quasardb-java-api-master.jar:. QuasardbExample

The example requires a quasardb server listening on ``127.0.0.1`` (IPV4 localhost) port 2836. Should you wish to run the example on a different server, you need but to edit it! See :doc:`../reference/qdbd` to configure a quasardb :term:`cluster`.

Using the high-level API
------------------------

The high-level API enables you to add any Java object to a quasardb cluster, it takes care of the serialization of said object for you.

This API take cares of loading ad hoc native libraries, no matter which OS you are running (FreeBSD, Linux, Win32 or Win64).

Last but not least this API is thread-safe unlike the low-level API.


Configuring the quasardb instance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You have to use a Map<String,String> to store the quasardb instance configuration parameters::

    Map<String,String> config = new HashMap<String,String>();
    config.put("name", "test");
    config.put("host", "127.0.0.1");
    config.put("port", "2836");

Once the parameters are valid, you can create a QuasarDB instance like this::

    Quasardb qdb = new Quasardb(config);

Your quasardb instance is now ready to use.

Using the quasardb instance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Java objects can be added and retrieved directly::

    // You can put a simple String Object...
    qdb.put("obj1", "My First value !!!");
	
    // ... or any Java Object you want (even a POJO)
    qdb.put("obj2", new Object[] {new String[] {"11", "2222", null, "4"}, new int[] {1, 2, 3, 4}, new int[][] { {1, 2}, {100, 4}}});

    // You can get your values:
    String value = qdb.get("obj1");
    System.out.println("Result: " + value);

    // You can remove values:
    qdb.remove("obj2");

    // And update stored values:
    qdb.update("obj1", new Character[] { new Character('t'), new Character('e'), new Character('s'), new Character('t') });

	
Note about java entries :

A majority of entries type can be stored in quasardb without any further work (for example all `Serializable <http://docs.oracle.com/javase/7/docs/api/java/io/Serializable.html>`_ and `Externalizable <http://docs.oracle.com/javase/7/docs/api/java/io/Externalizable.html>`_ objects can be used directly).

You can use almost any java objects you want (for example a `POJO <http://en.wikipedia.org/wiki/Plain_Old_Java_Object>`_).

But there are some limitations. 
As Kryo is the underlying framework used to serialize objects in quasardb, you can find all limitations by consulting `Kryo's documentation <https://github.com/EsotericSoftware/kryo#compatibility>`_.
	
Using the low-level API
-----------------------

The low-level API provides direct access to the C API via JNI. 
Usage of the low-level API is discouraged.

Loading the JNI
^^^^^^^^^^^^^^^^^^

Your Java program must load the native JNI library to use the quasardb API: ::

    static
    {
        System.loadLibrary("qdb_java_api");
    }

All the dependencies must be resolved for the load to be successful. This should be the case if you copy all the libraries present in the ``bin`` directory (Windows) or ``lib`` directory (FreeBSD and Linux).

Connecting to a quasardb cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The connection is a two step process.

    #. *Initialize* the quasardb client session: ::

        SWIGTYPE_p_qdb_session session = quasardb.open();

    #. Connect to a :term:`server` within a :term:`cluster`: ::

        qdb_error_t r = quasardb.connect(session, "192.168.1.1", 2836);

In this case we're connecting to the server ``192.168.1.1`` but we could have specified a domain name or an IPv6 address.

Each connection to a server must be terminated manually: ::

    quasardb.close(session);

Adding an entry to the cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To add an entry to the cluster you need to specify it's :term:`alias` and wrap the :term:`content` in a `ByteBuffer <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html>`_, see :ref:`java-memory-management`: ::

            String alias = "myAlias";
            String myData = "this is my data";

            // it's *VERY* important for the byte buffer to be a direct buffer
            // otherwise the JNI will not be able to access it
            java.nio.ByteBuffer bb = java.nio.ByteBuffer.allocateDirect(1024);
            bb.put(myData.getBytes());
            bb.flip();

            r = quasardb.put(session, alias, bb, bb.limit());
            if (r != qdb_error_t.error_ok)
            {
                // error
            }

Getting an entry from the cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Retrieving an entry requires knowing the alias and allocating a `ByteBuffer <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html>`_ large enough to hold all the :term:`content`, see :ref:`java-memory-management`: ::

    String alias = "myAlias";
    java.nio.ByteBuffer content = java.nio.ByteBuffer.allocateDirect(1024);
    int [] contentLength = { 0 };

    r = quasardb.get(session, alias, content, contentLength);
    if (r != qdb_error_t.error_ok)
    {
        // error
    }

We pass an int array to receive the actual size of the data we obtained from the repository, even if the buffer was not large enough to hold all the data. We can also use the :js:func:`quasardb.get_size` to query the size of an entry: ::

    String alias = "myAlias";
    long s = quasardb.get_size(session, alias);
    if (!s)
    {
        // entry not found
    }

.. _java-memory-management:

Memory management
^^^^^^^^^^^^^^^^^^

The API uses a logic very close to the QuasarDB C API (Feel free to review the C API documentation for useful background information, see :doc:`c`).

In particular, to avoid pressuring the garbage collector, and to minimize useless copies, entries' :term:`content` are wrapped in `ByteBuffer <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html>`_ objects instead of byte arrays or `String <http://download.oracle.com/javase/1.4.2/docs/api/java/lang/String.html>`_ objects.

Aliases - on the other hand - use regular String objects for convenience.

The ByteBuffer must be initialized with `allocateDirect <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html#allocateDirect%28int%29>`_ so that the JNI may access the memory. The buffer *must* be large enough to hold all the content, otherwise the call will fail.

When adding entries, this is generally not an issue as the caller knows the size of the content it will add, however when retrieving entries this may be more problematic. Either the caller can allocate more data than required or it can use the :js:func:`get_size` to obtain the size of an entry.

Reference
---------

The complete reference guide is available in the following locations:
  * :doc:`QuasarDB Java Reference Guide <packages>`
  * `Javadoc format <javadoc/index.html>`_
  * Included as HTML in the Java API archive, in the ``doc`` directory.

