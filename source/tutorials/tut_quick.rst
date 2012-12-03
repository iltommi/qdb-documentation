An installation tutorial for people with very little time
*********************************************************

A minimal quasardb setup requires deploying the quasardb daemon (qdbd executable) on a server and making sure that the client can access it.

.. important:: 
    A valid license is required to run the daemon (see :doc:`../license`). The path to the license file is specified by the ``--license-file`` option (see :doc:`../reference/qdbd`).


Installing a quasardb daemon in three steps
===========================================

#. Download the **server** from the `official download page <http://www.quasardb.com/downloads.html>`_
#. Install the server
  * On FreeBSD and Linux you just need to expand the tarball.
  * On Windows it comes as an automated setup *which includes both the 32-bit and the 64-bit version*.
#. Run the daemon

   The daemon binary is qdbd on Unix, qdbd.exe on Windows. The daemon will by default listen on the IPv4 localhost, on the port 2836, persist its content to the disk asynchronously, limit itself to 1 GiB and will not log at all. See :doc:`../reference/qdbd` for more configuration options.

Using the quasardb shell to test your quasardb installation
===========================================================

The quasardb shell offers an interactive mode from which the user can enter commands. The name of the binary is qdbsh and it is included in the server package.

#. Run qdbsh.
  By default qdbsh will attempt to connect to a daemon running on the same machine and listening on the port 2836. If this is not the case - for example if your daemon runs on 192.168.1.1 and listens on the port 303 - you will run qdbsh as such::

    qdbsh --daemon=192.168.1.1:303
#. Add an entry into the server::

    put entry thisismycontent
    get entry

  Type `help` to get a list of available commands. See :doc:`../reference/qdb_shell` for more information.

Monitoring your installation from a web server
==============================================

quasardb comes with a web bridge in the form of a web server. This web bridge can be used to monitor your quasardb daemon and is updated in real time, meaning the information displayed by the web server is as fresh as it can be. The name of the binary is qdb_httpd and it is included the server package.

All information is available in both JSON and JSONP format.

 #. Run the server

    By default the server will listen on the localhost and on the port 8080. We may want to listen on all IPv4 interfaces instead. Note that we need to specify the daemon's address (192.168.1.1 on the port 303 in our example)::

      qdb_httpd --address=0.0.0.0:8080 --daemon=192.168.1.1:303

 #. Test it from a browser

    An HTML 5 web interface is available to monitor your node. If your server is on the machine 192.168.1.1, you therefore access the statistics as such::

      http://192.168.1.1:8080/view

    You can also access to the statistics in JSON format. The global statistics URL is /global_status::

      http://192.168.1.1:8080/global_status

    If you want the content in JSONP format, the URL becomes::

      http://192.168.1.1:8080/global_status?callback=MyCallBack
