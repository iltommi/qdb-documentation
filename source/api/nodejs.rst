Node.js
=======

Quick Reference
---------------

 ================ ================================================== =====================================================================================
   Return type     Name                                               Arguments
 ================ ================================================== =====================================================================================
  ..               ``Entity::``:js:func:`remove`                      ``(callback(err))``
  ..               ``Entity::``:js:func:`addTag`                      ``(String tagName, callback(err))``
  ..               ``Entity::``:js:func:`addTags`                     ``(String[] tagNames, callback(err))``
  ..               ``Entity::``:js:func:`getTags`                     ``(callback(err, tags))``
  ..               ``Entity::``:js:func:`hasTag`                      ``(String tagName, callback(err))``
  ..               ``Entity::``:js:func:`hasTags`                     ``(String[] tagNames, callback(err, success_count, result))``
  ..               ``Entity::``:js:func:`removeTag`                   ``(String tagName, callback(err))``
  ..               ``Entity::``:js:func:`removeTags`                  ``(String[] tagNames, callback(err))``
  ..
  ..               ``ExpirableEntity::``:js:func:`expiresAt`          ``(Date expiry_time)``
  ..               ``ExpirableEntity::``:js:func:`expiresFromNow`     ``(int seconds)``
  Date             ``ExpirableEntity::``:js:func:`getExpiry`          ``()``
  ..
  String           ``Blob::``:js:attr:`alias`                         ``()``
  ..               ``Blob::``:js:func:`put`                           ``(Buffer content, [Date expiry_time], callback(err))``
  ..               ``Blob::``:js:func:`update`                        ``(Buffer content, [Date expiry_time], callback(err))``
  ..               ``Blob::``:js:func:`get`                           ``(callback(err, data))``
  ..
  Cluster          :js:class:`Cluster`                                ``(String uri)``
  Cluster          ``Cluster::``:js:func:`connect`                    ``(callback(), callback(err))``
  ..               ``Cluster::``:js:func:`setTimeout`                 ``(int milliseconds)``
  Blob             ``Cluster::``:js:func:`blob`                       ``(String alias)``
  Deque            ``Cluster::``:js:func:`deque`                      ``(String alias)``
  Integer          ``Cluster::``:js:func:`integer`                    ``(String alias)``
  Set              ``Cluster::``:js:func:`set`                        ``(String alias)``
  Tag              ``Cluster::``:js:func:`tag`                        ``(String tagName)``
  ..
  bool             ``Error::``:js:func:`informational`                ``()``
  bool             ``Error::``:js:func:`transient`                    ``()``
  String           ``Error::``:js:func:`message`                      ``()``
  int              ``Error::``:js:func:`code`                         ``()``
  ..
  String           ``Deque::``:js:attr:`alias`                        ``()``
  ..               ``Deque::``:js:func:`pushFront`                    ``(Buffer content, callback(err))``
  ..               ``Deque::``:js:func:`pushBack`                     ``(Buffer content, callback(err))``
  ..               ``Deque::``:js:func:`popFront`                     ``(callback(err, data))``
  ..               ``Deque::``:js:func:`popBack`                      ``(callback(err, data))``
  ..               ``Deque::``:js:func:`front`                        ``(callback(err, data))``
  ..               ``Deque::``:js:func:`back`                         ``(callback(err, data))``
  ..               ``Deque::``:js:func:`at`                           ``(index, callback(err, data))``
  ..               ``Deque::``:js:func:`size`                         ``(callback(err, size))``
  ..
  String           ``Integer::``:js:attr:`alias`                      ``()``
  ..               ``Integer::``:js:func:`put`                        ``(int value, [Date expiry_time], callback(err))``
  ..               ``Integer::``:js:func:`update`                     ``(int value, [Date expiry_time], callback(err))``
  ..               ``Integer::``:js:func:`get`                        ``(callback(err, data))``
  ..               ``Integer::``:js:func:`add`                        ``(int value, callback(err, data))``
  ..
  String           ``Set::``:js:attr:`alias`                          ``()``
  ..               ``Set::``:js:func:`insert`                         ``(Buffer value, callback(err, data))``
  ..               ``Set::``:js:func:`erase`                          ``(Buffer value, callback(err, data))``
  ..               ``Set::``:js:func:`contains`                       ``(Buffer value, callback(err, data))``
  ..
  String           ``Tag::``:js:attr:`alias`                          ``()``
  ..               ``Tag::``:js:func:`getEntries`                     ``(callback(err, entries))``

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

To build the Node.js API, you will need the C API. It can either be installed on the machine (e.g. on unix in /usr/lib or /usr/local/lib) or you can unpack the C API archive in deps/qdb.

You will need to have `node-gyp <https://github.com/nodejs/node-gyp>`_ installed.

In the directory run::

    npm install

You will then find a qdb.node file which is the quasardb addon in build/Release.


Reference
---------

The `Entity` class
^^^^^^^^^^^^^^^^^^

Entity is the base class for all entry classes stored in quasardb.
All the classes inherit the following interface.

.. js:class:: Entity

  .. js:function:: remove (callback(err))

      Removes the Entity from the cluster.

      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: addTag (String tagName, callback(err))

      Assigns the Entity to the specified tag. Errors if the tag is already assigned.

      :param String tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: addTags (String[] tagNames, callback(err))

      Assigns the Entity to the specified tags. Errors if any of the tags is already assigned.

      :param String[] tagNames: Array of names of the tags (Array of Strings).
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: getTags (callback(err, tags))

      Gets an array of tag objects associated with the Entity.

      :param function callback(err, tags): A callback or anonymous function with error and array of tags parameters.

  .. js:function:: hasTag (String tagName, callback(err))

      Determines if the Entity has the specified tag.

      :param String tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: hasTags (String[] tagNames, callback(err, success_count, result))

      Determines if the Entity has the specified tags.

      :param String[] tagNames: Array of names of the tags (Array of Strings).
      :param function callback(err, success_count, result): A callback or anonymous function with: error parameter, number of specified tags assigned to the Entity and query result.
        Result is an Object with as many fields as the length of ``tagNames`` array, each having a ``bool`` value ``true`` (tag assigned) or ``false`` (otherwise).

  .. js:function:: removeTag (String tagName, callback(err))

      Removes the Entity from the specified tag. Errors if the tag is not assigned.

      :param String tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: removeTags (String[] tagNames, callback(err))

      Removes the Entity from the specified tags. Errors if any of the tags is not assigned.

      :param String[] tagNames: Array of names of the tags (Array of Strings).
      :param function callback(err): A callback or anonymous function with error parameter.

The `ExpirableEntity` class
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Entity is the base class for entry classes that may expire, i.e. be removed from the database automatically at some time point or after some time (duration).
ExpirableEntity is inherited by Blob and Integer.
These classes inherit the following interface.

.. js:class:: ExpirableEntity

  .. js:function:: expiresAt (Date expiry_time)

      Sets the expiration time for the ExpirableEntity at a given Date.

      :param Date expiry_time: A Date at which the ExpirableEntity expires.

  .. js:function:: expiresFromNow (int seconds)

      Sets the expiration time for the ExpirableEntity as a number of seconds from call time.

      :param int seconds: A number of seconds from call time at which the ExpirableEntity expires.

  .. js:function:: getExpiry ()

      Gets the expiration time of the ExpirableEntity. A return Date of Jan 1, 1970 means the ExpirableEntity does not expire.

      :returns: A Date object with the expiration time.

The `Blob` class
^^^^^^^^^^^^^^^^

Represents a blob in a quasardb database. Blob stands for Binary Large Object, meaning that you can store arbitrary data in this blob.

You get a Blob instance by calling ```cluster.blob('alias')```. Then you can perform atomic operations on the blob::

    var b = c.blob('bam');

    b.put(new Buffer("boom"), function(err) { /* */  });
    b.get(function(err, data) { /* */  });

Passing in the blob value wrapped in the `node::Buffer class <https://nodejs.org/api/all.html#all_buffer>`_ is important, as JavaScript does not play nice with binary data.

.. js:class:: Blob

  .. js:attribute:: alias

      Gets the alias (i.e. its "key") of the blob in the database.

      :returns: A string representing the blob's key.

  .. js:function:: put (Buffer content, [Date expiry_time], callback(err))

      Sets blob's content but fails if the blob already exists. See also update().

      Aliases beginning with "qdb" are reserved and cannot be used.

      :param Buffer content: A string representing the blob's content to be set.
      :param Date expiry_time: An optional Date with the absolute time at which the entry should expire.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: update (Buffer content, [Date expiry_time], callback(err))

      Updates the content of the blob.

      Aliases beginning with "qdb" are reserved and cannot be used. See also put().

      :param Buffer content: A Buffer representing the blob’s content to be added.
      :param Date expiry_time: An optional Date with the absolute time at which the entry should expire.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: get (callback(err, data))

      Retrieves the blob's content, passes to callback as data.

      :param function callback(err, data): A callback or anonymous function with error and data parameters.


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

