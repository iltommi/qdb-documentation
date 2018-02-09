Java
====

.. default-domain:: java
.. highlight:: java

Introduction
------------

This document is an introduction to the quasardb Java API. It is primarily focused on
timeseries, and will guide you through the various ways you can interact with the
QuasarDB backend.

For a more comprehensive reference, please refer directly to our Javadoc_.

Installation
------------

The quasardb Java API is available in our Maven repositiory.

To use it in your project, you need to add the repository ``maven.quasardb.net``

Then, you must add a dependency to ``net.quasardb:qdb``

For example, if you're using Maven, your ``pom.xml`` should look like:

.. code-block:: xml

    <project>
      [...]
      <repositories>
        <repository>
          <id>quasardb</id>
          <name>Quasardb Official Repository</name>
          <url>http://maven.quasardb.net</url>
        </repository>
      </repositories>
      <dependencies>
        <dependency>
          <groupId>net.quasardb</groupId>
          <artifactId>qdb</artifactId>
          <version>2.3.0</version>
        </dependency>
      </dependencies>
    </project>

Or, if you use Gradle, your ``build.gradle`` should look like:

.. code-block:: groovy

    apply plugin: 'java'

    repositories {
        maven {
            url "http://maven.quasardb.net"
        }
    }

    dependencies {
        compile 'net.quasardb:qdb:2.3.0'
    }


.. _Javadoc: https://doc.quasardb.net/java/

Connecting to the database
--------------------------

QuasarDB provides thread-safe access to a cluster using the :cpp:class:`Session <net::quasardb::qdb::Session>` class. This class comes with a built-in, high-performance connection pool that can be shared between multiple threads. You are encourage to reuse this object as often as possible, ideally only creating a single instance during the lifetime of your JVM process.

Establishing a connection
^^^^^^^^^^^^^^^^^^^^^^^^^

You connect to a QuasarDB cluster by calling the **connect** function of the :cpp:class:`Session <net::quasardb::qdb::Session>` class and establishing a connection with a QuasarDB cluster like this:

.. code-block:: java

   try {
     Session mySession = Session.connect(uri);
   } catch (ConnectionRefusedException ex) {
     System.err.println("Failed to connect to " + uri +
                        ", make sure server is running!");
     System.exit(1);
   }

Establishing a secure connection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By providing additional :cpp:class:`SecurityOptions <net::quasardb::qdb::Session::SecurityOptions>` when establishing a connection, we get a secure connection to the cluster:

.. code-block:: java

   try {
     Session mySession = Session.connect(new Session.SecurityOptions("userName",
                                                                     "userPrivateKey",
                                                                     "clusterPublicKey"),
                                         uri);
   } catch (ConnectionRefusedException ex) {
     System.err.println("Failed to connect to " + uri +
                        ", make sure server is running!");
     System.exit(1);
   }

Reference
---------

This chapter contains a short summary of our Java API. For more a complete reference, please see our Javadoc_.

.. doxygenclass:: net::quasardb::qdb::Session::SecurityOptions
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::Session
	:project: qdb_java_api
        :members: connect
