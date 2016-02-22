.. include:: abbreviations.rst

.. highlight:: python

Primer
******

What is |quasardb|?
-------------------

|Quasardb| is an advanced data management system. At its heat, it is a transactional key/value store with indexing capabilities. It is fast and scalable
(up and out), handles concurrent accesses very well and is designed to manage large amounts of data at high-frequency. One can label |quasardb| as a
`NoSQL database <https://en.wikipedia.org/wiki/NoSQL>`_.

|Quasardb| is *limitless*. If the hardware can handle it, |quasardb| can handle it.

Where would you want to use |quasardb|? Here are a couple of use cases:

    * Trading market data store
    * Apache Spark backend
    * Heavy traffic web site
    * Multiplayer game dynamic elements depot
    * Distributed computing common data store
    * Relational database cache

Shall we dance?
---------------

To start a |quasardb| server, just run it! We provide packages for many platform, but you can always work in a local directory where you manually
extracted your |quasardb| binaries. We also support docker and are available on Microsoft Azure and Amazon EC2.

Let's assume we extracted the |quasardb| archive in a local directory. The default configuration listens on the localhost, port 2836. If you type::

    qdbdd

You will have after a couple of seconds the daemon log on the console that it is ready to accept incoming requests. You can store into |quasardb| anything,
images, videos, XML, text... It will automatically optimize storage for you.

Let's fire up the shell and run a couple of commands::

    qdbsh

Will start the shell and the following prompt should be displayed. Keep in mind you must keep the daemon running::

    qdbsh>

Let's start simple. The example below uses :doc:`reference/qdb_shell`: to give the key "entry" a value of "amazing..."::

    qdbsh> blob_put entry amazing...
    qdbsh> blob_get entry
    amazing...

Wait, what is a blob? A blob is a "binary large object" and should be your go-to type when unsure. Using blob for text is perfectly fine
and actually optimal. A blob is stored bit-for-bit and our low-level protocols make sure no non-sense is added to your data. There is no limit to the size of
blobs.

When you use the blob_put command, |quasardb| will return an error if the entry already exists::

    qdbsh> blob_put entry other_value
    An entry matching the provided alias already exists.

To update a value, you have the blob_update command, which creates the entry when it doesn't exist::

    qdbsh> blob_update entry other_value

Beyond blobs
------------

There are other types of entries in |quasardb|, such as integers::

    qdbsh> int_put my_value 10
    qdbsh> int_get my_value
    10

Of course you could store the string "10" into a blob, but with integers you have cross-platform 64-bit signed integer available at your finger tips,
which enables you to do things such as::

    qdbsh> int_add my_value 5
    15

The power of arithmetics compels you! When requesting |quasardb| through the API, integers are provided in a native format understood by the programming language
you are using.

In |quasardb| all operations, unless otherwise noted, are atomic, concurrent and server-side validated. Which means if you had thousands of shells doing "int_add"
you are guaranteed that all operations are properly accounted.

But, wait, there's more!
------------------------

Integers, blobs...

What about "a list of stuff"?

Lists in |quasardb| are named "deques" and stand for "double-ended queues". They support concurrent and scalable insertions at the beginning and the end and O(1)
random access to any element within the deque. Deques are automatically scaled across all the nodes of your cluster and have absolutely no limit,
because at |quasardb|, we don't like limits::

    qdbsh> deque_push_back my_list entry_one
    qdbsh> deque_push_back my_list entry_two

    qdbsh> deque_pop_front my_list
    entry_one

Every entry within the deque is a blob, of whatever size you fancy.

But, wait, there's more!
------------------------

Now we'd like to show you one of the most exciting features of |quasardb|: tags. Since |quasardb| is a key/value store it provides you extremely fast access to any
entry within the cluster, if you have a key.

What if you don't have a key? What if you want to look-up the data differently? This is why we introduced tags. If you'd like to be able to lookup an entry via
a different value than the key, you can use tags. There is no limit to the number of tags you can have for a key and no limit to the number of keys you can have
for a tag.

Let's see it in action::

    qdbsh> int_put client1_views 1000
    qdbsh> int_put client1_orders 500

    qdbsh> add_tag client1_views client1
    qdbsh> add_tag client1_orders client1

    qdbsh> get_tagged client1
    client1_views, client1_orders

    qdbsh> get_tags client1_views
    client1

You can see tags as manual secondary indexes. You never pay for tags if you don't need them and tags are designed to be distributed and scalable. Tags are ideal
when you have a lot of unstructured data or need a flexible model to work with. There is no background jobs that analyzes your data to create indexes so tags
are very fast and inexpensive.

But, wait, there is so much more!
---------------------------------

The shell tool is not always the right tool for the job and generally has a subset of all the features available in |quasardb|.

If you have your own application, you may find it cumbersome to run a third-party program every time you want to access the database.

That's why we have APIs! We currently support :doc:`api/c`, :doc:`api/cpp`, :doc:`api/java`, `PHP <https://doc.quasardb.net/php/>`_, `.NET <https://doc.quasardb.net/dotnet/>`_,
:doc:`api/nodejs` and :doc:`api/python`.

You can either fetch a binary package or build the API from source (BSD License). You will find them on `GitHub <http://github.com/bureau14>`. Our APIs do their
best to be simple and straightforward.

Here is a short Python code snippet:

.. testcode:: primer

    import qdb

    # connecting, default port is 2836
    c = qdb.Cluster("qdb://127.0.0.1:2836")
    # adding an entry
    b = c.blob("my_entry")
    b.put("really amazing...")
    # getting and printing the content
    print b.get()
    # closing connection
    del c

Which will output the following when executed:

.. testoutput:: primer

    really amazing...

That demo is nice, but what happens when I go to production?
------------------------------------------------------------

A fair question which has a simple answer: the size and configuration of the cluster has no impact on the client code. The only thing that may change is
the connection string. For example if you have a cluster of four machines, your connection string can be::

    c = qdb.Cluster("qdb://192.168.1.1:2836,192.168.1.2:2836,192.168.1.3:2836,192.168.1.4:2836")

or::

    c = qdb.Cluster("qdb://192.168.1.1:2836,192.168.1.2:2836")

and even::

    c = qdb.Cluster("qdb://192.168.1.1:2836")

That's because |quasardb| protocol has built-in discovery! Just give any node in the cluster and we take care of the rest. The more nodes the better as we can
try another node if the one provided is down at the moment of the connection.

Going further
-------------

We hope this quick tour left you wanting for more! |quasardb| is feature-rich yet simple to use and operate. If you want to go further, the best course of
action is to start with the documentation of the API for the language of your choice (:doc:`api/index`).

If you'd like to learn more about building a |quasardb| cluster, head over to the administrative section (:doc:`administration/index`).

Curious about the underlying concepts, we have a section dedicated to it (:doc:`concepts/index`).

Wrap up
-------

Things to remember about |quasardb|:

    * Fast and scalable
    * High-performance binary protocol
    * Multi-platform: FreeBSD, Linux 2.6+, OS X and Windows (32-bit and 64-bit)
    * Peer-to-peer network distribution
    * Transparent persistence
    * Distributed transactions
    * Rich typing
    * Tag-based search
    * Fire and forget: deploy, run and return to your core business.
