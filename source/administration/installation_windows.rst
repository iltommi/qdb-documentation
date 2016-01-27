
Windows Installation
====================

All file paths refer to 64-bit file paths.

Software Installation
---------------------

 #. Verify your system meets the :ref:`sysreq-windows`.
 #. Log in to https://download.quasardb.net/ with your credentials.
 #. Download the file named ``setup-qdb-server-<ver>.exe``
 #. Run the setup executable.

The setup program ensures all required libraries are installed. There is one setup program for Windows x86 and Windows x64; the setup will install the appropriate version.

Configuration
-------------

By default, the quasardb daemon listens on the port 2836 on the local address. The quasardb web bridge listens on the port 8080 on the local address. These may be the IPv6 localhost if IPv6 is installed. 

 #. Edit the qdbd configuration file at ``C:\Program Files\quasardb\conf\qdbd.conf``.
     * Set ``local::user::license_file`` to your license file path.
     * Add node IP addresses to ``local::chord::bootstrapping_peers`` to connect the node to a cluster.
     * Set ``local::network::listen_on`` to change the IP address and port qdbd uses.
     * Set other values as needed. See :ref:`qdbd-config-file-reference` for more information.
 #. (optional) Edit the qdb_httpd configuration file at ``C:\Program Files\quasardb\conf\qdb_httpd.conf``.
     * Set ``remote_node`` to the IP address of the quasardb daemon.
     * Set other values as needed. See :ref:`qdb_httpd-config-file-reference` for more information.

Test the Node
-------------

The qdbd and qdb_httpd daemons are started automatically after installation and will also load when Windows starts.

 #. View the log file at ``C:\Program Files\quasardb\log\qdbd`` to verify the qdbd service started without errors.
 #. View the log file at ``C:\Program Files\quasardb\log\qdb_httpd`` to verify the qdb_httpd service started without errors.
 #. Start ``qdbsh`` and verify the node responds to commands.
 #. Test the node for TCP configuration problems with ``qdb_max_conn``.


Test the Cluster
----------------

 #. Benchmark the cluster with ``qdb_bench``. See :doc:`../reference/qdb_bench` for more information.

