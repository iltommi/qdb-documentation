
Other Linux Installation
========================

Software Installation
---------------------

 #. Verify your system meets the :ref:`sysreq-linux`.
 #. Log in to https://download.quasardb.net/ with your credentials.
 #. Download the file named ``qdb-server-<ver>-linux-64bit.tgz``
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
 #. If using a Gigabit Ethernet connection, edit ``/etc/sysctl.conf`` and set the following values:
     * ``net.core.somaxconn = 8192``
     * ``net.ipv4.tcp_max_syn_backlog = 8192``
     * ``net.core.rmem_max = 16777216``
     * ``net.core.wmem_max = 16777216``
 #. Run ``ulimit -n`` as a regular user. If the value is less than 65000, add the following line to ``/etc/security/limits.conf``:
     * ``qdb    soft    nofile    65536``

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

 #. Benchmark the cluster with ``qdb_bench``. See :doc:`../reference/qdb_bench` for more information.

