PHP
====

Quick Reference
---------------

 ================ ============================================ =====================================================================================
   Return Type     Name                                         Arguments                                                                       
 ================ ============================================ =====================================================================================
  QdbBatch         :php:meth:`QdbBatch::__construct`            (void)
  void             :php:meth:`QdbBatch::compareAndSwap`         (string $alias, string $new_content, string $comparand [, int $expiry_time = 0 ])
  void             :php:meth:`QdbBatch::get`                    (string $alias)
  void             :php:meth:`QdbBatch::getAndRemove`           (string $alias)
  void             :php:meth:`QdbBatch::getAndUpdate`           (string $alias, string $content [, int $expiry_time = 0 ])
  void             :php:meth:`QdbBatch::put`                    (string $alias, string $content [, int $expiry_time = 0 ])
  void             :php:meth:`QdbBatch::remove`                 (string $alias)
  void             :php:meth:`QdbBatch::removeIf`               (string $alias, string $comparand)
  void             :php:meth:`QdbBatch::update`                 (string $alias, string $content [, int $expiry_time = 0 ])
  string           :php:meth:`QdbBlob::alias`                   (void)
  string           :php:meth:`QdbBlob::compareAndSwap`          (string $new_content, string $comparand [, int $expiry_time = 0 ])
  void             :php:meth:`QdbBlob::expiresAt`               (int $expiry_time)
  void             :php:meth:`QdbBlob::expiresFromNow`          (int $time_delta)
  string           :php:meth:`QdbBlob::get`                     (void)
  string           :php:meth:`QdbBlob::getAndRemove`            (void)
  string           :php:meth:`QdbBlob::getAndUpdate`            (string $content [, int $expiry_time = 0 ])
  int              :php:meth:`QdbBlob::getExpiryTime`           (void)
  void             :php:meth:`QdbBlob::put`                     (string $content [, int $expiry_time = 0 ])
  void             :php:meth:`QdbBlob::remove`                  (void)
  bool             :php:meth:`QdbBlob::removeIf`                (string $comparand)
  void             :php:meth:`QdbBlob::update`                  (string $content [, int $expiry_time = 0 ])
  QdbCluster       :php:meth:`QdbCluster::__construct`          (string $uri)
  QdbBlob          :php:meth:`QdbCluster::blob`                 (string $alias)
  QdbHashSet       :php:meth:`QdbCluster::hashSet`              (string $alias)
  QdbInteger       :php:meth:`QdbCluster::integer`              (string $alias)
  QdbQueue         :php:meth:`QdbCluster::queue`                (string $alias)
  array            :php:meth:`QdbCluster::runBatch`             (QdbBatch $batch)
  string           :php:meth:`QdbHashSet::alias`                (void)
  bool             :php:meth:`QdbHashSet::contains`             (string $value)
  bool             :php:meth:`QdbHashSet::erase`                (string $value)
  bool             :php:meth:`QdbHashSet::insert`               (string $value)
  void             :php:meth:`QdbInteger::add`                  (int $value)
  string           :php:meth:`QdbInteger::alias`                (void)
  void             :php:meth:`QdbInteger::expiresAt`            (int $expiry_time)
  void             :php:meth:`QdbInteger::expiresFromNow`       (int $time_delta)
  int              :php:meth:`QdbInteger::get`                  (void)
  int              :php:meth:`QdbInteger::getExpiryTime`        (void)
  void             :php:meth:`QdbInteger::put`                  (int $value [, int $expiry_time = 0 ])
  void             :php:meth:`QdbInteger::remove`               (void)
  void             :php:meth:`QdbInteger::update`               (int $value [, int $expiry_time = 0 ])
  string           :php:meth:`QdbQueue::alias`                  (void)
  string           :php:meth:`QdbQueue::popBack`                (void)
  string           :php:meth:`QdbQueue::popFront`               (void)
  string           :php:meth:`QdbQueue::pushBack`               (string $content)
  string           :php:meth:`QdbQueue::pushFront`              (string $content)

 ================ ============================================ =====================================================================================


