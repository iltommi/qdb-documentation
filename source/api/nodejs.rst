NodeJS
======

Quick Reference
---------------

 ================ ============================================ =====================================================================================
   Return Type     Name                                         Arguments                                                                       
 ================ ============================================ =====================================================================================
  string           :js:attr:`Blob::alias`                       ()
  ..               :js:func:`Blob::get`                         (callback(err, data))
  ..               :js:func:`Blob::put`                         (Buffer content, callback(err, data))
  ..               :js:func:`Blob::remove`                      (callback(err, data))
  ..               :js:func:`Blob::update`                      (Buffer content, callback(err, data))
  Cluster          :js:func:`Cluster::new`                      (string uri)
  Blob             :js:func:`Cluster::blob`                     (string alias)
  Set              :js:func:`Cluster::hashSet`                  (string alias)
  Integer          :js:func:`Cluster::integer`                  (string alias)
  Queue            :js:func:`Cluster::queue`                    (string alias)
  string           :js:attr:`Set::alias`                        ()
  ..               :js:func:`Set::contains`                     (Buffer value, callback(err, data))
  ..               :js:func:`Set::erase`                        (Buffer value, callback(err, data))
  ..               :js:func:`Set::insert`                       (Buffer value, callback(err, data))
  ..               :js:func:`Integer::add`                      (int value, callback(err, data))
  string           :js:attr:`Integer::alias`                    ()
  ..               :js:func:`Integer::get`                      (callback(err, data))
  ..               :js:func:`Integer::put`                      (int value, callback(err, data))
  ..               :js:func:`Integer::remove`                   (callback(err, data))
  ..               :js:func:`Integer::update`                   (int value, callback(err, data))
  string           :js:attr:`Queue::alias`                      ()
  ..               :js:func:`Queue::back`                       (callback(err, data))
  ..               :js:func:`Queue::front`                      (callback(err, data))
  ..               :js:func:`Queue::popBack`                    (callback(err, data))
  ..               :js:func:`Queue::popFront`                   (callback(err, data))
  ..               :js:func:`Queue::pushBack`                   (Buffer content, callback(err, data))
  ..               :js:func:`Queue::pushFront`                  (Buffer content, callback(err, data))

 ================ ============================================ =====================================================================================


Introduction
--------------

Using *quasardb* cluster from a NodeJS installation is extremely straightforward, just create a `qdb.Cluster` and perform the operations. ::
    
    var qdb = require('./qdb');

    var c = new qdb.Cluster('qdb://127.0.0.1:2836');
    var b = c.blob('key 0');
    
    b.put(new Buffer('value 0'), function(err, data) {});
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
    
    b.put(new Buffer("boom"), function(err, data) { /* */  });
    b.get(function(err, data) { /* */  });
    
Passing in the blob value wrapped in the `node::Buffer class <https://nodejs.org/api/all.html#all_buffer>`_ is important, as Javascript does not play nice with binary data.

.. js:class:: Blob
  
  .. js:attribute:: alias
      
      Gets the alias (i.e. its "key") of the blob in the database.
      
      :returns: A string representing the blob's key.  
  
  .. js:function:: get (callback(err, data))
      
      Retrieves the blob's content, passes to callback as data.
      
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: put (Buffer content, callback(err, data))
      
      Sets blob's content but fails if the blob already exists. See also update().
      
      Aliases beginning with "qdb" are reserved and cannot be used.
      
      :param Buffer content: a string representing the blob's content to be set.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: remove (callback(err, data))
      
      Removes the blob from the cluster.
      
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: update (Buffer content, callback(err, data))
      
      Updates the content of the blob.
      
      Aliases beginning with "qdb" are reserved and cannot be used. See also put().
      
      :param Buffer content: a Buffer representing the blob’s content to be added.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.


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
      
  .. js:function:: set (string alias)
      
      Creates a Set associated with the specified alias. No query is performed at this point.
      
      :param string alias: the alias of the set in the database.
      :returns: the Set
  
  .. js:function:: integer (string alias)
      
      Creates a Integer associated with the specified alias. No query is performed at this point.
      
      :param string alias: the alias of the integer in the database.
      :returns: the Integer
  
  .. js:function:: queue (string alias)
      
      Creates a Queue associated with the specified alias. No query is performed at this point.
      
      :param string alias: the alias of the queue in the database.
      :returns: the Queue



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
  
  .. js:function:: contains (Buffer value, callback(err, data))
      
      Determines if the value is present in the set.
      
      :param Buffer value: the value to look for in the Set.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: erase (Buffer value, callback(err, data))
      
      Removes the value from the set.
      
      :param Buffer value: the value to remove from the Set.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: insert (string value)
      
      Adds the specified value to the set.
      
      :param Buffer value: the value to add to the Set.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
      :returns: true if the value was added, false if it was already present in the set.


The `Integer` class
^^^^^^^^^^^^^^^^^^^

Represents an signed 64-bit integer in a quasardb database.

You get a qdb.Integer instance by calling cluster.integer(). Then you can perform atomic operations on the integer::
    
    var i = c.integer('will_be_ten');
    i.put(3, function(err, data){ /* */});
    i.add(7, function(err, data){ /* */});

.. js:class:: Integer
  
  .. js:function:: add (int value, callback(err, data))
      
      Atomically increment the value in the database.
      
      :param int value: The value to add to the value in the database.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:attribute:: alias
      
      Gets the alias (i.e. its "key") of the set in the database.
      
      :returns: A string with the alias of the integer.
  
  .. js:function:: get (callback(err, data))
      
      Retrieves an entry's value.
      
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: put (int value, callback(err, data))
      
      Adds an entry. Aliases beginning with "qdb" are reserved and cannot be used.

      :param int value: The value of the integer.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: remove (callback(err, data))
      
      Removes the integer from the database.
      
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: update (int value, callback(err, data))
      
      Updates an entry. Aliases beginning with "qdb" are reserved and cannot be used.
      
      :param int value: The value of the integer.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.


The `Queue` class
^^^^^^^^^^^^^^^^^

Represents a queue of blob in the quasardb database. It's a double-ended queue, you can both enqueue and dequeue from the front and the back.

You get a qdb.Queue instance by calling QdbCluster::queue(). Then you can perform atomic operations on the queue::
    
    var q = c.queue('q2');
    q.pushBack(new Buffer("boom"), function(err, data) { /* */ });
    q.popFront(function(err, data) { /* */ });
    q.pushFront(new Buffer("bang"), function(err, data) { /* */ });

Passing in the blob value wrapped in the `node::Buffer class <https://nodejs.org/api/all.html#all_buffer>`_ is important, as Javascript does not play nice with binary data.

.. js:class:: Queue
  
  .. js:attribute:: alias
      
      Gets the alias (i.e. its "key") of the queue in the database.
      
      :returns: A string with the alias of the queue.
  
  .. js:function:: front (callback(err, data))
      
      Retrieves the value at the front of the queue, without removing it.
      
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: back (callback(err, data))
      
      Retrieves the value at the end of the queue, without removing it.
      
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: popBack (callback(err, data))
      
      Remove the value at the end of the queue and return it.
      
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: popFront (callback(err, data))
      
      Remove the value at the front of the queue and return it.
      
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: pushBack (Buffer content, callback(err, data))
      
      Add a value to the back of the queue.
      
      :param string content: The value to add to the queue.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.
  
  .. js:function:: pushFront (Buffer content, callback(err, data))
      
      Add a value to the front of the queue.
      
      :param string content: The value to add to the queue.
      :param function callback(err, data): A callback or anonymous function with error and data parameters.

