Java
====

.. default-domain:: java
.. highlight:: java

Introduction
------------

This document is an introduction to the quasardb Java API.

You can see this code in action in this sample project:
http://github.com/bureau14/qdb-api-java-example

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

The ``String`` that is passed to ``QdbCluster.blob()`` is called the "alias" of the blob. It's the identifier of the blob in the database and it must be unique.

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

To add a tag to an entry, just call ``QdbEntry.addTag()``::

    blob.addTag("name of the tag");

A tag is also an entry, that you can manipulate through an instance of ``QdbTag``::

    QdbTag tag = db.tag("name of the tag");

From here, you can tag entries::

    tag.addEntry("name of the blob");

which is exactly the same as calling ``QdbEntry.addTag()``.

It was also possible to use the handles instead of the alias, like this::

    tag.addEntry(blob);
    blob.addTag(tag);

All of these constructions are synonym.

Like adding a tag, there are four ways to remove a tag from an entry::

    blob.removeTag("name of the tag");
    blob.removeTag(tag);
    tag.removeEntry("name of the blob");
    tag.removeEntry(blob);

From a ``QdbTag``, you can enumerate all tagged entries::

    Iterable<QdbEntry> taggedEntries = tag.entries();

And, from a ``QdbEntry``, you can enumerate all tags::

    Iterable<QdbTag> tagsOfEntry = blob.tags();

Like any other entry, a tag can be tagged and be removed::

    tag.addTag("name of another tag");
    tag.remove();

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
