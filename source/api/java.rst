Java
====

.. default-domain:: java
.. highlight:: java

Introduction
------------

This document is an introduction to the quasardb Java API. It is primarily focused on
timeseries, and will guide you through the various ways you can interact with the
QuasarDB backend.

.. note:: If you are looking for a more comprehensive reference, please refer directly to our
          Javadoc_.

Requirements
------------

 * [quasardb daemon](https://download.quasardb.net/quasardb/)
 * JDK 8 or higher

Adding QuasarDB to your build
-----------------------------

QuasarDB's Maven group ID is `net.quasardb` and the artifact ID is `qdb`.

Maven
^^^^^

To add a dependency on the QuasarDB Java API using Maven, use the following:

.. code-block:: xml
   <dependency>
     <groupId>net.quasardb</groupId>
     <artifactId>qdb</artifactId>
     <version>2.6.0</version>
   </dependency>

Gradle
^^^^^^

To add a dependency using Gradle:

.. code-block:: bash
   dependencies {
     compile "net.quasardb.qdb:2.6.0"
   }

Snapshot releases
^^^^^^^^^^^^^^^^^

We continuously release snapshot releases on Sonatype's OSS repository. To gain access to it, please add Sonatype's snapshot repository to your build profile. For Maven, this can be achieved by adding the following profile to your `settings.xml`:

.. code-block:: xml

   <profile>
     <id>allow-snapshots</id>
       <activation><activeByDefault>true</activeByDefault></activation>
       <repositories>
       <repository>
         <id>snapshots-repo</id>
         <url>https://oss.sonatype.org/content/repositories/snapshots</url>
         <releases><enabled>false</enabled></releases>
         <snapshots><enabled>true</enabled></snapshots>
       </repository>
     </repositories>
   </profile>

Please adjust your artifact version accordingly by appending the appropriate `-SNAPSHOT` qualifier as documented at [the official Maven documentation](https://docs.oracle.com/middleware/1212/core/MAVEN/maven_version.htm#MAVEN401).

.. _Javadoc: https://doc.quasardb.net/java/

Connecting to the database
--------------------------

QuasarDB provides thread-safe access to a cluster using the :cpp:class:`Session <net::quasardb::qdb::Session>` class. This class comes with a built-in, high-performance connection pool that can be shared between multiple threads. You are encourage to reuse this object as often as possible, ideally only creating a single instance during the lifetime of your JVM process.

Establishing a connection
^^^^^^^^^^^^^^^^^^^^^^^^^

You connect to a QuasarDB cluster by calling the ``connect`` function of the :cpp:class:`Session <net::quasardb::qdb::Session>` class and establishing a connection with a QuasarDB cluster like this:

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


Table management
----------------

The Java API exposes its timeseries using the :cpp:class:`Table <net::quasardb::qdb::ts::Table>` class.

Create
^^^^^^

You can invoke the ``create`` to create a new timeseries table:

.. code-block:: java

    Column[] columns = {
      new Column.Double("double_val"),
      new Column.Int64("int_val"),
      new Column.Timestamp("ts_val")
    };

    Table myTable = Table.create(session, "my_table", columns, 3600000);

The example above will create a table `my_table` with three different columns with a shard size of 1 hour. You can choose to omit the shard size, in which case the default shard size of 1 day will be chosen. Please refer to the :cpp:class:`Column <net::quasardb::qdb::ts::Column>` class to see a full overiew of the supported column types.


Writing data
------------

When writing data to a :cpp:class:`Table <net::quasardb::qdb::ts::Table>`, QuasarDB maintains a local buffer before writing data. This approach ensures batches of data are written in bulk, minimalising overhead and improving performance.

We provide several mechanisms for you to write data. Which mechanism works best for you depends upon your use case, but when in doubt you should use the :cpp:class:`AutoFlushWriter <net::quasardb::qdb::ts::AutoFlushWriter>`.

.. note:: Individual batches are always written atomically, which means that a buffer is either completely visible to other clients, or not at all.

Explicit flushing
^^^^^^^^^^^^^^^^^
The most basic write access is to make use of a :cpp:class:`Writer <net::quasardb::qdb::ts::Writer>` and periodically calling ``flush`` on that Writer. You can create a new Writer by calling the ``writer`` method of the :cpp:class:`Table <net::quasardb::qdb::ts::Table>` class like this:

.. code-block:: java

    Writer w = Table.writer(session, myTable);
    for (long i = 0; i < 10000; ++i) {
      w.append(generateRow());
    }
    w.flush();
    w.close(); // call when done

The code above will locally buffer all 10,000 rows before writing them all in a single, **atomic** batch operation when ``flush`` is called. Naturally, these rows will not be visible to any other client until the ``flush`` operation completes.

Implicit flushing
^^^^^^^^^^^^^^^^^
If all you care about is that the buffer is flushed periodically every N rows, we provide an :cpp:class:`AutoFlushWriter <net::quasardb::qdb::ts::AutoFlushWriter>` which you can create by calling the ``autoFlushWriter`` method of the :cpp:class:`Table <net::quasardb::qdb::ts::Table>` class like this:

.. code-block:: java

    Writer w = Table.autoFlushWriter(session, myTable);
    for (long i = 0; i < 75000; ++i) {
      w.append(generateRow());
    }
    w.flush(); // otherwise some data might not be fully flushed!
    w.close();

The code above initialises an :cpp:class:`AutoFlushWriter <net::quasardb::qdb::ts::AutoFlushWriter>` with default arguments. By default, this means 50,000 rows. If you would like to excercise more control over flush interval behaviour, you can customise the flush interval like this:

.. code-block:: java

    Writer w = Table.autoFlushWriter(session, myTable, 1);
    for (long i = 0; i < 1000; ++i) {
      w.append(generateRow());
    }
    // flush not necessary in this case!

As a means of example, the code above will flush the buffer every 1 rows (i.e. every write is a flush). In practice, we recommend you to use as high a number as possible that works for your use case.

Reading data
------------

The Java API provides access to both a bulk :cpp:class:`Reader <net::quasardb::qdb::ts::Reader>` class which should be used for large table scans, and a :cpp:class:`Reader <net::quasardb::qdb::ts::Query>` class which can be used for more refined querying.

Reader
^^^^^^
Assuming you already have a reference to a :cpp:class:`Reader <net::quasardb::qdb::ts::Table>`, you can scan this table as follows:

.. code-block:: java

   Reader r = Table.reader(session, myTable, myTimeRange);
   while (r.hasNext() == true) {
     Row row = r.next();
     System.out.println(row.toString());
   }

As you can see above, the :cpp:class:`Reader <net::quasardb::qdb::ts::Reader>` exposes a simple ``Iterator`` interface that allows you to iterate over :cpp:class:`Row <net::quasardb::qdb::ts::Row>` objects. When you prefer a more functional-style, we also expose the underlying dataset as a Java8 stream:

.. code-block:: java

   Table
     .reader(session, t, myTimeRange)
     .stream()
     .parallel()
     .filter(myClass::isValid)
     .forEach(System.out::println);

Query
^^^^^

.. note:: For more information about the query language itself, see our :doc:`queries` documentation.

For more ad-hoc analysis and aggregations, you can use our :cpp:class:`Query <net::quasardb::qdb::ts::Query>` class:

.. code-block:: java

   Result r = Query.of("select double_val from "  + myTable.getName() + " in range(now, +1h)")
                   .execute(session);
   for (Result.Table t : r.tables) {
     System.out.println("has table with results: " + t.toString());
   }

And the Query API also provides Stream-based access to the Result set:

.. code-block:: java

   Query.of("select double_val from "  + myTable.getName() + " in range(now, +1h)")
     .execute(session)
     .parallel()
     .filter(myClass::isValid)
     .forEach(System.out::println);

The code above will query the ``double_val`` column from your time range, and return the entire :cpp:class:`Result <net::quasardb::qdb::ts::Result>` object. We also suggest you explore our Javadoc_ to see a more comprehensive overview on how to inspect the Result object.


Reference
---------

This chapter contains a short summary of our Java API. For more a complete reference, please see our Javadoc_.

.. doxygenclass:: net::quasardb::qdb::Session::SecurityOptions
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::Session
	:project: qdb_java_api
        :members: connect

.. doxygenclass:: net::quasardb::qdb::ts::Table
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::ts::Column
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::ts::Writer
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::ts::AutoFlushWriter
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::ts::Reader
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::ts::Query
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::ts::TimeRange
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::ts::Row
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::ts::Value
	:project: qdb_java_api
        :members:

.. doxygenclass:: net::quasardb::qdb::ts::Result
	:project: qdb_java_api
        :members:
