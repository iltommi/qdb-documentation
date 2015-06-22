NodeJS
======

Quick Reference
---------------

 ================ ============================================ =====================================================================================
   Return Type     Name                                         Arguments                                                                       
 ================ ============================================ =====================================================================================
  string           :js:attr:`Blob::alias`                       ()
  ..               :js:func:`Blob::put`                         (Buffer content, callback(err))
  ..               :js:func:`Blob::update`                      (Buffer content, callback(err))
  ..               :js:func:`Blob::get`                         (callback(err, data))
  ..               :js:func:`Blob::remove`                      (callback(err))
  ..               :js:func:`Blob::addTag`                      (string tagName, callback(err))
  ..               :js:func:`Blob::removeTag`                   (string tagName, callback(err))
  ..               :js:func:`Blob::hasTag`                      (string tagName, callback(err))
  ..               :js:func:`Blob::getTags`                     (callback(err, tags))
  Cluster          :js:func:`Cluster::new`                      (string uri)
  Blob             :js:func:`Cluster::blob`                     (string alias)
  Set              :js:func:`Cluster::hashSet`                  (string alias)
  Integer          :js:func:`Cluster::integer`                  (string alias)
  Queue            :js:func:`Cluster::queue`                    (string alias)
  Tag              :js:func:`Cluster::tag`                      (string tagName)
  string           :js:attr:`Integer::alias`                    ()
  ..               :js:func:`Integer::put`                      (int value, callback(err))
  ..               :js:func:`Integer::update`                   (int value, callback(err))
  ..               :js:func:`Integer::get`                      (callback(err, data))
  ..               :js:func:`Integer::remove`                   (callback(err))
  ..               :js:func:`Integer::add`                      (int value, callback(err, data))
  ..               :js:func:`Integer::addTag`                   (string tagName, callback(err))
  ..               :js:func:`Integer::removeTag`                (string tagName, callback(err))
  ..               :js:func:`Integer::hasTag`                   (string tagName, callback(err))
  ..               :js:func:`Integer::getTags`                  (callback(err, tags))
  string           :js:attr:`Queue::alias`                      ()
  ..               :js:func:`Queue::pushFront`                  (Buffer content, callback(err))
  ..               :js:func:`Queue::pushBack`                   (Buffer content, callback(err))
  ..               :js:func:`Queue::popFront`                   (callback(err, data))
  ..               :js:func:`Queue::popBack`                    (callback(err, data))
  ..               :js:func:`Queue::front`                      (callback(err, data))
  ..               :js:func:`Queue::back`                       (callback(err, data))
  ..               :js:func:`Queue::remove`                     (callback(err))
  ..               :js:func:`Queue::addTag`                     (string tagName, callback(err))
  ..               :js:func:`Queue::removeTag`                  (string tagName, callback(err))
  ..               :js:func:`Queue::hasTag`                     (string tagName, callback(err))
  ..               :js:func:`Queue::getTags`                    (callback(err, tags))
  string           :js:attr:`Set::alias`                        ()
  ..               :js:func:`Set::insert`                       (Buffer value, callback(err, data))
  ..               :js:func:`Set::erase`                        (Buffer value, callback(err, data))
  ..               :js:func:`Set::contains`                     (Buffer value, callback(err, data))
  ..               :js:func:`Set::remove`                       (callback(err))
  ..               :js:func:`Set::addTag`                       (string tagName, callback(err))
  ..               :js:func:`Set::removeTag`                    (string tagName, callback(err))
  ..               :js:func:`Set::hasTag`                       (string tagName, callback(err))
  ..               :js:func:`Set::getTags`                      (callback(err, tags))
  string           :js:attr:`Tag::alias`                        ()
  ..               :js:func:`Tag::getEntries`                   (callback(err, entries))

 ================ ============================================ =====================================================================================


Introduction
--------------

Using *quasardb* cluster from a NodeJS installation is extremely straightforward, just create a `qdb.Cluster` and perform the operations. ::
    
    var qdb = require('./qdb');

    var c = new qdb.Cluster('qdb://127.0.0.1:2836');
    var b = c.blob('key 0');
    
    b.put(new Buffer('value 0'), function(err) {});
    b.get(new Buffer('key 0'), function(err, data) {
		console.log(data);
    });

You may download the NodeJS API from the quasardb site or from GitHub at `https://github.com/bureau14/qdb-api-nodejs <https://github.com/bureau14/qdb-api-nodejs>`_.

Requirements and Installation
-----------------------------

To build the nodejs API, you will need the C API. It can either be installed on the machine (e.g. on unix in /usr/lib or /usr/local/lib) or you can unpack the C API archive in deps/qdb.

You will need to have `node-gyp <https://github.com/TooTallNate/node-gyp>`_ installed.

In the directory run::

    npm install

You will then find a qdb.node file which is the quasardb addon in build/Release.


Reference
---------

The `Blob` class
^^^^^^^^^^^^^^^^

Represents a blob in a quasardb database. Blob stands for Binary Large Object, meaning that you can store arbitrary data in this blob.

You get a Blob instance by calling ```cluster.blob('alias')```. Then you can perform atomic operations on the blob::
    
    var b = c.blob('bam');
    
    b.put(new Buffer("boom"), function(err) { /* */  });
    b.get(function(err, data) { /* */  });
    
Passing in the blob value wrapped in the `node::Buffer class <https://nodejs.org/api/all.html#all_buffer>`_ is important, as Javascript does not play nice with binary data.

.. js:class:: Blob
  
  .. js:attribute:: alias
      
      Gets the alias (i.e. its "key") of the blob in the database.
      
      :returns: A string representing the blob's key.  
  
  .. js:function:: put (Buffer content, callback(err))
      
      Sets blob's content but fails if the blob already exists. See also update().
      
      Aliases beginning with "qdb" are reserved and cannot be used.
      
      :param Buffer content: a string representing the blob's content to be set.
      :param function callback(err): A callback or anonymous function with error parameter.
  
  .. js:function:: update (Buffer content, callback(err))
      
      Updates the content of the blob.
      
      Aliases beginning with "qdb" are reserved and cannot be used. See also put().
      
      :param Buffer content: a Buffer representing the blob’s content to be added.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: get (callback(err, data))
      
      Retrieves the blob's content, passes to callback as data.
      
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: remove (callback(err))
      
      Removes the blob from the cluster.
      
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: addTag (string tagName, callback(err))
      
      Assigns the Blob to the specified tag.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: removeTag (string tagName, callback(err))
      
      Removes the Blob from the specified tag. Errors if the tag is not assigned.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: hasTag (string tagName, callback(err))
      
      Determines if the Blob has the specified tag.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: getTags (callback(err, tags))
      
      Gets an array of tag objects associated with the Blob.
      
      :param function callback(err, tags): A callback or anonymous function with error and array of tags parameters.


The `Cluster` class
^^^^^^^^^^^^^^^^^^^

Represents a connection to a *quasardb* cluster.

Example::

    var qdb = require('./qdb');

    var c = new qdb.Cluster('qdb://127.0.0.1:2836');
    c.blob('key 0');
    c.queue('key 1');
    c.integer('key 2');
    c.integer('key 3');

.. js:class:: Cluster
  
  .. js:function:: New (uri)
      
      Connects to a quasardb cluster through the specified URI. The URI contains the addresses of the bootstraping nodes, other nodes are discovered during the first connection. Having more than one node in the URI allows to connect to the cluster even if the first node is down. ::
          
          var c = new qdb.Cluster('qdb://192.168.0.100:2836,192.168.0.101:2836');
          
      :param string uri: A string in the format "qdb://host:port[,host:port]".
  
  .. js:function:: blob (string alias)
      
      Creates a Blob associated with the specified alias. No query is performed at this point.
      
      :param string alias: the alias of the blob in the database.
      :returns: the Blob
      
  .. js:function:: integer (string alias)
      
      Creates a Integer associated with the specified alias. No query is performed at this point.
      
      :param string alias: the alias of the integer in the database.
      :returns: the Integer
  
  .. js:function:: queue (string alias)
      
      Creates a Queue associated with the specified alias. No query is performed at this point.
      
      :param string alias: the alias of the queue in the database.
      :returns: the Queue

  .. js:function:: set (string alias)
      
      Creates a Set associated with the specified alias. No query is performed at this point.
      
      :param string alias: the alias of the set in the database.
      :returns: the Set
  
  .. js:function:: tag (string tagName)
      
      Creates a Tag with the specified name.
      
      :param string tagName: the name of the tag in the database.
      :returns: the Tag


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
  
  .. js:function:: put (int value, callback(err))
      
      Adds an entry. Aliases beginning with "qdb" are reserved and cannot be used.

      :param int value: The value of the integer.
      :param function callback(err): A callback or anonymous function with error parameter.
  
  .. js:function:: update (int value, callback(err))
      
      Updates an entry. Aliases beginning with "qdb" are reserved and cannot be used.
      
      :param int value: The value of the integer.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: get (callback(err, data))
      
      Retrieves an entry's value.
      
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: remove (callback(err))
      
      Removes the integer from the database.
      
      :param function callback(err): A callback or anonymous function with error parameter.
  
  .. js:function:: add (int value, callback(err, data))
      
      Atomically increment the value in the database.
      
      :param int value: The value to add to the value in the database.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: addTag (string tagName, callback(err))
      
      Assigns the Integer to the specified tag.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: removeTag (string tagName, callback(err))
      
      Removes the Integer from the specified tag. Errors if the tag is not assigned.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: hasTag (string tagName, callback(err))
      
      Determines if the Integer has the specified tag.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: getTags (callback(err, tags))
      
      Gets an array of tag objects associated with the Integer.
      
      :param function callback(err, tags): A callback or anonymous function with error and array of tags parameters.


The `Queue` class
^^^^^^^^^^^^^^^^^

Represents a queue of blob in the quasardb database. It's a double-ended queue, you can both enqueue and dequeue from the front and the back.

You get a qdb.Queue instance by calling QdbCluster::queue(). Then you can perform atomic operations on the queue::
    
    var q = c.queue('q2');
    q.pushBack(new Buffer("boom"), function(err) { /* */ });
    q.popFront(function(err, data) { /* */ });
    q.pushFront(new Buffer("bang"), function(err) { /* */ });

Passing in the blob value wrapped in the `node::Buffer class <https://nodejs.org/api/all.html#all_buffer>`_ is important, as Javascript does not play nice with binary data.

.. js:class:: Queue
  
  .. js:attribute:: alias
      
      Gets the alias (i.e. its "key") of the queue in the database.
      
      :returns: A string with the alias of the queue.
  
  .. js:function:: pushFront (Buffer content, callback(err))
      
      Add a value to the front of the queue.
      
      :param string content: The value to add to the queue.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: pushBack (Buffer content, callback(err))
      
      Add a value to the back of the queue.
      
      :param string content: The value to add to the queue.
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
  
  .. js:function:: addTag (string tagName, callback(err))
      
      Assigns the Queue to the specified tag.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: removeTag (string tagName, callback(err))
      
      Removes the Queue from the specified tag. Errors if the tag is not assigned.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: hasTag (string tagName, callback(err))
      
      Determines if the Queue has the specified tag.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: getTags (callback(err, tags))
      
      Gets an array of tag objects associated with the Queue.
      
      :param function callback(err, tags): A callback or anonymous function with error and array of tags parameters.
  

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

  .. js:function:: addTag (string tagName, callback(err))
      
      Assigns the Set to the specified tag.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: removeTag (string tagName, callback(err))
      
      Removes the Set from the specified tag. Errors if the tag is not assigned.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: hasTag (string tagName, callback(err))
      
      Determines if the Set has the specified tag.
      
      :param string tagName: The name of the tag.
      :param function callback(err): A callback or anonymous function with error parameter.

  .. js:function:: getTags (callback(err, tags))
      
      Gets an array of tag objects associated with the Set.
      
      :param function callback(err, tags): A callback or anonymous function with error and array of tags parameters.


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
  
  .. js:function:: getEntities (callback(err, entities))
      
      Gets an array of entities associated with the Tag.
      
      :param function callback(err, entities): A callback or anonymous function with error and array of entities parameters.


