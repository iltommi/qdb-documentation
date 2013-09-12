Primer
******

What is quasardb?
-----------------

quasardb is a key / value store. It is fast and scalable, handles concurrent accesses very well and is designed to manage large amounts of data at high-frequency. One can label quasardb as a `NoSQL database <http://en.wikipedia.org/wiki/NoSQL>`_.
quasardb is *limitless*. If your computer has got enough memory and enough disk space, quasardb can handle it.

Where would you want to use quasardb? Here are a couple of use cases:

    * High-frequency trading market data store
    * Heavy traffic web site
    * Multiplayer game dynamic elements depot
    * Distributed computing common data store
    * Relational database cache

Shall we dance?
---------------

Deploying quasardb is running a :term:`server`. That's just one program to launch, :doc:`reference/qdbd`::

    ./qdbd &

Now that the server is ready, you can add anything that crosses your mind into it. For example with :doc:`reference/qdb_shell`::

    qdbsh put entry amazing...
    qdbsh get entry
    amazing...

Oh well, that was not very original. Let's stress the engine a bit more! We'll add a whole directory named "directory" to it::

    tar cf - directory | gzip -9 | qdbsh update entry

And later, we can extract it a such::

    qdbsh get entry | gzip -cd | tar x -

But, wait, there's more!
------------------------

The shell tool is not always the right tool for the job.
If you have your own application (web or not), you may find it cumbersome to run a third-party program every time you want to access the database.
That's why we have an API! We currently support :doc:`api/c`, :doc:`api/java` and :doc:`api/python`.

Here is a short Python code snippet::

    import qdb

    # connecting, default port is 2836
    c = qdb.Client(qdb.RemoteNode("127.0.0.1"))
    # adding an entry
    c.put("entry", "really amazing...")
    # getting and printing the content
    print c.get("entry")
    # closing connection
    del c


But, wait, there's more!
------------------------

You might want an entry added in quasardb to be automatically removed after a certain amount of time. 

Here's one way to do it::

    # entry will expire and be removed in 10s
    c.expires_from_now("entry", 10)

But, wait, there's more!
------------------------

That's all well and good, but what if you have no idea what the exact name of the key is?

No problem, just tell quasardb the starting characters and it will return a match list::

    # looking for entries starting with "ent"
    print c.prefix_get("ent")

But, wait, there's more!
------------------------

Working on web-oriented technologies? We've thought about you as well and built a web bridge, :doc:`reference/qdb_httpd`::

    ./qdb_httpd &

The web bridge can help you monitor the node and get entries in JSON or JSONP format, for example, with wget::

    wget "localhost:8080/get?alias=entry"

Wrap up
-------

Things to remember about quasardb:

    * Fast and scalable key/value store
    * High-performance binary protocol
    * Multi-platform: FreeBSD 8-9, Linux 2.6+ and Windows NT (32-bit and 64-bit)
    * Peer-to-peer network distribution
    * Transparent persistence
    * Fire and forget: deploy, run and return to your core business.
