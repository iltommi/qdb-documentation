Java
====

.. default-domain:: java
.. highlight:: java

Introduction
------------

This document is an introduction to the quasardb Java API.

You can see this code in action in this sample project:
https://github.com/bureau14/qdb-api-java-example

For more detail, please refer to the Javadoc.

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
          <version>2.0.0rc5</version>
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
        compile 'net.quasardb:qdb:2.0.0rc5'
    }

Connecting to the database
--------------------------

You connect to a quasardb database by creating an instance of ``QdbCluster``.
The address of the clutser (the URI) must be given as an argument to the constructor.

For example, to connect to a quasardb node running on the local machine:

.. code-block:: java

    QdbCluster db = new QdbCluster("qdb://127.0.0.1:2836");

The constructor of ``QdbCluster`` will throw an exception if the connection cannot be established.

Manipulating "blobs"
--------------------

Blob stands for Binary Large Object, it's the term in quasardb for unstructured data.
A blob is a finite sequence of bytes, of any size.
In Java, a blob is materialized by an instance of ``java.nio.ByteBuffer``.

To perform operations on a blob, you need to get an instance of ``QdbBlob`` like this::

    QdbBlob blob = db.blob("name of the blob");

The ``String`` that is passed to ``QdbCluster.blob()`` is called the "alias" of the blob. It's the identifier of the blob in the database and it must be unique. See :ref:`aliases` for more information.

Then, you can perform operations on the blob.

First, there is the ``put()`` operation, that creates a blob::

    ByteBuffer someData = getSomeData();
    blob.put(someData);

Then, there is the ``update()`` operation, which is exactly like ``put()`` excepts that it doesn't throw if the entry already exists::

    ByteBuffer someNewData = getSomeData();
    blob.update(someData);

Reading the content of the blob is done by the ``get()`` operation::

    try (QdbBuffer content = blob.get()) {
      ByteBuffer someData = content.toByteBuffer();
      // ...
    }

As you see, ``QdbBlob.get()`` doesn't return a ``ByteBuffer``, but a ``QdbBuffer`` which implements ``AutoCloseable``.
You'll find an entire section dedicated to ``QdbBuffer`` later in this document.

To delete the blob, you can call::

    blob.remove();

We just saw the main four operations on blobs: ``put()``, ``update()``, ``get()`` and ``remove()``.

There are four other operations for blobs:

- ``compareAndSwap()``
- ``getAndRemove()``
- ``getAndUpdate()``
- ``removeIf()``

You'll find the details in the Javadoc.

Manipulating "deques"
---------------------

Deque stands for "double-ended queue".
There are queues that can be used in both directions: forward and backward.

A deque can be seen as a list of blob.

To perform operations on a deque, you need to get an instance of ``QdbDeque`` like this::

    QdbDeque deque = db.deque("name of the deque");

As for the blob, the alias of the deque is passed to ``QdbCluster.deque()``.

To create a deque, you just need to enqueue an item.

For example, to enqueue at the end of the deque::

    ByteBuffer someData = someData();
    deque.pushBack(someData);

And to enqueue at the beginning of the deque::

    ByteBuffer someData = someData();
    deque.pushFront(someData);

Then, to dequeue an item from the beginning::

    try (QdbBuffer content =  deque.popFront()) {
      ByteBuffer someData = content.toByteBuffer();
      // ...
    }

or from the end::

    try (QdbBuffer content = deque.popBack()) {
      ByteBuffer someData = content.toByteBuffer();
      // ...
    }

These two methods extract the item from the deque and return the content in a ``QdbBuffer``.
You'll find an entire section dedicated to ``QdbBuffer`` later in this document.

You can also read the content of the first or last item with out removing them from the deque::

    QdbBuffer firstItem = deque.front();
    QdbBuffer lastItem = deque.back();

It's also possible to read any item of the deque by it's position::

    int index = getPosition();
    QdbBuffer item = deque.get(index);

The position is a zero-based index, ie the first item is at index 0 and the last at index N-1.

If the position is negative, then the deque is read from the back, ie the last item is at index -1 and the first at -N-1.

As a consequence, ``QdbDeque.front()`` is equivalent to ``QdbDeque.get(0)`` and ``QdbDeque.back()`` is equivalent to ``QdbDeque.get(-1)``.

To known the actual number of item in the deque, call ``QdbDeque.size()``::

    int numberOfItem = deque.size();

Lastly, you can delete a deque, just like a blob::

    deque.remove();


Manipulating integers
---------------------

Although it's possible to store integer in blobs, it's not very convenient.
For that reason, quasardb has a dedicated type for storing 64-bit integers.

To perform operations on an integer, you need to get an instance of ``QdbInteger`` like this::

    QdbInteger integer = db.integer("name of the integer");

As for blobs and deques, the alias of the integer is passed to ``QdbCluster.integer()``.

Just like blobs, integers support ``put()``, ``update()``, ``get()`` and ``remove()`` operations::

    integer.put(10);
    integer.update(20);
    long value = integer.get();
    integer.remove();

And there is a special function for performing atomic additions::

    long result = integer.add(30);

``QdbInteger.add()`` increments (or decrements if the argument is negative) the value in the database and returns the new value.


Manipulating tags
-----------------

In quasardb, tags are strings that you can attach to entries. There are used as a kind of lightweight index.

To add a tag to an entry, just call ``QdbEntry.attachTag()``::

    blob.attachTag("name of the tag");

A tag is also an entry, that you can manipulate through an instance of ``QdbTag``::

    QdbTag tag = db.tag("name of the tag");

From here, you can tag entries::

    tag.addEntry("name of the blob");

which is exactly the same as calling ``QdbEntry.attachTag()``.

It was also possible to use the handles instead of the alias, like this::

    tag.addEntry(blob);
    blob.attachTag(tag);

All of these constructions are synonym.

Like adding a tag, there are four ways to remove a tag from an entry::

    blob.detachTag("name of the tag");
    blob.detachTag(tag);
    tag.removeEntry("name of the blob");
    tag.removeEntry(blob);

From a ``QdbTag``, you can enumerate all tagged entries::

    Iterable<QdbEntry> taggedEntries = tag.entries();

And, from a ``QdbEntry``, you can enumerate all tags::

    Iterable<QdbTag> tagsOfEntry = blob.tags();

Like any other entry, a tag can be tagged and be removed::

    tag.attachTag("name of another tag");
    tag.remove();

Manipulating streams
--------------------

In quasardb, a stream is like a blob, except that it's distributed and can grow indefinitely.

As for the other types of entry, you get a handle via the ``QdbCluster``::

    QdbStream stream = db.stream("name of the stream");

Then you can do the common things you do with other entries::

    stream.attachTag("name of the tag");
    stream.remove();

But when you want to write to the stream, you need to open it::

    SeekableByteChannel channel = stream.open(QdbStream.Mode.Append);
    channel.write(someByteBuffer);
    channel.close();

Which, once again, should be used in a try-with-resource block::

    try (SeekableByteChannel channel = stream.open(QdbStream.Mode.Append)) {
      channel.write(someByteBuffer);
    }

The mode ``QdbStream.Mode.Append`` allows to read and write to the stream.
Only one client can open the stream in this mode at a given type.
In other words, the write access to the stream is exclusive.

The ``SeekableByteChannel`` returned by ``open()`` allows to seek and truncate the stream.

In a similar fashion, you can open the stream in read-only mode::

    try (SeekableByteChannel channel = stream.open(QdbStream.Mode.Read)) {
      channel.read(someByteBuffer);
    }

Except that there can be any number of clients reading the stream at the same time.


Batching operation
------------------

When manipulating a lot of small blobs, the network can become a bottleneck. To improve performance, quasardb allows to group operations together in a "batch".

A batch is created from the ``QdbCluster``::

    QdbBatch batch = db.createBatch();

Then, you queue the operations, just like you did before::

    batch.blob("name of the blob").put(someData);

For operations that returns a value, the return type is wrapped in a "future"::

    QdbFuture<ByteBuffer> content = batch.blob("name of the blob").get();

A ``QdbFuture`` will contain the result of the operation, but only after running the batch::

    batch.run();

To read the result of the future, just call ``QdbFuture.get()``::

    ByteBuffer bb = content.get();

As you can see, the return value is a ``ByteBuffer``, and not a ``QdbBuffer``.
This is because the memory is held by the ``QdbBatch``, until ``close()`` is called.
For this reason, it's recommended to use a batch in a try-with-resource statement::

    try (QdbBatch batch = db.createBatch()) {
        batch.blob("blob1").put(contentOfBlob1);
        QdbFuture<ByteBuffer> contentOfBlob2 = batch.blob("blob2").get();
        batch.run();
        doSomething(contentOfBlob2.get());
    }

Why ``QdbBuffer`` instead of ``ByteBuffer``?
--------------------------------------------

Some operations return a buffer that is allocated in non-managed memory.
This memory is out-side of the Java heap, and is not handled by the garbage collector.

``QdbBuffer`` responsible for releasing this memory.

The memory is released by ``QdbBuffer.close()``::

    QdbBuffer buffer = db.blob("name of the blob").get();
    try {
        ByteBuffer data = buffer.toByteBuffer();
    }
    finally {
        buffer.close();
    }

Or, better, by using the try-with-resource statement introduced in Java 7::

    try (QdbBuffer buffer = db.blob("name of the blob").get()) {
        ByteBuffer data = buffer.toByteBuffer();
    }

If you don't call ``QdbBuffer.close()``, the memory will be released by the finalizer.
However, this is a bad practice because you would waste a lot of memory and ultimately be out of memory.
The best is to close the ``QdbBuffer`` as soon as possible.

.. warning:: ``ByteBuffer`` and ``QdbBuffer`` life spans

    It's very important that you never have a reference to the ``ByteBuffer`` with a longer life span than the ``QdbBuffer``.

    Indeed, if you don't hold a reference to the ``QdbBuffer``, the garbage collector might decide to destroy it, thereby releasing the non-managed memory.

    As a result, ``ByteBuffer`` would point to invalid location in memory and your program would crash in an unpredictable manner.

So, in a nutshell:

1. don't keep the result of ``QdbBuffer.toByteBuffer()``
2. call ``QdbBuffer.close()`` as soon as possible

See Also (References):
----------------------

Aggregation
^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbAggregation
	:project: qdb_java_api
	:members:

Batch
^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbBatch
	:project: qdb_java_api
	:members:

BatchBlob
^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbBatchBlob
	:project: qdb_java_api
	:members:

BatchEntry
^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbBatchEntry
	:project: qdb_java_api
	:members:

BatchFuture
^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbBatchFuture
	:project: qdb_java_api
	:members:

BatchOperation
^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbBatchOperation
	:project: qdb_java_api
	:members:


Cluster
^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbCluster
	:project: qdb_java_api
	:members:

Blobs
^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbBlob
	:project: qdb_java_api
	:members:

BlobAggregation
^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbBlobAggregation
	:project: qdb_java_api
	:members:

BlobAggregationCollection
^^^^^^^^^^^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbBlobAggregationCollection
	:project: qdb_java_api
	:members:

Blob Column Collection
^^^^^^^^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbBlobColumnCollection
	:project: qdb_java_api
	:members:

Blob Column Value
^^^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbBlobColumnValue
	:project: qdb_java_api
	:members:

Column Collection
^^^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbColumnCollection
	:project: qdb_java_api
	:members:


Column Definition
^^^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbColumnDefinition
	:project: qdb_java_api
	:members:

Column Value
^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbColumnValue
	:project: qdb_java_api
	:members:

Deque
^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbDeque
	:project: qdb_java_api
	:members:

Double Aggregation
^^^^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbDoubleAggregation
	:project: qdb_java_api
	:members:

Double Aggregation Collection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbDoubleAggregationCollection
	:project: qdb_java_api
	:members:

	
Double Column Collection
^^^^^^^^^^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbDoubleColumnCollection
	:project: qdb_java_api
	:members:

Double Column Value
^^^^^^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbDoubleColumnValue
	:project: qdb_java_api
	:members:

Entry
^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbEntry
	:project: qdb_java_api
	:members:

Entry Factory
^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbEntryFactory
	:project: qdb_java_api
	:members:

Entry Metadata
^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbEntryMetadata
	:project: qdb_java_api
	:members:

Entry Tags
^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbEntryTags
	:project: qdb_java_api
	:members:
	
Expirable Entry
^^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbExpirableEntry
	:project: qdb_java_api
	:members:

Expiry Time
^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbExpiryTime
	:project: qdb_java_api
	:members:

HashSet
^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbHashSet
	:project: qdb_java_api
	:members:

Id
^^

.. doxygenclass:: net::quasardb::qdb::QdbId
	:project: qdb_java_api
	:members:

Integer
^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbInteger
	:project: qdb_java_api
	:members:

Node
^^^^

.. doxygenclass:: net::quasardb::qdb::QdbNode
	:project: qdb_java_api
	:members:

Stream
^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbStream
	:project: qdb_java_api
	:members:

Stream Channel
^^^^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbStreamChannel
	:project: qdb_java_api
	:members:

Tag
^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbTag
	:project: qdb_java_api
	:members:

Tag Entries
^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbTagEntries
	:project: qdb_java_api
	:members:

Time Series
^^^^^^^^^^^

.. doxygenclass:: net::quasardb::qdb::QdbTimeSeries
	:project: qdb_java_api
	:members:



Appendix A: entry class hierarchy
---------------------------------

* ``QdbEntry``

  * ``QdbDeque``

  * ``QdbExpirableEntry``

    * ``QdbBlob``

    * ``QdbInteger``

  * ``QdbHashSet``

  * ``QdbStream``

  * ``QdbTag``

Appendix B: exception class hierarchy
-------------------------------------

* ``RuntimeException``

  * ``QdbException``

    * ``QdbConnectionException``

      * ``QdbConnectionRefusedException``

      * ``QdbHostNotFoundException``

    * ``QdbInputException``

      * ``QdbInvalidArgumentException``

      * ``QdbOutOfBoundsException``

      * ``QdbReservedException``

    * ``QdbOperationException``

      * ``QdbAliasAlreadyExistsException``

      * ``QdbAliasNotFoundException``

      * ``QdbBatchAlreadyRunException``

      * ``QdbBatchCloseException``

      * ``QdbBatchNotRunException``

      * ``QdbBufferClosedException``

      * ``QdbIncompatibleTypeException``

      * ``QdbOperationDisabledException``

      * ``QdbOverflowException``

      * ``QdbResourceLockedException``

      * ``QdbUnderflowException``

    * ``QdbProtocolException``

      * ``QdbUnexpeectedReplyException``

    * ``QdbSystemException``

      * ``QdbLocalSystemException``

      * ``QdbRemoteSystemException``

Reference
---------

* `Javadoc website <https://doc.quasardb.net/java/>`_
