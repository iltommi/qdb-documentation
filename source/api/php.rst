PHP
====

Quick Reference
---------------

 ================ ============================================ =====================================================================================
   Return Type     Name                                         Arguments                                                                       
 ================ ============================================ =====================================================================================
  QdbBatch         :php:meth:`QdbBatch::__construct`            (void)
  ..               :php:meth:`QdbBatch::compareAndSwap`         (string $alias, string $new_content, string $comparand [, int $expiry_time = 0 ] )
  ..               :php:meth:`QdbBatch::get`                    (string $alias)
  ..               :php:meth:`QdbBatch::getRemove`              (string $alias)
  ..               :php:meth:`QdbBatch::getUpdate`              (string $alias, string $content [, int $expiry_time = 0 ])
  ..               :php:meth:`QdbBatch::put`                    (string $alias, string $content [, int $expiry_time = 0 ])
  ..               :php:meth:`QdbBatch::remove`                 (string $alias)
  ..               :php:meth:`QdbBatch::removeIf`               (string $alias, string $comparand)
  ..               :php:meth:`QdbBatch::update`                 (string $alias, string $content [, int $expiry_time = 0 ])
  QdbCluster       :php:meth:`QdbCluster::__construct`          (array $nodes)
  string           :php:meth:`QdbCluster::compareAndSwap`       (string $alias, string $new_content, string $comparand [, int $expiry_time = 0 ] )
  ..               :php:meth:`QdbCluster::expiresAt`            (string $alias, int $expiry_time)
  ..               :php:meth:`QdbCluster::expiresFromNow`       (string $alias, int $time_delta)
  string           :php:meth:`QdbCluster::get`                  (string $alias)
  int              :php:meth:`QdbCluster::getExpiryTime`        (string $alias)
  ..               :php:meth:`QdbCluster::getRemove`            (string $alias)
  string           :php:meth:`QdbCluster::getUpdate`            (string $alias, string $content [, int $expiry_time = 0 ])
  ..               :php:meth:`QdbCluster::put`                  (string $alias, string $content [, int $expiry_time = 0 ])
  ..               :php:meth:`QdbCluster::remove`               (string $alias)
  bool             :php:meth:`QdbCluster::removeIf`             (string $alias, string $comparand)
  QdbBatchResult   :php:meth:`QdbCluster::runBatch`             (QdbBatch $batch)
  ..               :php:meth:`QdbCluster::update`               (string $alias, string $content [, int $expiry_time = 0 ])

 ================ ============================================ =====================================================================================


Introduction
--------------

Using *quasardb* cluster from a PHP program is extremely straightforward, just create a `QdbCluster` and perform the operations. ::

    $nodes = array(array('address' => '127.0.0.1', 'port' => 2836));
    
    $cluster = new QdbCluster($nodes);
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
 #. `PHP source code <http://windows.php.net/download/>`_ is decompressed in 'C:\php-src\'
 #. 'qdb-capi' is installed in 'C:\qdb-capi'
 #. 'qdb-php-api.tar.gz' has been decompressed in 'C:\php-src\ext\qdb'

Please adapt to your configuration.

**Instructions**
 #. If 'qdb_api.dll' is not available on the 'PATH', copy it to 'C:\php\'. 
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

Operations are executed by a call to `QdbCluster::runBatch ( $batch )`

Example::

    $batch = new QdbBatch();
    $batch->put('key 0', 'value 0');
    $batch->put('key 1', 'value 1');
    $batch->get('key 2');
    
    $result = $cluster->runBatch($batch);
    
    $value2 = $result[2];
    

