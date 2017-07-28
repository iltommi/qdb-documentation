
Debian \ Ubuntu Installation
============================

Software Installation
---------------------

 #. Verify your system meets the :ref:`sysreq-linux`.
 #. Download quasardb server Debian package for Linux from `quasardb download site <https://www.quasardb.net/-Get->`_.
     * Alternatively, you can directly download necessary files from https://download.quasardb.net/ (for experienced users).
 #. Install the DEB using ``sudo dpkg -i qdb-server_<ver>.deb``

 The DEB package installs files as user qdb, group qdb, in the following locations:

 ================= =================
  File Types        Path
 ================= =================
  Config            /etc/qdb
  Logs              /var/log/qdb
  Database          /var/db/qdb
  Libs / Other      /usr/share/qdb
 ================= =================


Configuration
-------------

By default, the quasardb daemon listens on the port 2836 on the local address. The quasardb web bridge listens on the port 8080 on the local address.

 #. Edit the qdbd configuration file at ``/etc/qdb/qdbd.conf``.
     * Set ``local::user::license_file`` to your license file path.
     * Add node IP addresses to ``local::chord::bootstrapping_peers`` to connect the node to a cluster.
     * Set ``local::network::listen_on`` to change the IP address and port qdbd uses.
     * Set other values as needed. See :ref:`qdbd-config-file-reference` for more information.

 #. (optional) Edit the qdb_httpd configuration file at ``/etc/qdb/qdb_httpd.conf``.
     * Set ``remote_node`` to the IP address of a node.
     * Set other values as needed. See :ref:`qdb_httpd-config-file-reference` for more information.

To ensure satisfactory performance, we strongly encourage you to have a look at the tuning guide (:doc:`tuning`).

Test the Node
-------------

 #. Start qdbd with ``sudo service qdbd start``
 #. Verify the qdbd service started without errors using ``sudo service qdbd status``
 #. (optional) Run ``sudo service qdb_httpd start``
 #. (optional) Verify the qdb_httpd service started without errors using ``sudo service qdb_httpd status``
 #. Start ``qdbsh`` and verify the node responds to commands.
 #. Test the node for TCP configuration problems with ``qdb_max_conn``.


Test the Cluster
----------------

 #. Benchmark the cluster with ``qdb-benchmark``. See :doc:`../reference/qdb-benchmark` for more information.

