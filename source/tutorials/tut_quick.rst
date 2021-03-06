An installation tutorial for people with very little time
*********************************************************

A minimal quasardb setup requires deploying the quasardb daemon on a single server and making sure that the client can access it. In this tutorial security will be not be enabled.

.. important::
    This tutorial is based on a manual installation of quasardb, that is, we will expand an archive and configure manually the daemon. For many platform we
    provide a packaged installer and it is recommended to use this packaged installer in production (see :doc:`../administration/index`).

    You *may* need license to run this tutorial (see :doc:`../license`).


Installing a quasardb daemon in three steps
===========================================

Without a configuration file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Download the appropriate **server** for your platform (FreeBSD, Linux or Windows) from `quasardb download site <https://www.quasardb.net/-Get->`_. All download information is in your welcome e-mail.

#. Install the server

   * On FreeBSD and Linux you just need to expand the tarball.
   * On Windows it comes as a zip file or as an automated setup, which includes both the 32-bit and the 64-bit version.

#. Run the daemon from the command line.

   The command is::

       qdbd --security=false

   If you have a licence file::

       qdbd --license-file=qdb_license.txt --security=false

.. note::
    On Windows, the installer creates and runs a quasardb service listening on the default port (2836) on the local address.

With a configuration file
^^^^^^^^^^^^^^^^^^^^^^^^^

#. Download the appropriate **server** for your platform (FreeBSD, Linux or Windows) from `quasardb download site <https://www.quasardb.net/-Get->`_. All download information is in your welcome e-mail.

#. Install the server

   * On FreeBSD and Linux you just need to expand the tarball.
   * On Windows it comes as a zip file or as an automated setup, which includes both the 32-bit and the 64-bit version.

#. Generate a default configuration file using the command line.

   The command is::

       qdbd --gen-config > qdbd_config.conf

   The daemon will by default listen on the IPv4 localhost, on the port 2836, persist its content to the disk asynchronously, limit itself to 1,000,000 entries, and will not log at all. See :doc:`../reference/qdbd` for more configuration options.

#. Optional: Edit the configuration file so it points to your license_file. ::

        "user":
        {
            "daemon": false,
            "license_file": "qdb_license.txt"
        }

   Providing an empty string "" runs `qdbd` in evaluation mode.

#. Run the daemon from the command line.

   The command is::

       qdbd -c qdbd_config.conf --security=false


Using the quasardb shell to test your quasardb installation
===========================================================

The quasardb shell offers an interactive mode from which the user can enter commands. The name of the binary is `qdbsh` and it is included in the utils package.

#. Run `qdbsh`.

   The command is::

       qdbsh

   By default `qdbsh` will connect to a quasardb daemon using the default settings of localhost, port 2836. If you have edited the `qdbd` configuration file already, for example to make the `qdbd` daemon run on 192.168.1.1 and listen on port 303 - you will run `qdbsh` as such::

       qdbsh qdb://192.168.1.1:303

   See :doc:`../reference/qdb_shell` for detailed configuration options.

#. Add and get an entry from the server::

       qdbsh> blob_put entry thisismycontent
       qdbsh> blob_get entry
       thisismycontent
       qdbsh> exit

Type `help` to get a list of available commands. See :doc:`../reference/qdb_shell` for more information.

Monitoring your installation from a web server
==============================================

quasardb comes with a web bridge in the form of an HTTP daemon. This web bridge can be used to monitor your quasardb daemon remotely. It is updated in real time so the information displayed by the web server is as fresh as it can be. The name of the binary is `qdb_httpd` and it is included in the server package.

All information is available in both JSON and JSONP format.

#. Generate a default configuration file for the web bridge.

   The command is::

       qdb_httpd --gen-config > qdb_httpd_default_config.conf

   By default, the web bridge will listen on localhost, port 8080. It will connect to a quasardb daemon using the default settings of localhost, port 2836. See :doc:`../reference/qdb_httpd` for detailed configuration options.

#. Run the web bridge.

   The command is::

       qdb_httpd -c qdb_httpd_default_config.conf

#. Test it from a browser

   The primary node monitoring interface is an HTML5 web interface. If using the default settings, simply point your browser to::

       http://127.0.0.1:8080/view/index.html

   You can also access the statistics in JSON format. The global statistics URL is `/global_status`::

       http://127.0.0.1:8080/global_status

   If you want the content in JSONP format, the URL becomes::

       http://127.0.0.1:8080/global_status?daemon=127.0.0.1:2836&callback=MyCallBack