.. php:class:: QdbBatch

  .. php:method:: __construct ( void )

      Creates an empty batch, i.e. an empty collection of operations. Batch operations can greatly increase performance when it is necessary to run many small operations.
      
      Operations in a QdbBatch are not executed until :php:meth:`QdbCluster::runBatch` is called.
      
      :returns: An empty QdbBatch collection.


  .. php:method:: compareAndSwap ( string $alias , string $new_content , string $comparand [, int $expiry_time = 0 ] )
  
      Adds a "compare and swap" operation to the batch. When executed, the "compare and swap" operation atomically compares the entry with `$comparand` and updates it to `$new_content` if, and only if, they match. If the entry does not exist, a `QdbAliasNotFoundException` will be thrown when reading the value.
      
      :param string $alias: A string representing the entry's alias to compare to.
      :param string $new_content: A string representing the entry’s content to be updated in case of match.
      :param string $comparand: A string representing the entry’s content to be compared to.
      :param int $expiry_time: The absolute expiry time of the entry, in seconds, relative to epoch.
      :returns: The original value of the entry is stored in the array returned by :php:meth:`QdbCluster::runBatch`.


  .. php:method:: get ( string $alias )
      
      Adds a "get" operation to the batch. When executed, the "get" operation retrieves an entry's content.
      
      If the entry does not exist, a `QdbAliasNotFoundException` will be thrown when reading the value.
      
      :param string $alias: A string representing the entry's alist to retrieve.
      :returns: The value of the entry is stored in the array returned by :php:meth:`QdbCluster::runBatch`.


  .. php:method:: getRemove ( string $alias )
      
      Adds a "get and remove" operation to the batch. When executed, the "get and remove" operation atomically gets an entry and removes it.
      
      If the entry does not exist, a `QdbAliasNotFoundException` will be thrown when reading the content.
      
      :param string $alias: A string representing the entry's alist to retrieve.
      :returns: The value of the entry is stored in the array returned by :php:meth:`QdbCluster::runBatch`.


  .. php:method:: getUpdate ( string $alias , string $content [, int $expiry_time = 0 ] )
      
      Adds a "get and update" operation to the batch. When executed, the "get and update" operation atomically gets and updates (in this order) the entry.
      
      If the entry does not exist, a `QdbAliasNotFoundException` will be throw when reading the value.
      
      :param string $alias: a string representing the entry’s alias to update.
      :param string $content: a string representing the entry’s content to be set.
      :param int $expiry_time: the absolute expiry time of the entry, in seconds, relative to epoch.
      :returns: The content of the entry (before the update) is stored in the array returned by :php:meth:`QdbCluster::runBatch`.
      
      
  .. php:method:: put ( string $alias , string $content [, int $expiry_time = 0 ] )
      
      Adds a "put" operation to the batch. When executed, the "put" operation adds an entry. Aliases beginning with "qdb" are reserved and cannot be used.
      
      :param string $alias: a string string representing the entry’s alias to create.
      :param string $content: a string representing the entry’s content to be added.
      :param int expiry_time: the absolute expiry time of the entry, in seconds, relative to epoch
      
  
  .. php:method:: remove ( string $alias )
      
      Adds a "remove" operation to the batch. When executed, the "remove" operation removes an entry.
      
      If the entry does not exist, the operation will fail and a `QdbAliasNotFoundException` will be thrown when reading the matching item of the array returned by :php:meth:`QdbCluster::runBatch`.
      
      :param string $alias: a string representing the entry’s alias to delete.
      
  
  .. php:method:: removeIf ( string $alias , string $comparand )
      
      Adds a "remove if" operation to the batch. When executed, the "remove if" operation removes an entry if it matches `$comparand`. The operation is atomic.
      
      If the entry does not exist, the operation will fail and a `QdbAliasAlreadyExistsException` will be throw when reading the matching item of the array returned by :php:meth:`QdbCluster::runBatch`.
      
      :param string $alias: a string representing the entry’s alias to delete.
      :param string $comparand: a string representing the entry’s content to be compared to.
      :returns: The result of the operation, `true` if the entry was actually removed or `false` otherwise, is stored in the array returned by :php:meth:`QdbCluster::runBatch`.
      
  
  .. php:method:: update ( string $alias , string $content [, int $expiry_time = 0 ] )
      
      Adds an "update" operation to the batch. When executed, the "update" operation updates an entry. If the entry already exists, the content will be updated. If the entry does not exist, it will be created.
      
      Aliases beginning with "qdb" are reserved and cannot be used.
      
      :param string $alias: a string representing the entry’s alias to update.
      :param string $content: a string representing the entry’s content to be added.
      :param int $expiry_time`: the absolute expiry time of the entry, in seconds, relative to epoch


The `QdbCluster` class
^^^^^^^^^^^^^^^^^^^^^^

Represents a connection to a *quasardb* cluster.

Example::

    $nodes = array(array('address' => '127.0.0.1', 'port' => 2836));

    $cluster = new QdbCluster($nodes);
    $cluster->put('key 0', 'value 0');
    $cluster->put('key 1', 'value 1');
    $value2 = $cluster->get('key 2');



.. php:class:: QdbCluster

  .. php:method:: __construct (array $nodes)
      
      Connects to a *quasardb* cluster through an array of arrays. ::
          
          $nodes = array(
              array('address'=>'192.168.0.1','port'=>'2836'),
              array('address'=>'192.168.0.2','port'=>'2836')
          );
          
      Throws a `QdbClusterConnectionFailedException` if the connection **to every node** fails.
       
      :param array $nodes: An array of arrays.
      :returns: a QdbCluster object.
      
      
      
  .. php:method:: compareAndSwap (string $alias, string $new_content, string $comparand [, int $expiry_time = 0 ])
      
      Atomically compares the entry with `$comparand` and updates it to `$new_content` if, and only if, they match.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
      :param string $alias: a string representing the entry’s alias to compare to.
      :param string $new_content: a string representing the entry’s content to be updated in case of match.
      :param string $comparand: a string representing the entry’s content to be compared to.
      :returns string: Always returns the original value of the entry.


  .. php:method:: expiresAt (string $alias, int $expiry_time)
      
      Sets the expiry time of an existing entry. An `$expiry_time` of zero means the entry never expires.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
      :param string $alias: a string representing the entry’s alias for which the expiry must be set.
      :param int $expiry_time: absolute time after which the entry expires, in seconds, relative to epoch.
      
      
  .. php:method:: expiresFromNow (string $alias, int $time_delta )
      
      Sets the expiry time of an existing entry. An `$expiry_time` of zero means the entry expires as soon as possible.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
      :param string $alias: a string representing the entry’s alias for which the expiry must be set.
      :param int $expiry_time: time in seconds, relative to the call time, after which the entry expires.
      
  
  .. php:method:: get (string $alias)
  
      Retrieves an entry's content.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
      :param string $alias: a string representing the entry’s alias whose content is to be retrieved.
      :returns string: A string representing the entry's content.
      
      
  .. php:method:: getExpiryTime (string $alias)
  
      Retrieves the expiry time of an existing entry. A value of zero means the entry never expires.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
      :param string $alias: a string representing the entry’s alias for which the expiry must be get.
      :returns int: The absolute expiry time, in seconds since epoch.
  
  
  .. php:method:: getRemove (string $alias)
      
      Atomically gets an entry and removes it.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
      :param string $alias: a string representing the entry’s alias to delete.
      :returns string: A string representing the entry’s content.
      
  
  .. php:method:: getUpdate (string $alias, string $content [, int $expiry_time = 0 ])
      
      Atomically gets and updates (in this order) the entry.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
      :param string $alias: a string representing the entry’s alias to update.
      :param string $content: a string representing the entry’s content to be set.
      :param int $expiry_time: the absolute expiry time of the entry, in seconds, relative to epoch.
      :returns string: A string representing the entry’s content, before the update.
      
  
  .. php:method:: put (string $alias, string $content [, int $expiry_time = 0 ])
      
      Adds an entry. Aliases beginning with "qdb" are reserved and cannot be used.
      
      Throws a `QdbAliasAlreadyExistsException` if the entry already exists.
      
      :param string $alias: a string representing the entry’s alias to create.
      :param string $content: a string representing the entry’s content to be added.
      :param int $expiry_time: the absolute expiry time of the entry, in seconds, relative to epoch
  
  
  .. php:method:: remove (string $alias)
      
      Removes an entry.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
      :param $alias: a string representing the entry’s alias to delete.
      
      
  .. php:method:: removeIf (string $alias, string $comparand)
      
      Removes an entry if it matches `$comparand`.
      
      Throws a `QdbAliasNotFoundException` if the entry does not exist.
      
      :param string $alias: a string representing the entry’s alias to delete.
      :param string $comparand: a string representing the entry’s content to be compared to.
      :returns bool: `true` if the entry was actually removed, `false` if not.
      

  .. php:method:: runBatch (QdbBatch $batch)
      
      Executes operations of a `QdbBatch`.
      
      An exception related to an operation will be thrown when reading the matching item from the returned array.  
      
      :param QdbBatch $batch: a `QdbBatch` containing the operations to be performed.
      :returns: Returns an array (more exactly a class `QdbBatchResult` that behaves like an array) with the operation results. Operations results are stored in the order in which operations have been added to the `QdbBatch`, which is not necessarily the order in which operation are executed in the cluster.
      
  
  .. php:method:: update (string $alias, string $content [, int $expiry_time = 0 ])
      
      Updates an entry. Aliases beginning with "qdb" are reserved and cannot be used.
      
      :param string $alias: a string representing the entry’s alias to update.
      :param string $content: a string representing the entry’s content to be added.
      :param int $expiry_time: the absolute expiry time of the entry, in seconds, relative to epoch