.. js:class:: Cluster(uri)

  Creates a quasardb cluster object with the specified URI. The URI contains the addresses of the bootstrapping nodes, other nodes are discovered during the first connection. Having more than one node in the URI allows to connect to the cluster even if the first node is down. ::

    var c = new qdb.Cluster('qdb://192.168.0.100:2836,192.168.0.101:2836');

  :param String uri: A string having the format ``qdb://host:port[,host:port]``.

  .. js:function:: connect (callback(), callback_on_failure(err))

    Connects to a quasardb cluster. The successful function is run when the connection is made. The failure callback is called for major errors such as disconnections from the cluster after the connection is successful::

      c.connect(on_connect_success(), on_connect_failure(err));

    :param function callback(): A callback or anonymous function without parameters.
    :param function callback_on_failure(err): A callback or anonymous function with error parameter.

  .. js:function:: setTimeout (int milliseconds)

      Sets the client-side timeout value for callbacks. The default is 60,000ms, or one minute. This should be run before the call to Cluster::connect.

      :param int milliseconds: the number of milliseconds to set.

  .. js:function:: blob (String alias)

      Creates a Blob associated with the specified alias. No query is performed at this point.

      :param String alias: the alias of the blob in the database.
      :returns: the Blob

  .. js:function:: integer (String alias)

      Creates an Integer associated with the specified alias. No query is performed at this point.

      :param String alias: the alias of the integer in the database.
      :returns: the Integer

  .. js:function:: deque (String alias)

      Creates a Deque associated with the specified alias. No query is performed at this point.

      :param String alias: the alias of the deque in the database.
      :returns: the Deque

  .. js:function:: set (String alias)

      Creates a Set associated with the specified alias. No query is performed at this point.

      :param String alias: the alias of the set in the database.
      :returns: the Set

  .. js:function:: tag (String tagName)

      Creates a Tag with the specified name.

      :param String tagName: the name of the tag in the database.
      :returns: the Tag


The `Deque` class
^^^^^^^^^^^^^^^^^

Represents a double-ended queue of blob in the quasardb database. You can both enqueue and dequeue from the front and the back.

You get a qdb.Deque instance by calling QdbCluster::deque(). Then you can perform atomic operations on the queue::

    var q = c.deque('q2');
    q.pushBack(new Buffer("boom"), function(err) { /* */ });
    q.popFront(function(err, data) { /* */ });
    q.pushFront(new Buffer("bang"), function(err) { /* */ });

Passing in the blob value wrapped in the `node::Buffer class <https://nodejs.org/api/all.html#all_buffer>`_ is important, as Javascript does not play nice with binary data.

.. js:class:: Deque

  .. js:attribute:: alias

      Gets the alias (i.e. its "key") of the queue in the database.

      :returns: A string with the alias of the queue.

  .. js:function:: pushFront (Buffer content, callback(err))

      Add a value to the front of the queue.

      :param Buffer content: The value to add to the queue.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: pushBack (Buffer content, callback(err))

      Add a value to the back of the queue.

      :param Buffer content: The value to add to the queue.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: popFront (callback(err, data))

      Remove the value at the front of the queue and return it.

      :param function callback(err, data): A callback or anonymous function with error and data parameters.

  .. js:function:: popBack (callback(err, data))

      Remove the value at the end of the queue and return it.

      :param function callback(err, data): A callback or anonymous function with error and data parameters.

  .. js:function:: front (callback(err, data))

      Retrieves the value at the front of the queue, without removing it.

      :param function callback(err, data): A callback or anonymous function with error and data parameters.

  .. js:function:: back (callback(err, data))

      Retrieves the value at the end of the queue, without removing it.

      :param function callback(err, data): A callback or anonymous function with error and data parameters.

  .. js:function:: at (index, callback(err, data))

      Retrieves the value at the index in the queue. The item at the index must exist or it will throw an error.

      :param index: The index of the object in the Deque.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.

  .. js:function:: size (callback(err, size))

      Returns the size of the Deque.

      :param function callback(err, size): A callback or anonymous function with error and size parameters.

The `Error` class
^^^^^^^^^^^^^^^^^

Quasardb callbacks return error messages. When the callback is successful, the error object is null. You may not want to throw at every error: some errors are transient and some are informational. You can check their types with the transient and informational methods.

