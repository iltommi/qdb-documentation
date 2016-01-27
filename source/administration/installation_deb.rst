
Debian \ Ubuntu Installation
============================

Software Installation
---------------------

 #. Verify your system meets the :ref:`sysreq-linux`.
 #. Log in to https://download.quasardb.net/ with your credentials.
 #. Download the file named ``qdb-server_<ver>.deb``
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
         
 #. Disable Transparent Huge Pages by adding the following to ``/etc/rc.local``::
         
         if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
           echo never > /sys/kernel/mm/transparent_hugepage/enabled
         fi
         
         if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
            echo never > /sys/kernel/mm/transparent_hugepage/defrag
         fi
                  
 #. Run ``ulimit -n`` as a regular user. If the value is less than 65000, add the following line to ``/etc/security/limits.conf``::
         
         qdb    soft    nofile    65536


The .deb package automatically sets the following values in `/etc/sysctl.d/30-quasardb.conf`::

    # Max number of incoming connections
    net.core.somaxconn = 8192
    
    # Max number of pending connections
    net.ipv4.tcp_max_syn_backlog = 8192
    
    # Max socket memory (read & write)
    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    
    # Swap only when running out of memory 
    vm.swappiness = 0


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

 #. Benchmark the cluster with ``qdb_bench``. See :doc:`../reference/qdb_bench` for more information.

