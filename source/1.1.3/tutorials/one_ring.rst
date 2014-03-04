Your first quasardb cluster
**************************************************

quasardb is designed to be run as a cluster. A cluster is multiple instances of the daemon running separate servers which collaborate to balance the load.
This tutorial will guide you through the steps required to setup such cluster. If you have not done so yet, going through the introductory tutorial is highly recommended (see :doc:`tut_quick`).

.. important:: 
    A valid license is required to run the daemon (see :doc:`../license`). The path to the license file is specified by the ``--license-file`` option (see :doc:`../reference/qdbd`).

Create a Cluster with Three Nodes
=================================

It is assumed we have a network of three machines: 192.168.1.1, 192.168.1.2 and 192.168.1.3. All nodes are equal in features and responsibility, making a cluster very resilient to failure. The theoretical limit to the number of nodes a cluster may have is so high (more than several trillions) that there is no practical limit.


Configure the First Node
~~~~~~~~~~~~~~~~~~~~~~~~

#. Generate a default configuration file. ::

   $ qdbd -g > qdbd_config.json

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
                 "max_in_entries_count": 100000
             }
         },
    
#. Set the local parameters that will be unique to this node. For the first node, we will enter a non-localhost IP address and port into the "listen_on" parameter and leave the rest at defaults::
   
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
                  "log_files": [  ],
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

   $ qdbd -c qdbd_config.json


Configure the Second and Third Nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Generate a default configuration file.

#. Leave the global cluster parameters at default. These will be overwritten by the global settings from our first node.

#. Set the local parameters that will be unique to this node. The important changes from default are the "bootstrapping_peers", "listen_on", and "license_file" parameters. In this example, we will set the "bootstrapping_peers" value to the first node's IP address and port. The "listen_on" parameter will be set to a non-localhost IP address, like the first node. ::

         "local":
          {
              "chord":
              {
                  "bootstrapping_peers": [192.168.1.1:2836],
                  "no_stabilization": false,
                  "node_id": "0-0-0-0"
              },
              "logger":
              {
                  "dump_file": "qdb_error_dump.txt",
                  "flush_interval": 3,
                  "log_files": [  ],
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

As nodes come online, the cluster will automatically *stabilize* it self. :term:`Stabilization` is the process during which nodes agree on how and where the data should be distributed. During the stabilization phase the cluster is considered *unstable* which means requests may fail.

The stabilization duration depends on the number of nodes. In our case the cluster should be fully stabilized in less than twenty seconds.

If a node fails, the data it was responsible for will not be available, but the rest of the cluster will detect the failure, re-stabilize itself automatically and remain available. 

See :doc:`../reference/qdbd` for more information.

Talk to your cluster with the quasardb shell
=====================================================

The quasardb shell can connect to any node. The cluster will handle the client requests, routing each of them to the correct node.
If you add a node to the cluster, you do not have to make *any* change on the client side.

#. Run qdbsh::

    $ qdbsh --daemon=192.168.1.2:2836

#. Test a couple of commands::

       qdbsh:ok >put entry thisismycontent
       qdbsh:ok >get entry
       thisismycontent
       qdbsh:ok >exit

#. Test that a different node acknowledges the entry::

     qdbsh --daemon=192.168.1.3:2836

     > get entry
     thisismyentry