Transient errors may resolve by themselves given time. Transient errors are commonly transaction conflicts, network timeouts, or an unstable cluster.

An informational error means that the query has been succesfully processed by the server and your parameters were valid but the result is either empty or unavailable. Informational errors include non-existent entries, empty collections, indexes out of range, or integer overflow/underflows.

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

.. js:class:: Error

  .. js:function:: informational ()

      Determines if the error is an informational error.

      :returns: True if the error is informational, false otherwise.

  .. js:function:: transient ()

        Determines if the error is a transient error.

      :returns: True if the error is transient, false otherwise.

  .. js:function:: message ()

      Gets a description of the error.

      :returns: A string containing the error message.

  .. js:function:: code ()

      Gets the error code.

      :returns: An integer with the error code.


The `Integer` class
^^^^^^^^^^^^^^^^^^^

Represents an signed 64-bit integer in a quasardb database.

You get a qdb.Integer instance by calling cluster.integer(). Then you can perform atomic operations on the integer::

    var i = c.integer('will_be_ten');
    i.put(3, function(err){ /* */});
    i.add(7, function(err, data){ /* */});

.. js:class:: Integer

  .. js:attribute:: alias

      Gets the alias (i.e. its "key") of the set in the database.

      :returns: A string with the alias of the integer.

  .. js:function:: put (int value, [Date expiry_time], callback(err))

      Adds an entry. Aliases beginning with "qdb" are reserved and cannot be used.

      :param int value: The value of the integer.
      :param Date expiry_time: An optional Date with the absolute time at which the entry should expire.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: update (int value, [Date expiry_time], callback(err))

      Updates an entry. Aliases beginning with "qdb" are reserved and cannot be used.

      :param int value: The value of the integer.
      :param Date expiry_time: An optional Date with the absolute time at which the entry should expire.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: get (callback(err, data))

      Retrieves an entry's value.

      :param function callback(err, data): A callback or anonymous function with error and data parameters.

  .. js:function:: add (int value, callback(err, data))

      Atomically increment the value in the database.

      :param int value: The value to add to the value in the database.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.

The `Set` class
^^^^^^^^^^^^^^^

Represents an unordered set of blob in the quasardb database.

You get a Set instance by calling ```cluster.set('alias')```. Then you can perform atomic operations on the set::

    var s = c.set('bam');
    s.insert(new Buffer("boom"), function(err, data) { /* */  });
    s.contains(new Buffer("boom"), function(err, data) { /* */  });

Passing in the blob value wrapped in the `node::Buffer class <https://nodejs.org/api/all.html#all_buffer>`_ is important, as Javascript does not play nice with binary data.

.. js:class:: Set

  .. js:attribute:: alias

      Gets the alias (i.e. its "key") of the set in the database.

      :returns: A string with the alias of the Set.

  .. js:function:: insert (Buffer value, callback(err, data))

      Adds the specified value to the set.

      :param Buffer value: the value to add to the Set.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
      :returns: true if the value was added, false if it was already present in the set.

  .. js:function:: erase (Buffer value, callback(err, data))

      Removes the value from the set.

      :param Buffer value: the value to remove from the Set.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.

  .. js:function:: contains (Buffer value, callback(err, data))

      Determines if the value is present in the set.

      :param Buffer value: the value to look for in the Set.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.

The `Tag` class
^^^^^^^^^^^^^^^

Represents a tag in a quasardb database. Any entry can be tagged, including other tags. Most tag functions are performed on the object itself::

    var b = c.blob('myBlob');

    b.put(new Buffer("boom"), function(err) { /* */  });
    b.addTag('myTag', function(err) { /* */  });
    b.hasTag('myTag', function(err) { /* */ });
    b.getTags(function(err, tags) { /* */ });
    b.removeTag('myTag', function(err) { /* */ } );


You can create a Tag instance by calling ```cluster.tag('tagName')```. Then, you can look up entries by their association with the tag::

    var t = c.tag('myTag');

    t.getEntries(function(err, entries} { /* entries is the list of entries */ });


.. js:class:: Tag

  .. js:attribute:: alias

      Gets the alias (i.e. its "name" or "key") of the tag in the database.

      :returns: A string with the alias of the Tag.

  .. js:function:: getEntries (callback(err, entities))

      Gets an array of entities associated with the Tag.

      :param function callback(err, entities): A callback or anonymous function with error and array of entities parameters.


