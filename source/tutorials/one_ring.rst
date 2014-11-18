Your first quasardb cluster
**************************************************

quasardb is designed to be run as a cluster. A cluster is multiple instances of the daemon running separate servers which collaborate to balance the load.
This tutorial will guide you through the steps required to setup such a cluster. If you have not done so yet, going through the introductory tutorial is highly recommended (see :doc:`tut_quick`).

.. important:: 
    A valid license is required to run the daemon (see :doc:`../license`). In the examples below, we will use the default path and filename of "qdb_license.txt". Ensure your license file is properly named and placed in same folder as qdbd before continuing.

Create a Cluster with Three Nodes
=================================

In this tutorial we will set up a cluster of three machines with static IP addresses of 192.168.1.1, 192.168.1.2 and 192.168.1.3. All nodes are equal in features and responsibility, making our cluster very resilient to failure. The theoretical limit to the number of nodes a cluster may have is so high (more than several trillions) that there is no practical limit, but three will do for this exercise.


Generating Configuration Files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We can create configuration files for all of the nodes at once using the :doc:`../reference/confgen`.

#. Access the :doc:`../reference/confgen`.

#. Enter the RAM, disk space, and number of cores available to quasardb.

#. Add the IP address of 192.168.1.1.

#. Click the "Click here to add another node" link twice.

#. Add the IP addresses of 192.168.1.2 and 192.168.1.3.

#. Set the :ref:`data-replication` factor to 2.

#. Set the "Allowed simultaneous connections" to 2000.

#. Click Generate Configuration File.

#. Save the compressed file somewhere you will remember.


Starting the Daemons
~~~~~~~~~~~~~~~~~~~~

#. Extract the named configuration files to the qdbd folder on the respective nodes. Each conf file will be named the IP address or hostname you entered in the configuration generator.
   
#. Start the quasardb daemon on the first node. ::

    qdbd -c 192.168.1.1.conf

#. Start the quasardb daemon on the second and third nodes. ::

    qdbd -c 192.168.1.2.conf
    
    qdbd -c 192.168.1.3.conf

As nodes come online, the cluster will automatically *stabilize* it self. :term:`Stabilization` is the process during which nodes agree on how and where the data should be distributed. During the stabilization phase the cluster is considered *unstable* which means requests may fail.

The stabilization duration depends on the number of nodes. In our case the cluster should be fully stabilized in less than twenty seconds.

If a node fails, the data it was responsible for will not be available, but the rest of the cluster will detect the failure, re-stabilize itself automatically and remain available. 

See :doc:`../reference/qdbd` for more information.

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
