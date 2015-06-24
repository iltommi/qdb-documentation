Primer
******

What is quasardb?
-----------------

quasardb is a key / value store. It is fast and scalable, handles concurrent accesses very well and is designed to manage large amounts of data at high-frequency. One can label quasardb as a `NoSQL database <http://en.wikipedia.org/wiki/NoSQL>`_.

quasardb is *limitless*. If your computer has enough memory and enough disk space to store it, quasardb can handle it.

Where would you want to use quasardb? Here are a couple of use cases:

    * High-frequency trading market data store
    * Heavy traffic web site
    * Multiplayer game dynamic elements depot
    * Distributed computing common data store
    * Relational database cache

Shall we dance?
---------------

Before you start the quasardb server, generate a default configuration file::

    qdbd --gen-config > qdbd_config.conf

Then, simply run the :doc:`reference/qdbd` from a terminal, passing in the configuration file:: 

    qdbd -c qdbd_config.conf

Now that the server is running, you can begin storing anything that crosses your mind into the database. Let's start simple. The example below uses :doc:`reference/qdb_shell`: to give the key "entry" a value of "amazing..."::

    qdbsh put entry amazing...
    qdbsh get entry
    amazing...

Now let's store the number of files in a folder, based on the output of a shell command::

    qdbsh put num_files $(ls -1 | wc -l)
    qdbsh get num_files
    7

Oh well, that was not very exciting. Let's stress the engine a bit more! We will zip up a whole directory and overwrite the entry key's value (previously "amazing..." using shell pipes::

    tar czf - ./directory | ./qdbsh update entry

And later, we can extract that directory::

    qdbsh get entry | tar -xz ./

Or just export the tar.gz file::

    qdbsh get entry > directory.tar.gz


But, wait, there's more!
------------------------

The shell tool is not always the right tool for the job.
If you have your own application (web or not), you may find it cumbersome to run a third-party program every time you want to access the database.
That's why we have APIs! We currently support :doc:`api/c`, :doc:`api/java`, :doc:`api/php`, `.NET <https://doc.quasardb.net/dotnet/>`_ and :doc:`api/python`.

You can find our APIs on `github <http://github.com/bureau14>`_.

Here is a short Python code snippet::

    import qdb

    # connecting, default port is 2836
    c = qdb.Cluster("qdb://127.0.0.1:2836"))
    # adding an entry
    c.blob("entry").put("really amazing...")
    # getting and printing the content
    print c.blob("entry").get()
    # closing connection
    del c


Automatic object lifetime
-------------------------

You might want an entry added in quasardb to be automatically removed after a certain amount of time. 

Here's one way to do it::

    # entry will expire and be removed in 10s
    c.blob("entry").expires_from_now(10)

Blobs are nice but what about something more beefy?
---------------------------------------------------

quasardb supports integers and queues, out of the box. 

Queues support efficient and concurrent insertion at the beginning and the end::

    c.queue("my_queue").push_back("data")
    print c.queue("my_queue").back()
    c.queue("my_queue").push_front("front_data")
    print c.queue("my_queue").front()

Integers are native signed 64-bit integers and support atomic additions::

    c.integer("value").put(20)
    c.integer("value").add(-10)
    print c.integer("value").get()

Because everything is done server-side these powerful features will enable you to have many clients safely operate on the same entries. For example, integers make it easy to implement reliable counters.

Wrap up
-------

Things to remember about quasardb:

    * Fast and scalable key/value store
    * High-performance binary protocol
    * Multi-platform: FreeBSD, Linux 2.6+, OS X and Windows NT (32-bit and 64-bit)
    * Peer-to-peer network distribution
    * Transparent persistence
    * Distributed transactions
    * Rich typing
    * Tag-based search
    * Fire and forget: deploy, run and return to your core business.