Introduction
--------------

Using *quasardb* cluster from a PHP program is extremely straightforward, just create a `QdbCluster` and perform the operations. ::
    
    $cluster = new QdbCluster('qdb://192.168.0.100:2836,192.168.0.101:2836');
    $cluster->put('key 0', 'value 0');
    $cluster->put('key 1', 'value 1');
    $value2 = $cluster->get('key 2');

Not fast enough? Try the `QdbBatch` class::

    $batch = new QdbBatch();
    $batch->put('key 0', 'value 0');
    $batch->put('key 1', 'value 1');
    $batch->get('key 2');
    
    $result = $cluster->runBatch($batch);
    
    $value2 = $result[2];

This will reduce the number of network request and it will be faster by orders of magnitudes.

You may download the PHP API from the quasardb site or from GitHub at `https://github.com/bureau14/qdb-api-php <https://github.com/bureau14/qdb-api-php>`_.

Requirements and Installation
-----------------------------

Linux
^^^^^

The example below assumes the following:
 #. `php` and `php-devel` are installed
 #. `qdb-capi` is installed in `/path/to/qdb_capi`
 #. `qdb-php-api.tar.gz` has been downloaded

Please adapt to your configuration.

**Instructions**::

    tar xvf qdb-php-api.tar.gz
    cd qdb-php-api
    phpize
    ./configure --with-qdb=/path/to/qdb_capi
    make
    make install    


Windows
^^^^^^^

The example below assumes the following:
 #. Visual Studio is installed
 #. `PHP source code <http://windows.php.net/download/>`_ is decompressed in 'C:\\php-src\\'
 #. 'qdb-capi' is installed in 'C:\\qdb-capi\\'
 #. 'qdb-php-api.tar.gz' has been decompressed in 'C:\\php-src\\ext\\qdb\\'

Please adapt to your configuration.

**Instructions**
 #. If 'qdb_api.dll' is not available on the 'PATH', copy it to 'C:\\php\\'. 
 #. Open a *Visual Studio Developer Command Prompt* (either x86 or x64).
 #. Type::
    
        cd /d C:\php-src\
        buildconf
        configure --with-qdb=C:\qdb-capi
        nmake
        nmake install
    
    You may want to customize configure's flags, for instance '--enable-zts' or '--disable-zts' to control thread-safety.


Runtime configuration
---------------------

The following settings can be changed in `php.ini`:

 * **qdb.log_level** - Specifies the log verbosity. Allowed values are `detailed`, `debug`, `info`, `warning`, `error`, `panic`. The default is `panic`.




Reference
---------

The `QdbBatch` class
^^^^^^^^^^^^^^^^^^^^

Represents a collection of operations that can be executed with a single query.

Operations are executed by a call to `QdbCluster::runBatch ($batch)`

Example::

    $batch = new QdbBatch();
    $batch->put('key 0', 'value 0');
    $batch->put('key 1', 'value 1');
    $batch->get('key 2');
    
    $result = $cluster->runBatch($batch);
    
    $value2 = $result[2];
    

.. php:class:: QdbBatch

  .. php:method:: __construct (void)

      Creates an empty batch, i.e. an empty collection of operations. Batch operations can greatly increase performance when it is necessary to run many small operations.
      
      Operations in a QdbBatch are not executed until :php:meth:`QdbCluster::runBatch` is called.
      
      :returns: An empty QdbBatch collection.


  .. php:method:: compareAndSwap (string $alias, string $new_content, string $comparand [, int $expiry_time = 0 ])
  
      Adds a "compare and swap" operation to the batch. When executed, the "compare and swap" operation atomically compares the entry with `$comparand` and updates it to `$new_content` if, and only if, they match. If the entry does not exist, a `QdbAliasNotFoundException` will be thrown when reading the value.
      
      :param string $alias: A string representing the entry's alias to compare to.
      :param string $new_content: A string representing the entry’s content to be updated in case of match.
      :param string $comparand: A string representing the entry’s content to be compared to.
      :param int $expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch.
      :returns: The original value of the entry is stored in the array returned by :php:meth:`QdbCluster::runBatch`.


  .. php:method:: get (string $alias)
      
      Adds a "get" operation to the batch. When executed, the "get" operation retrieves an entry's content.
      
      If the entry does not exist, a `QdbAliasNotFoundException` will be thrown when reading the value.
      
      :param string $alias: A string representing the entry's alist to retrieve.
      :returns: The value of the entry is stored in the array returned by :php:meth:`QdbCluster::runBatch`.


  .. php:method:: getAndRemove (string $alias)
      
      Adds a "get and remove" operation to the batch. When executed, the "get and remove" operation atomically gets an entry and removes it.
      
      If the entry does not exist, a `QdbAliasNotFoundException` will be thrown when reading the content.
      
      :param string $alias: A string representing the entry's alist to retrieve.
      :returns: The value of the entry is stored in the array returned by :php:meth:`QdbCluster::runBatch`.


  .. php:method:: getAndUpdate (string $alias, string $content [, int $expiry_time = 0 ])
      
      Adds a "get and update" operation to the batch. When executed, the "get and update" operation atomically gets and updates (in this order) the entry.
      
      If the entry does not exist, a `QdbAliasNotFoundException` will be throw when reading the value.
      
      :param string $alias: a string representing the entry’s alias to update.
      :param string $content: a string representing the entry’s content to be set.
      :param int $expiry_time: the absolute expiry time of the entry, in seconds, relative to epoch.
      :returns: The content of the entry (before the update) is stored in the array returned by :php:meth:`QdbCluster::runBatch`.
      
      
  .. php:method:: put (string $alias, string $content [, int $expiry_time = 0 ])
      
      Adds a "put" operation to the batch. When executed, the "put" operation adds an entry. Aliases beginning with "qdb" are reserved and cannot be used.
      
      :param string $alias: a string string representing the entry’s alias to create.
      :param string $content: a string representing the entry’s content to be added.
      :param int expiry_time: the absolute expiry time of the entry, in seconds, relative to epoch
      
  
  .. php:method:: remove (string $alias)
      
      Adds a "remove" operation to the batch. When executed, the "remove" operation removes an entry.
      
      If the entry does not exist, the operation will fail and a `QdbAliasNotFoundException` will be thrown when reading the matching item of the array.
      
      :param string $alias: a string representing the entry’s alias to delete.
      
  
  .. php:method:: removeIf (string $alias, string $comparand)
      
      Adds a "remove if" operation to the batch. When executed, the "remove if" operation removes an entry if it matches `$comparand`. The operation is atomic.
      
      If the entry does not exist, the operation will fail and a `QdbAliasAlreadyExistsException` will be throw when reading the matching item of the array.
      
      :param string $alias: a string representing the entry’s alias to delete.
      :param string $comparand: a string representing the entry’s content to be compared to.
      :returns: The result of the operation is stored in the array and is `true` if the entry was actually removed or `false` otherwise.
      
  
  .. php:method:: update (string $alias, string $content [, int $expiry_time = 0 ])
      
      Adds an "update" operation to the batch. When executed, the "update" operation updates an entry. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.
      
      Aliases beginning with "qdb" are reserved and cannot be used.
      
      :param string $alias: a string representing the entry’s alias to update.
      :param string $content: a string representing the entry’s content to be added.
      :param int $expiry_time`: the absolute expiry time of the entry, in seconds, relative to epoch



The `QdbBlob` class
^^^^^^^^^^^^^^^^^^^

Represents a blob in a quasardb database. Blob stands for Binary Large Object, meaning that you can store arbitrary data in this blob.

You get a QdbBlob instance by calling QdbCluster::blob(). Then you can perform atomic operations on the blob::
    
    $cluster->blob('key 0')->put('value 0');
    $cluster->blob('key 1')->put('value 1');
    $value2 = $cluster->blob('key 2')->get();

.. php:class:: QdbBlob
  
  .. php:method:: alias (void)
      
      Gets the alias (i.e. its "key") of the blob in the database.
      
      :returns: A string representing the blob's key.
  
  .. php:method:: compareAndSwap (string $new_content, string $comparand [, int $expiry_time = 0 ])
      
      Atomically compares the blob's content with $comparand and updates it to $new_content if, and only if, they match.
      
      Throws a `QdbAliasNotFoundException` if the blob does not exist.
      
      :param string $new_content: a string representing the blob’s content to be updated in case of match.
      :param string $comparand: a string representing the blob’s content to be compared to.
      :param int $expiry_time: absolute time after which the blob expires, in seconds, relative to epoch.
      :returns: The original value of the blob.
  
  .. php:method:: expiresAt (int $expiry_time)
      
      Sets the expiry time of the blob. An $expiry_time of zero means the blob never expires.
      
      Throws a `QdbAliasNotFoundException` if the blob does not exist.
      
      :param int $expiry_time: absolute time after which the blob expires, in seconds, relative to epoch.
  
  .. php:method:: expiresFromNow (int $time_delta)
      
      Sets the expiry time of the blob. A $time_delta of zero means the blob expires as soon as possible.
      
      Throws a `QdbAliasNotFoundException` if the blob does not exist.
      
      :param int $time_delta: time in seconds, relative to the call time, after which the blob expires.
  
  .. php:method:: get (void)
      
      Retrieves the blob's content.
      
      Throws a `QdbAliasNotFoundException` if the blob does not exist.
      
      :returns: A string representing the blob's content.
  
  .. php:method:: getAndRemove (void)
      
      Atomically gets blob's content and removes it.
      
      Throws a `QdbAliasNotFoundException` if the blob does not exist.
      
      :returns: A string representing the blob’s content.
  
  .. php:method:: getAndUpdate (string $content [, int $expiry_time = 0 ])
      
      Atomically gets and updates (in this order) the blob.
      
      Throws a `QdbAliasNotFoundException` if the blob does not exist.
      
      :param string $content: a string representing the blob’s content to be set.
      :param int $expiry_time: the absolute expiry time of the blob, in seconds, relative to epoch.
      :returns: A string representing the blob’s content, before the update.
  
  .. php:method:: getExpiryTime (void)
      
      Retrieves the expiry time of the blob. A value of zero means the blob never expires.
      
      Throws a `QdbAliasNotFoundException` if the blob does not exist.
      
      :returns: The absolute expiry time, in seconds since epoch.
  
  .. php:method:: put (string $content [, int $expiry_time = 0 ])
      
      Sets blob's content but fails if the blob already exists. See also update().
      
      Aliases beginning with "qdb" are reserved and cannot be used.
      
      Throws a `QdbAliasAlreadyExistsException` if the blob already exists.
      
      :param string $content: a string representing the blob's content to be set.
      :param int $expiry_time: the absolute expiry time of the blob, in seconds, relative to epoch.
  
  .. php:method:: remove (void)
      
      Removes the blob.
      
      Throws a `QdbAliasNotFoundException` if the blob does not exist.
  
  .. php:method:: removeIf (string $comparand)
      
      Removes the blob if it's content matches $comparand.
      
      Throws a `QdbAliasNotFoundException` if the blob does not exist.
      
      :param string $comparand: a string representing the blob’s content to be compared to.
      :returns: true if the blob was actually removed, false if not.
      
  .. php:method:: update (string $content [, int $expiry_time = 0 ])
      
      Updates the content of the blob. Alias beginning with "qdb" are reserved and cannot be used. See also put().
      
      :param string $content: a string representing the blob’s content to be added.
      :param int $expiry_time: the absolute expiry time of the blob, in seconds, relative to epoch


The `QdbCluster` class
^^^^^^^^^^^^^^^^^^^^^^

Represents a connection to a *quasardb* cluster.

Example::

    $cluster = new QdbCluster('qdb://127.0.0.1:2836');
    
    $cluster->blob('key 0')->put('value 0');
    $cluster->queue('key 1')->push_back('value 1');
    $cluster->integer('key 2')->add(42);
    $cluster->hashSet('key 3')->insert('value 2');


.. php:class:: QdbCluster
  
  .. php:method:: __construct (string $uri)
      
      Connects to a quasardb cluster through the specified URI. The URI contains the addresses of the bootstraping nodes, other nodes are discovered during the first connection. Having more than one node in the URI allows to connect to the cluster even if the first node is down. ::
          
          $cluster = new QdbCluster('qdb://192.168.0.100:2836,192.168.0.101:2836');
          
      Throws a `QdbConnectionRefusedException` if the connection **to every node** fails.
      Throws a `QdbTimeoutException` if the connection **to every node** times out.
      
      :param string $uri: A string in the format "qdb://host:port[,host:port]".
  
  .. php:method:: blob (string $alias)
      
      Creates a QdbBlob associated with the specified alias. No query is performed at this point.
      
      :param string $alias: the alias of the blob in the database.
      :returns: the QdbBlob
      
  .. php:method:: hashSet (string $alias)
      
      Creates a QdbHashSet associated with the specified alias. No query is performed at this point.
      
      :param string $alias: the alias of the blob in the database.
      :returns: the QdbHashSet
  
  .. php:method:: integer (string $alias)
      
      Creates a QdbInteger associated with the specified alias. No query is performed at this point.
      
      :param string $alias: the alias of the blob in the database.
      :returns: the QdbInteger
  
  .. php:method:: queue (string $alias)
      
      Creates a QdbQueue associated with the specified alias. No query is performed at this point.
      
      :param string $alias: the alias of the blob in the database.
      :returns: the QdbQueue
  
  .. php:method:: runBatch (QdbBatch $batch)
      
      Executes operations of a `QdbBatch`.
      
      An exception related to an operation will be thrown when reading the matching item from the returned array.  
      
      :param QdbBatch $batch: a `QdbBatch` containing the operations to be performed.
      :returns: Returns an array (more exactly a class `QdbBatchResult` that behaves like an array) with the operation results. Operations results are stored in the order in which operations have been added to the `QdbBatch`, which is not necessarily the order in which operation are executed in the cluster.



The `QdbHashSet` class
^^^^^^^^^^^^^^^^^^^^^^

Represents an unordered set of blob in the quasardb database.

You get a QdbHashSet instance by calling QdbCluster::hashSet(). Then you can perform atomic operations on the set::
    
    $hashSet = $cluster->hashSet('my hashSet');
    $hashSet->insert('value');
    $hasValue = $hashSet->contains('value');

.. php:class:: QdbHashSet

  .. php:method:: alias (void)
      
      Gets the alias (i.e. its "key") of the set in the database.
      
      :returns: A string with the alias of the HashSet.
  
  .. php:method:: contains (string $value)
      
      Determines if the value is present in the set.
      
      Throws a `QdbAliasNotFoundException` if the set does not exist.
      Throws a `QdbIncompatibleTypeException` if the entry is not a set.
      
      :param string $value: the value to look for in the HashSet.
      :returns: true if the value is present in the set, false if not.
  
  .. php:method:: erase (string $value)
      
      Removes the value from the set.
      
      Throws a `QdbAliasNotFoundException` if the set does not exist.
      Throws a `QdbIncompatibleTypeException` if the entry is not a set.
      
      :param string $value: the value to remove from the HashSet.
      :returns: true if the value was present in the set, false if not.
  
  .. php:method:: insert (string $value)
      
      Adds the specified value to the set.
      
      Throws a `QdbAliasNotFoundException` if the set does not exist.
      Throws a `QdbIncompatibleTypeException` if the entry is not a set.
      
      :param string $value: the value to add to the HashSet.
      :returns: true if the value was added, false if it was already present in the set.


The `QdbInteger` class
^^^^^^^^^^^^^^^^^^^^^^

Represents an signed 64-bit integer in a quasardb database.

You get a QdbInteger instance by calling QdbCluster::integer(). Then you can perform atomic operations on the integer::
    
    $cluster->integer('key 0')->put(1);
    $cluster->integer('key 1')->update(2);
    $value2 = $cluster->integer('key 2')->get();

.. php:class:: QdbInteger
  
  .. php:method:: add (int $value)
      
      Atomically increment the value in the database.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      Throws a `QdbIncompatibleTypeException` if the entry is not an integer.
      
      :param int $value: The value to add to the value in the database.
      :returns: The new value, after the addition.
  
  .. php:method:: alias (void)
      
      Gets the alias (i.e. its "key") of the set in the database.
      
      :returns: A string with the alias of the integer.
  
  .. php:method:: expiresAt (int $expiry_time)
      
      Sets the expiry time of an existing entry. An $expiry_time of zero means the entry never expires.
      
      :param int $expiry_time: absolute time after which the entry expires, in seconds, relative to epoch.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      Throws a `QdbInvalidArgumentException` if the expiry time is in the past.
      
  .. php:method:: expiresFromNow (int $time_delta)
      
      Sets the expiry time of an existing entry. An $expiry_time of zero means the entry expires as soon as possible.
      
      :param int $time_delta: time in seconds, relative to the call time, after which the entry expires.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      Throws a `QdbInvalidArgumentException` if the expiry time is in the past.
      
  .. php:method:: get (void)
      
      Retrieves an entry's value.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      Throws a `QdbIncompatibleTypeException` if the entry is not an integer.
      
      :returns: The value of the entry.
      
      
  .. php:method:: getExpiryTime (void)
      
      Retrieves the expiry time of an existing entry. A value of zero means the entry never expires.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
      :returns: The absolute expiry time, in seconds since epoch.
  
  .. php:method:: put (int $value [, int $expiry_time = 0 ])
      
      Adds an entry. Aliases beginning with "qdb" are reserved and cannot be used.
      
      Throws a `QdbAliasAlreadyExistsException` if the entry already exists.

      :param int $value: The value of the integer.
      :param int $expiry_time: absolute time after which the entry expires, in seconds, relative to epoch.
  
  .. php:method:: remove (void)
      
      Removes the integer from the database.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
  
  .. php:method:: update (int $value [, int $expiry_time = 0 ])
      
      Updates an entry. Aliases beginning with "qdb" are reserved and cannot be used.
      
      :param int $value: The value of the integer.
      :param int $expiry_time: absolute time after which the entry expires, in seconds, relative to epoch.


The `QdbQueue` class
^^^^^^^^^^^^^^^^^^^^

Represents a queue of blob in the quasardb database. It's a double-ended queue, you can both enqueue and dequeue from the front and the back.

You get a QdbQueue instance by calling QdbCluster::queue(). Then you can perform atomic operations on the queue::
    
    $queue = $cluster->queue('my queue');
    $queue->pushBack('value 0');
    $queue->pushBack('value 1');

.. php:class:: QdbQueue
  
  .. php:method:: alias (void)
      
      Gets the alias (i.e. its "key") of the queue in the database.
      
      :returns: A string with the alias of the queue.
  
  .. php:method:: popBack (void)
      
      Remove the value at the end of the queue and return its value.
      
      Throws a `QdbAliasNotFoundException` if the queue doesn't exist.
      Throws a `QdbEmptyContainerException` if the queue is empty.
      Throws a `QdbIncompatibleTypeException` if the entry is not a queue.
      
      :returns: The value from the back of the queue.
  
  .. php:method:: popFront (void)
      
      Remove the value at the front of the queue and return its value.
      
      Throws a `QdbAliasNotFoundException` if the queue doesn't exist.
      Throws a `QdbEmptyContainerException` if the queue is empty.
      Throws a `QdbIncompatibleTypeException` if the entry is not a queue.
      
      :returns: The value from the front of the queue.
  
  .. php:method:: pushBack (string $content)
      
      Add a value to the back of the queue.
      
      :param string $content: The value to add to the queue.
      
      Throws a `QdbIncompatibleTypeException` if the entry is not a queue.
  
  .. php:method:: pushFront (string $content)
      
      Add a value to the front of the queue.
      
      :param string $content: The value to add to the queue.
      
      Throws a `QdbIncompatibleTypeException` if the entry is not a queue.

