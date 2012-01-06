
Java
===================


.. highlight:: java

Introduction
--------------

The wrpme Java API uses JNI to bring the power and speed of wrpme to the Java world without compromising performances.

It fully integrates itself into the Java environment thanks to a wrapper (also called 'high-level API'). The wrapper itself comes with a BSD license and can be freely used in your clients. 

The wrapper uses a low-level API that is also directly useable although with severe restrictions.

Installation
---------------

The Java API package is downloadable from the `wrpme web site <http://www.wrpme.com/downloads.html>`_. 

The archive contains a JAR named ``wrpme-java-api-master.jar`` that contains all the dependencies including the required binaries for FreeBSD, Linux and Windows. It is not needed to download another archive to use the Java API.

You will also find two examples in the ``examples`` directory, one for the high-level API, one for the low-level API.

Package
-------------------

The API resides in the ``com.b14.wrpme`` package.

Requirements
------------------------

Java 1.4.2 or later is required.

Running the examples
-----------------------

You first need to compile the example with ``javac``. Assuming ``wrpme-java-api-master.jar`` is in ``/tmp``::

    javac -classpath /tmp/wrpme-java-api-master.jar WrpmeExample.java

Then you run the example::

    java -classpath /tmp/wrpme-java-api-master.jar:. WrpmeExample

The example requires an wrpme server listening on ``127.0.0.1`` (IPV4 localhost) port 5909. Should you wish to run the example on a different server, you need but to edit it! See :doc:`../reference/wrpmed` to configure a wrpme :term:`cluster`.

Using the high-level API
------------------------------

The high-level API enables you to add any Java object to a wrpme cluster, it takes care of the serialization of said object for you.

The API documentation is available in Javadoc format `here <http://doc.wrpme.com/javaapi>`_. This documentation is also included in the Java API archive. You will find it in ``doc`` directory.

Using the low-level API
----------------------------

The low-level API provides direct access to the C API. It is not thread-safe and the high-level API should be prefered.

Loading the JNI
^^^^^^^^^^^^^^^^^^

You Java program must load the native JNI library to use the wrpme API: ::

    static 
    {
        System.loadLibrary("wrpme_java_api");
    }
    
All the dependencies must be resolved for the load to be successful. This should be the case if you copy all the libraries present in the ``bin`` directory (Windows) or ``lib`` directory (FreeBSD and Linux).

Connecting to a wrpme cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The connection is a two steps process.

First you need to *initialize* the wrpme client session: ::

    SWIGTYPE_p_wrpme_session session = wrpme.open();

Then you connect to a :term:`server` within a :term:`cluster`: ::

    wrpme_error_t r = wrpme.connect(session, "192.168.1.1", 5909);
    
In this case we're connecting to the server ``192.168.1.1`` but we could have specified a domain name or an IPv6 address.

Each connection to a server must be terminated manually: ::

    wrpme.close(session);
    
Adding an entry to the cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To add an entry to the cluster you need to specify it's :term:`alias` and wrap the :term:`content` in a `ByteBuffer <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html>`_, see :ref:`java-memory-management`: ::

            String alias = "myAlias";
            String myData = "this is my data";
            
            // it's *VERY* important for the byte buffer to be a direct buffer
            // otherwise the JNI will not be able to access it
            java.nio.ByteBuffer bb = java.nio.ByteBuffer.allocateDirect(1024);            
            bb.put(myData.getBytes());
            bb.flip();
            
            r = wrpme.put(session, alias, bb, bb.limit());
            if (r != wrpme_error_t.error_ok)
            {
                // error
            }
    
Getting an entry from the cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Retrieving an entry requires knowing the alias and allocating a `ByteBuffer <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html>`_ large enough to hold all the :term:`content`, see :ref:`java-memory-management`: ::

    String alias = "myAlias";
    java.nio.ByteBuffer content = java.nio.ByteBuffer.allocateDirect(1024);
    int [] contentLength = { 0 };
    
    r = wrpme.get(session, alias, content, contentLength);
    if (r != wrpme_error_t.error_ok)
    {
        // error
    }
    
We pass an int array to receive the actual size of the data we obtained from the repository, even if the buffer was not large enough to hold all the data. We can also use the :js:func:`wrpme.get_size` to query the size of an entry: ::

    String alias = "myAlias";
    long s = wrpme.get_size(session, alias);
    if (!s)
    {
        // entry not found
    }
    
.. _java-memory-management:
    
Memory management
^^^^^^^^^^^^^^^^^^

The API uses a logic very close the wrpme C API (Feel free to review the C API documentation for useful background information, see :doc:`c`).

In particular, to avoid pressuring the garbage collector, and to minimize useless copies, entries' :term:`content` are wrapped in `ByteBuffer <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html>`_ objects instead of byte arrays or `String <http://download.oracle.com/javase/1.4.2/docs/api/java/lang/String.html>`_ objects.

Aliases - on the other hand - use regular String objects as a convenience.

The ByteBuffer must be initialized with `allocateDirect <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html#allocateDirect%28int%29>`_ so that the JNI may access the memory. The buffer *must* be large enough to hold all the content, otherwise the call will fail.

When adding entries, this is generally not an issue as the caller knows the size of the content it will add, however when retrieving entries this may be more problematic. Either the caller can allocate more data than required or it can use the :js:func:`get_size` to obtain the size of an entry.


