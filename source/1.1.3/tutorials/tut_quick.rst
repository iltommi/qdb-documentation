An installation tutorial for people with very little time
*********************************************************

A minimal quasardb setup requires deploying the quasardb daemon (qdbd executable) on a server and making sure that the client can access it.

.. important:: 
    A valid license is required to run the daemon (see :doc:`../license`). The path to the license file is specified by the ``--license-file`` option (see :doc:`../reference/qdbd`).


Installing a quasardb daemon in three steps
===========================================

#. Download the appropriate **server** for your platform (FreeBSD, Linux or Windows) from Bureau 14 download site. All download information is in your welcome e-mail.
   
#. Install the server
   
   * On FreeBSD and Linux you just need to expand the tarball.
   * On Windows it comes as an automated setup, which includes both the 32-bit and the 64-bit version.


#. Generate a default configuration file using the command line.
   
   For FreeBSD and Linux, the command is::

       $ qdbd -g > qdbd_default_config.json
   
   For Windows, the command is::
   
       C:\> qdbd.exe -g > qdbd_default_config.json
   
   The daemon will by default listen on the IPv4 localhost, on the port 2836, persist its content to the disk asynchronously, limit itself to 100,000 entries, and will not log at all. See :doc:`../reference/qdbd` for more configuration options.
   
#. Run the daemon from the command line.

   For FreeBSD and Linux, the command is::

       $ qdbd -c qdbd_default_config.json
   
   For Windows, the command is::
   
       C:\> qdbd.exe -c qdbd_default_config.json

Using the quasardb shell to test your quasardb installation
===========================================================

The quasardb shell offers an interactive mode from which the user can enter commands. The name of the binary is qdbsh and it is included in the server package.

#. Run qdbsh.

   For FreeBSD and Linux, the command is::

       $ qdbsh
   
   For Windows, the command is::
   
       C:\> qdbsh.exe

   By default qdbsh will connect to a quasardb daemon using the default settings of localhost, port 2836. If you have edited the qdbd configuration file already, for example to make the qdbd daemon run on 192.168.1.1 and listen on port 303 - you will run qdbsh as such::

       $ qdbsh --daemon=192.168.1.1:303
   
   See :doc:`../reference/qdb_shell` for detailed configuration options.

#. Add and get an entry from the server::

       qdbsh:ok >put entry thisismycontent
       qdbsh:ok >get entry
       thisismycontent
       qdbsh:ok >exit
  
Type `help` to get a list of available commands. See :doc:`../reference/qdb_shell` for more information.

Monitoring your installation from a web server
==============================================

quasardb comes with a web bridge in the form of an HTTP daemon. This web bridge can be used to monitor your quasardb daemon remotely. It is updated in real time so the information displayed by the web server is as fresh as it can be. The name of the binary is qdb_httpd and it is included in the server package.

All information is available in both JSON and JSONP format.

#. Generate a default configuration file for the web bridge.
   
   For FreeBSD and Linux, the command is::

       $ qdb_httpd -g > qdb_httpd_default_config.json
   
   For Windows, the command is::
   
       C:\> qdb_httpd.exe -g > qdb_httpd_default_config.json
   
   By default, the web bridge will listen on localhost, port 8080. It will connect to a quasardb daemon using the default settings of localhost, port 2836. See :doc:`../reference/qdb_httpd` for detailed configuration options.

#. Run the web bridge.

   For FreeBSD and Linux, the command is::

       $ qdb_httpd -c qdb_httpd_default_config.json
   
   For Windows, the command is::
   
       C:\> qdb_httpd.exe -c qdb_httpd_default_config.json
   
#. Test it from a browser

   The primary node monitoring interface is an HTML 5 web interface. If using the default settings, simply point your browser to::

       http://127.0.0.1:8080/view

   You can also access the statistics in JSON format. The global statistics URL is /global_status::

       http://127.0.0.1:8080/global_status

   If you want the content in JSONP format, the URL becomes::

       http://127.0.0.1:8080/global_status?callback=MyCallBack
