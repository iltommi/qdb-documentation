
Other Linux Installation
========================

Software Installation
---------------------

 #. Verify your system meets the :ref:`sysreq-linux`.
 #. Download quasardb server tarball for Linux from `quasardb download site <https://www.quasardb.net/-Get->`_.
     * Alternatively, you can directly download necessary files from https://download.quasardb.net/ (for experienced users).
 #. Extract the tarball.
 #. Change to the extracted directory.

Configuration
-------------

By default, the quasardb daemon listens on the port 2836 on the local address. The quasardb web bridge listens on the port 8080 on the local address.

 #. Generate a qdbd configuration file using ``./bin/qdbd --gen-config > ./bin/qdbd.conf``.
 #. Edit the configuration file at ``./bin/qdbd.conf``.
     * Set ``local::user::license_file`` to your license file path.
     * Set ``local::user::daemon`` to ``true`` to daemonize qdbd on startup.
     * Add node IP addresses to ``local::chord::bootstrapping_peers`` to connect the node to a cluster.
     * Set ``local::network::listen_on`` to change the IP address and port qdbd uses.
     * Set other values as needed. See :ref:`qdbd-config-file-reference` for more information.
 #. Generate a qdbd configuration file using ``./bin/qdb_httpd --gen-config > ./bin/qdb_httpd.conf``.
 #. (optional) Edit the qdb_httpd configuration at ``./bin/qdb_httpd.conf``.
     * Set ``remote_node`` to the IP address of a node.
     * Set ``daemonize`` to ``true`` to daemonize qdb_httpd on startup.
     * Set other values as needed. See :ref:`qdb_httpd-config-file-reference` for more information.

To ensure satisfactory performance, we strongly encourage you to have a look at the tuning guide (:doc:`tuning`).

Test the Node
-------------

 #. Start qdbd with ``./bin/qdbd -c ./bin/qdbd.conf``
 #. Verify the qdbd service started without errors.
 #. (optional) Start qdb_httpd with ``./bin/qdb_httpd -c ./bin/qdb_httpd.conf``
 #. (optional) Verify the qdb_httpd application started without errors.
 #. Start ``qdbsh`` and verify the node responds to commands.
 #. Test the node for TCP configuration problems with ``qdb_max_conn``.


Test the Cluster
----------------

 #. Benchmark the cluster with ``qdb-benchmark``. See :doc:`../reference/qdb-benchmark` for more information.

