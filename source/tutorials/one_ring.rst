Your first quasardb cluster
**************************************************

quasardb is designed to be run as a cluster. A cluster is multiple instances of the daemon running separate servers which collaborate to balance the load.
This tutorial will guide you through the steps required to setup such a cluster. If you have not done so yet, going through the introductory tutorial is highly recommended (see :doc:`tut_quick`).

.. important:: 
    A valid license is required to run the daemon (see :doc:`../license`). In the examples below, we will use the default path and filename of "qdb_license.txt". Ensure your license file is properly named and placed in same folder as qdbd before continuing.

Create a Cluster with Three Nodes
=================================

In this tutorial we will set up a cluster of three machines with static IP addresses of 192.168.1.1, 192.168.1.2 and 192.168.1.3. All nodes are equal in features and responsibility, making our cluster very resilient to failure. The theoretical limit to the number of nodes a cluster may have is so high (more than several trillions) that there is no practical limit, but three will do for this exercise.


Configure the First Node
~~~~~~~~~~~~~~~~~~~~~~~~

#. Generate configuration files for your cluster using the :doc:`../reference/confgen`.

#. Edit the configuration file.

#. Set the global cluster parameters first. These parameters will be pushed to the second and third nodes to ensure consistency across the cluster. In this example, we will use a :ref:`data-replication` factor of 2 and use default values for the rest::
   
      {
         "global":
         {
             "depot":
             {
                 "max_bytes": 0,
                 "replication_factor": 2,
                 "root": "db",
                 "sync": false,
                 "transient": false
             },
             "limiter":
             {
                 "max_bytes": 0,
                 "max_in_entries_count": 1000000
             }
         },
    
#. Set the local parameters that will be unique to this node. For the first node, we will enter a non-localhost IP address and port into the "listen_on" parameter and a log file of "/var/log/qdbd.log", then leave the rest at defaults::
   
         "local":
          {
              "chord":
              {
                  "bootstrapping_peers": [  ],
                  "no_stabilization": false,
                  "node_id": "0-0-0-0"
              },
              "logger":
              {
                  "dump_file": "qdb_error_dump.txt",
                  "flush_interval": 3,
                  "log_files": ["/var/log/qdbd.log"],
                  "log_level": 2,
                  "log_to_console": false,
                  "log_to_syslog": false
              },
              "network":
              {
                  "client_timeout": 60,
                  "idle_timeout": 600,
                  "listen_on": "192.168.1.1:2836",
                  "partitions_count": 10,
                  "server_sessions": 2000
              },
              "user":
              {
                  "daemon": false,
                  "license_file": "qdb_license.txt"
              }
          }
      }
   
#. Start the quasardb daemon on the first node. ::

    qdbd -c qdbd_config.conf


Configure the Second and Third Nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Generate a configuration file using the :doc:`../reference/confgen`.

#. Leave the global cluster parameters at default. These will be overwritten by the global settings from our first node.

#. Set the local parameters that will be unique to this node. The important changes from default are the "bootstrapping_peers", "listen_on", and "license_file" parameters. In this example, we will set the "bootstrapping_peers" value to a string containing the first node's IP address and port. The "listen_on" parameter will be set to a non-localhost IP address, like the first node. Finally, the log file will be set to the same "/var/log/qdbd.log" location. ::

         "local":
          {
              "chord":
              {
                  "bootstrapping_peers": ["192.168.1.1:2836"],
                  "no_stabilization": false,
                  "node_id": "0-0-0-0"
              },
              "logger":
              {
                  "dump_file": "qdb_error_dump.txt",
                  "flush_interval": 3,
                  "log_files": ["/var/log/qdbd.log"],
                  "log_level": 2,
                  "log_to_console": false,
                  "log_to_syslog": false
              },
              "network":
              {
                  "client_timeout": 60,
                  "idle_timeout": 600,
                  "listen_on": "192.168.1.2:2836",
                  "partitions_count": 10,
                  "server_sessions": 2000
              },
              "user":
              {
                  "daemon": false,
                  "license_file": "qdb_license.txt"
              }
          }
      }

#. Start the quasardb daemon on the second node.

#. Repeat the above steps for the third node, providing either the first or the second node in the "bootstrapping_peers" value.

As nodes come online, they will stabilize themselves by self-organizing into a ring and determining storage locations for data. For more information, see :ref:`stabilization`.

For more information about quasardb arguments and configuration parameters, see :doc:`../reference/qdbd`.


Talk to your cluster with the quasardb shell
=====================================================

The quasardb shell can connect to any node. The cluster will handle the client requests, routing each of them to the correct node.
If you add a node to the cluster, you do not have to make *any* change on the client side.

#. Run qdbsh::

    qdbsh --daemon=192.168.1.2:2836

#. Test a couple of commands::

    ok:qdbsh> put entry thisismycontent
    ok:qdbsh> get entry
    thisismycontent
    ok:qdbsh> exit

#. Test that a different node acknowledges the entry::

    qdbsh --daemon=192.168.1.3:2836
    
    ok:qdbsh> get entry
    thisismyentry
