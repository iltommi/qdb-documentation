Primer
******

What is wrpme?
--------------

wrpme is a key / value store. It is fast and scalable. It handles concurrent accesses very well and is designed to manage large amounts of data at high-frequency. 

wrpme is *limitless*. In other words, we didn't put any limit in wrpme. If your computer has got enough memory and enough disk space, wrpme can handle it. 

One can label wrpme as a `NoSQL database <http://en.wikipedia.org/wiki/NoSQL>`_ but we prefer the term `post-modern database <http://db.cs.berkeley.edu/postmodern/>`_.

Where would you want to use wrpme? Here are few use cases:

    * High-frequency trading market data store
    * Heavy traffic web cache
    * Multiplayer game dynamic elements depot
    * Distributed computing common data store
    * Relational database cache
    
Shall we dance?
---------------

Using wrpme requires running a :term:`server`, that's just one program to launch, :doc:`reference/wrpmed`::

    ./wrpmed &
    
Now that the server is ready, you can add anything that crosses your mind into it. For example with :doc:`reference/wrpme_shell`::

    wrpmesh put entry amazing...
    wrpmesh get entry
    amazing...
    
Oh well, that wasn't very original. Let's stress the engine a bit more! We'll add a whole directory named "directory" to it::

    tar cf - directory | gzip -9 | wrpmesh update entry
    
And later, we can extract it a such::

    wrpmesh get entry | gzip -cd | tar x -
        
It works because wrpme is data agnostic. It will store bit for bit everything you add to it. Just make sure you have enough memory on your server!
        
But, wait, there's more!
------------------------

wrpmesh isn't always the right tool for the job. 
If you have your own application (web or not), you may find it cumbersome to run a third-party program every time you want to access the database. 
That's why we have an API! We currently support :doc:`api/c`, :doc:`api/java` and :doc:`api/python`.

Here is a short Python code snippet::

    import wrpme
    
    h = wrpme.open()
    wrpme.connect(h, "127.0.0.1", 5909)
    
    # adding an entry
    wrpme.put(h, "entry", "really amazing...")
    # getting and printing the content
    print wrpme.get(h, "entry")[1]

    
Working on web-oriented technologies? We've thought about you as well and built a web bridge, :doc:`reference/wrpme_httpd`::

    ./wrpme_httpd &
    
The web bridge can help you monitor the node and get entries in JSON or JSONP format, for example, with wget::

    wget "localhost/get?entry=alias"
    
Still not convinced?
--------------------
    
We could tell you much more about wrpme, such as its distribution capabilities, its ability to persist data, its scalability or simply the fact that it runs on FreeBSD, Linux and Windows...

...but what about seeing for yourself? wrpme is `free of charge for non-commercial use <http://www.wrpme.com/purchase.html>`_. Get it `here <http://www.Wrpme.com/downloads.html>`_. 


Wrap up
--------------------------

Things to remember about wrpme:

    * Fast and scalable key/value store
    * High-performance binary protocol
    * Multi-platform: FreeBSD 8, Linux 2.6 and Windows NT (32-bit and 64-bit)
    * Peer-to-peer network distribution
    * Transparent persistence
    * Fire and forget: deploy, run and return to your core business. 
