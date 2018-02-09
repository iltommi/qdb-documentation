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

You connect to a QuasarDB cluster by creating an instance of :any:`net::quasardb::qdb::Session` and establishing a connection with a QuasarDB cluster.

.. code-block:: java

   static Session connectToCluster(String uri) {
     try {
       return Session.connect(uri);
     } catch (ConnectionRefusedException ex) {
       System.err.println("Failed to connect to " + uri +
                          ", make sure server is running!");
       System.exit(1);
       return null;
     }
   }


Reference
---------

.. doxygenclass:: net::quasardb::qdb::Session
	:project: qdb_java_api
	:members:

.. doxygenclass:: net::quasardb::qdb::ts::Table
	:project: qdb_java_api
	:members:

.. doxygenclass:: net::quasardb::qdb::ts::Writer
	:project: qdb_java_api
	:members:

.. doxygenclass:: net::quasardb::qdb::ts::Reader
	:project: qdb_java_api
	:members:^^^^^

.. doxygenclass:: net::quasardb::qdb::ts::Query
	:project: qdb_java_api
	:members:

.. doxygenclass:: net::quasardb::qdb::ts::Result
	:project: qdb_java_api
	:members:
