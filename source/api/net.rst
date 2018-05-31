.NET
====

.. default-domain:: dotnet

Introduction
------------
Welcome the Quasardb API for .NET.

Connecting to the database
--------------------------

Interfacing with a quasardb database from a .NET program is extremely straightforward, just create a QdbCluster and perform the operations.

.. tabs::

	.. code-tab:: c#

			var cluster = new QdbCluster("qdb://127.0.0.1:2836");

	.. code-tab:: vbnet

			Dim cluster = New QdbCluster("qdb://127.0.0.1:2836");

Blobs
-----

OK, now that we have a connection to the database, let's store some binary data:

.. tabs::

	.. code-tab:: c#

		byte[] a, b, c;

		QdbBlob myBlob = cluster.Blob("Bob the blob");

		myBlob.Put(a);
		myBlob.Update(b);
		c = myBlob.Get();

	.. code-tab:: vbnet

		Dim a, b, c As Byte()

		Dim myBlob = cluster.Blob("Bob the blob")

		myBlob.Put(a)
		myBlob.Update(b)
		c = myBlob.Get()

Double-ended queues
-------------------

Quasardb provides double-ended queues, or simply "deque".

.. tabs::

	.. code-tab:: c#

		byte[] a, b, c;

		QdbDeque myQueue = cluster.Deque("Andrew the queue");

		myQueue.PushBack(a);
		myQueue.PushBack(b);
		c = myQueue.PopFront();

	.. code-tab:: vbnet

		Dim a, b, c As Byte()

		Dim myQueue = cluster.Deque("Andrew the queue")

		myQueue.PushBack(a)
		myQueue.PushBack(b)
		c = myQueue.PopFront()

Integers
--------

quasardb comes out of the box with server-side atomic integers:

.. tabs::

	.. code-tab:: c#

		long a, b, c;

		QdbInteger myInt = cluster.Integer("Roger the integer");

		myInt.Put(a);
		c = myInt.Add(b);

	.. code-tab:: vbnet

		Dim a, b, c As Long

		Dim myInt = cluster.Integer("Roger the integer")

		myInt.Put(a)
		c = myInt.Add(b)

Streams
-------

A stream is basically a scalable blob with inifinite size. It's recommended to use a stream above 10MB.

.. tabs::

	.. code-tab:: c#

		Stream myStream = cluster.Stream("Aline the stream").Open(QdbStreamMode.Append);
		// now you have a regular C# stream:
		myStream.Write(data, 0, data.Length);
		await myStream.WriteAsync(data, 0, data.Length);


Tags
----

Here's how you can easily find your data, using tags:

.. tabs::

	.. code-tab:: c#

		cluster.Blob("Bob the blob").AttachTag("Male");
		cluster.Integer("Roger the integer").AttachTag("Male");

		IEnumerable<QdbEntry> males = cluster.Tag("Male").GetEntries();

	.. code-tab:: vbnet

		cluster.Blob("Bob the blob").AttachTag("Male");
		cluster.Integer("Roger the integer").AttachTag("Male");

		Dim males = cluster.Tag("Males").GetEntries()

Search by prefix or suffix
--------------------------

And here, you can find your data searching by prefix or suffix:

.. tabs::

	.. code-tab:: c#

		cluster.Blob("Hey! Bob the blob. Bye.");
		cluster.Integer("Hey! Roger the integer. Bye.");

		IEnumerable<QdbEntry> heys = cluster.Entries(new QdbPrefixSelector("Hey!", 10));
		IEnumerable<QdbEntry> byes = cluster.Entries(new QdbSuffixSelector("Bye.", 10));

	.. code-tab:: vbnet

		cluster.Blob("Hey! Bob the blob");
		cluster.Integer("Hey! Roger the integer");

		Dim heys = cluster.Entries(New QdbPrefixSelector("Hey!", 10))
		Dim byes = cluster.Entries(New QdbSuffixSelector("Bye.", 10))

Instead of getting the entries as the result, one can ask only for a collection of strings using `Keys()` method instead of `Entries()`.

.. tabs::

	.. code-tab:: c#

		cluster.Blob("Hey! Bob the blob. Bye.");
		cluster.Integer("Hey! Roger the integer. Bye.");

		IEnumerable<String> heys = cluster.Keys(new QdbPrefixSelector("Hey!", 10));
		IEnumerable<String> byes = cluster.Keys(new QdbSuffixSelector("Bye.", 10));

	.. code-tab:: vbnet

		cluster.Blob("Hey! Bob the blob");
		cluster.Integer("Hey! Roger the integer");

		Dim heys = cluster.Keys(New QdbPrefixSelector("Hey!", 10))
		Dim byes = cluster.Keys(New QdbSuffixSelector("Bye.", 10))

See Also (References):
----------------------

Cluster
^^^^^^^

.. doxygenclass:: Quasardb::QdbCluster
	:project: qdb_dotnetapi
	:members:

Blobs
^^^^^

.. doxygenclass:: Quasardb::QdbBlob
	:project: qdb_dotnetapi
	:members:

Deque
^^^^^

.. doxygenclass:: Quasardb::QdbDeque
	:project: qdb_dotnetapi
	:members:

Integer
^^^^^^^

.. doxygenclass:: Quasardb::QdbInteger
	:project: qdb_dotnetapi
	:members:

Stream
^^^^^^

.. doxygenclass:: Quasardb::QdbStream
	:project: qdb_dotnetapi
	:members:

Tag
^^^

.. doxygenclass:: Quasardb::QdbTag
	:project: qdb_dotnetapi
	:members:

Entry
^^^^^

.. doxygenclass:: Quasardb::QdbEntry
	:project: qdb_dotnetapi
	:members:

PrefixSelector
^^^^^^^^^^^^^^

.. doxygenclass:: Quasardb::QdbPrefixSelector
	:project: qdb_dotnetapi
	:members:


SuffixSelector
^^^^^^^^^^^^^^

.. doxygenclass:: Quasardb::QdbSuffixSelector
	:project: qdb_dotnetapi
	:members:

Version-History
---------------

The topics in this section describe the various changes made to the Quasardb API for .NET over the
life of the project.

Version 2.1.0
^^^^^^^^^^^^^

This version requires quasardb server 2.1

Changes in the release:-

1. Added support for time series.

Version 2.0.0
^^^^^^^^^^^^^

This version requires quasardb server 2.0

Changes in This Release:-

 1. Supports the following entry types:

	 * blob

	 * deque

	 * hash set

	 * integer

	 * stream

	 * tag

 2. Supports for batches.