Reference
^^^^^^^^^^^^^^^^^^
   
.. js:class:: SWIGTYPE_p_wrpme_session()

    An opaque structure that wraps the session handle.

.. js:class:: wrpme_error_t()

    A wrapper for the error code used by most wrpme methods to indicate success status.

.. js:class:: wrpme()

    A fully-featured low level class to add, update, get and delete entries from a wrpme :term:`cluster`
    
.. js:function:: static SWIGTYPE_p_wrpme_session wrpme.open()

    Creates a client instance for the TCP network protocol.
    
    :return: A valid handle when successful, 0 in case of failure. The handle must be closed with :js:func:`close`.
    
.. js:function:: static wrpme_error_t wrpme.close(SWIGTYPE_p_wrpme_session handle)

    Terminates all connections and releases all client-side allocated resources.
    
    :param handle: An initialized handle (see :js:func:`wrpme.open`)

    :return: An error code of type :cpp:class:`wrpme_error_t`
   
.. js:function:: static wrpme_error_t wrpme.connect(SWIGTYPE_p_wrpme_session handle, String host, int port)
    
    Binds the client instance to a wrpme :term:`server` and connects to it.

    :param handle: An initialized handle (see :js:func:`wrpme.open`)
    :param host: A string representing the IP address or the name of the server to which to connect
    :param port: The port number used by the server. The default wrpme port is 5909.

    :return: An error code of type :cpp:class:`wrpme_error_t`
  
.. js:function:: wrpme_error_t wrpme.put(SWIGTYPE_p_wrpme_session handle, String alias, java.nio.ByteBuffer content, long content_length)
  
    Adds an :term:`entry` to the wrpme server. If the entry already exists the function will fail and will return ``wrpme_e_alias_already_exists``.

    The handle must be initialized (see :js:func:`wrpme.open`) and the connection established (see :js:func:`wrpme.connect`).

    :param handle: An initialized handle (see :js:func:`wrpme.open`)
    :param alias: A string representing the entry's alias to create.
    :param content: A `ByteBuffer <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html>`_ holding the entry's content to be added to the server.
    :param content_length: The length of the entry's content, in bytes.
    
    :return: An error code of type :cpp:class:`wrpme_error_t`
    
.. js:function:: static wrpme_error_t wrpme.update(SWIGTYPE_p_wrpme_session handle, String alias, java.nio.ByteBuffer content, long content_length) 

    Updates an :term:`entry` of the wrpme server. If the entry already exists, the content will be update. If the entry does not exist, it will be created.

    The handle must be initialized (see :js:func:`wrpme.open`) and the connection established (see :js:func:`wrpme.connect`).

    :param handle: An initialized handle (see :js:func:`wrpme.open`)
    :param alias: A string representing the entry's alias to update.
    :param content: A `ByteBuffer <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html>`_ holding the entry's content to be added to the server.
    :param content_length: The length of the entry's content, in bytes.
    
    :return: An error code of type :cpp:class:`wrpme_error_t`
    
.. js:function:: static long wrpme.get_size(SWIGTYPE_p_wrpme_session handle, String alias)

    Obtains the size of an entry's :term:`content`.
    
    :param handle: An initialized handle (see :js:func:`wrpme.open`)
    :param alias: The :term:`alias` for which the size is queried
    :return: The size of the content, in bytes. 0 if the entry does not exist.
    
.. js:function:: static wrpme_error_t wrpme.get(SWIGTYPE_p_wrpme_session handle, String alias, java.nio.ByteBuffer content, int[] actual_length) 

    Retrieves an :term:`entry`'s content from the wrpme server. The caller is responsible for allocating provided `ByteBuffer <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html>`_. The allocation *must* be done with `allocateDirect <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html#allocateDirect%28int%29>`_.
    
    If the entry does not exist, the function will fail and return ``wrpme_e_alias_not_found``.
    
    If the buffer is not large enough to hold the data, the function will fail and return ``wrpme_e_buffer_too_small``. The actual_length parameter will nevertheless be updated so that the caller may resize its buffer and try again.
    
    The handle must be initialized (see :js:func:`wrpme.open`) and the connection established (see :js:func:`wrpme.connect`).

    :param handle: An initialized handle (see :js:func:`wrpme.open`)
    :param alias: A string representing the entry's alias to obtain.
    :param content: A `ByteBuffer <http://download.oracle.com/javase/1.4.2/docs/api/java/nio/ByteBuffer.html>`_ large enough to receive the content.
    :param actual_length: An array of int of at least size one. The first entry of the array will be updated with the size of the content, if the entry exists.
    
    :return: An error code of type :cpp:class:`wrpme_error_t`

.. js:function:: static wrpme_error_t wrpme.delete(SWIGTYPE_p_wrpme_session handle, String alias) 

    Removes an :term:`entry` from the wrpme server. If the entry does not exist, the function will fail and return ``wrpme_e_alias_not_found``.
    
    The handle must be initialized (see :js:func:`open`) and the connection established (see :js:func:`wrpme.connect`).

    :param handle: An initialized handle (see :js:func:`open`)
    :param alias: A string representing the entry's alias to delete.
    
    :return: An error code of type :c:type:`wrpme_error_t`
    
  

    
