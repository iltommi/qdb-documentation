Node.js
=======

.. default-domain:: js
.. highlight:: js

Quick Reference
---------------

 ================ ================================================== =====================================================================================
   Return type     Name                                               Arguments
 ================ ================================================== =====================================================================================
 <-QuickRef->
 ================ ================================================== =====================================================================================
Introduction
--------------

Using *quasardb* cluster from a Node.js installation is extremely straightforward, just create a `qdb.Cluster` and perform the operations. ::

    var qdb = require('./qdb');

    var c = new qdb.Cluster('qdb://127.0.0.1:2836');
    var b = c.blob('key 0');

    b.put(new Buffer('value 0'), function(err) {});
    b.get(new Buffer('key 0'), function(err, data) {
        console.log(data);
    });

You may download the Node.js API from the quasardb site or from GitHub at `https://github.com/bureau14/qdb-api-nodejs <https://github.com/bureau14/qdb-api-nodejs>`_.

Requirements and Installation
-----------------------------

To build the Node.js API, you will need the C API. It can either be installed on the machine (e.g. on Unix in ``/usr/lib`` or ``/usr/local/lib``) or you can unpack the C API archive in ``deps/qdb``.

You will need to have `node-gyp <https://github.com/nodejs/node-gyp>`_ installed.

In the directory run:

.. code-block:: shell

    npm install

You will then find a ``qdb.node`` file which is the quasardb add-on in ``build/Release`` directory.




Reference
---------

The `Entity` interface
^^^^^^^^^^^^^^^^^^^^^^

Entity is the base interface for all entry classes stored in quasardb.
All the classes inherit the following methods.

<:Entity:>

The `ExpirableEntity` interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Entity is the base interface for entry classes that may expire, i.e. be removed from the database automatically at some time point or after some time (duration).
ExpirableEntity is inherited by Blob and Integer.
These classes inherit the following methods.

<:ExpirableEntity:>

The `Blob` class
^^^^^^^^^^^^^^^^

Represents a blob in a quasardb database. Blob stands for Binary Large Object, meaning that you can store arbitrary data in this blob.

You get a ``Blob`` instance by calling :func:`Cluster.blob`. Then you can perform atomic operations on the blob::

    var b = c.blob('bam');

    b.put(new Buffer("boom"), function(err) { /* */  });
    b.get(function(err, data) { /* */  });

Passing in the blob value wrapped in the `node::Buffer class <https://nodejs.org/api/buffer.html>`_ is important, as JavaScript does not play nice with binary data.

<:Blob:>

The `Cluster` class
^^^^^^^^^^^^^^^^^^^

Represents a connection to a *quasardb* cluster.

Example::

    var qdb = require('./qdb');

    var c = new qdb.Cluster('qdb://127.0.0.1:2836');
    c.blob('key 0');
    c.deque('key 1');
    c.integer('key 2');
    c.integer('key 3');

<:Cluster:>

The `Deque` class
^^^^^^^^^^^^^^^^^

Represents a double-ended queue of blob in the quasardb database. You can both enqueue and dequeue from the front and the back.

You get a ``Deque`` instance by calling :func:`Cluster.deque`. Then you can perform atomic operations on the queue::

    var q = c.deque('q2');
    q.pushBack(new Buffer("boom"), function(err) { /* */ });
    q.popFront(function(err, data) { /* */ });
    q.pushFront(new Buffer("bang"), function(err) { /* */ });

Passing in the blob value wrapped in the `node::Buffer class <https://nodejs.org/api/buffer.html>`_ is important, as JavaScript does not play nice with binary data.

<:Deque:>

The `Error` class
^^^^^^^^^^^^^^^^^

quasardb callbacks return error messages. When the callback is successful, the error object is null. You may not want to throw at every error: some errors are transient and some are informational. You can check their types with the transient and informational methods.

Transient errors may resolve by themselves given time. Transient errors are commonly transaction conflicts, network timeouts, or an unstable cluster.

An informational error means that the query has been successfully processed by the server and your parameters were valid but the result is either empty or unavailable. Informational errors include non-existent entries, empty collections, indexes out of range, or integer overflow/underflows.

Example::

    var b = c.blob('bam');

    b.put(new Buffer("boom"), function(err)
    {
        if (err)
        {
            // error management
            throw error.message;
        }

        // ...
    });

<:Error:>

The `Integer` class
^^^^^^^^^^^^^^^^^^^

Represents an signed 64-bit integer in a quasardb database.

You get an ``Integer`` instance by calling :func:`Cluster.integer`. Then you can perform atomic operations on the integer::

    var i = c.integer('will_be_ten');
    i.put(3, function(err){ /* */});
    i.add(7, function(err, data){ /* */});

<:Integer:>

The `Set` class
^^^^^^^^^^^^^^^

Represents an unordered set of blob in the quasardb database.

You get a ``Set`` instance by calling func:`Cluster.set`. Then you can perform atomic operations on the set::

    var s = c.set('bam');
    s.insert(new Buffer("boom"), function(err, data) { /* */  });
    s.contains(new Buffer("boom"), function(err, data) { /* */  });

Passing in the blob value wrapped in the `node::Buffer class <https://nodejs.org/api/buffer.html>`_ is important, as JavaScript does not play nice with binary data.

<:Set:>

The `Tag` class
^^^^^^^^^^^^^^^

Represents a tag in a quasardb database. Any entry can be tagged, including other tags. Most tag functions are performed on the object itself::

    var b = c.blob('myBlob');

    b.put(new Buffer("boom"), function(err) { /* */  });
    b.attachTag('myTag', function(err) { /* */  });
    b.hasTag('myTag', function(err) { /* */ });
    b.getTags(function(err, tags) { /* */ });
    b.detachTag('myTag', function(err) { /* */ } );

You can create a ``Tag`` instance by calling :func:`Cluster.tag`. Then, you can look up entries by their association with the tag::

    var t = c.tag('myTag');

    t.getEntries(function(err, entries} { /* entries is the list of entries */ });

<:Tag:>