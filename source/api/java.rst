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
          <version>2.1.0-SNAPSHOT</version>
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
        compile 'net.quasardb:qdb:2.1.0-SNAPSHOT'
    }


.. _Javadoc: https://doc.quasardb.net/java/

Reference
---------

.. doxygennamespace:: net::quasardb::qdb
  :project: qdb_jni_api
  :members: