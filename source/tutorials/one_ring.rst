Your first quasardb cluster
**************************************************

quasardb is designed to be run as a cluster. A cluster is multiple instances of the daemon running separate servers which collaborate to balance the load.
This tutorial will guide you through the steps required to setup such a cluster. If you have not done so yet, going through the introductory tutorial is highly recommended (see :doc:`tut_quick`).

.. important::
    This tutorial is based on a manual installation of quasardb, that is, we will expand an archive and configure manually the daemon. For many platform we
    provide a packaged installer and it is recommended to use this packaged installer in production (see :doc:`../administration/index`).

    You *may* need license to run this tutorial (see :doc:`../license`).


Create a Cluster with Three Nodes
=================================

In this tutorial we will set up a cluster of three machines with static IP addresses of 192.168.1.1, 192.168.1.2 and 192.168.1.3. All nodes are equal in features and responsibility, making our cluster very resilient to failure. The theoretical limit to the number of nodes a cluster may have is so high (more than several trillions) that there is no practical limit, but three will do for this exercise.

For smaller clusters it is generally advised to manually specify the id of each node for ideal load-balancing (see :ref:`nodes_is_info`).


Configure the First Node
~~~~~~~~~~~~~~~~~~~~~~~~

#. Generate a default configuration from qdbd by running ``qdbd --gen-config > 192.168.1.1.conf``.

#. Edit the configuration file using your favorite editor.

#. Set the ``local::network::listen_on`` value to ``"192.168.1.1:2836"``.

#. Set the ``global::cluster::replication_factor`` value to 2.

#. Set the ``local::chord::node_id`` value to ``0000000000000000-0-0-1``

#. Save the file.

Configure the Second Node
~~~~~~~~~~~~~~~~~~~~~~~~~

#. Generate a default configuration from qdbd by running ``qdbd --gen-config > 192.168.1.2.conf``.

#. Edit the configuration file using your favorite editor.

#. Set the ``local::network::listen_on`` value to ``"192.168.1.2:2836"``.

#. Set the ``local::chord::bootstrapping_peers`` value to ``["192.168.1.1:2836"]``

#. Set the ``global::cluster::replication_factor`` value to 2.

#. Set the ``local::chord::node_id`` value to ``5b00000000000000-0-0-0``

#. Save the file.

Configure the Third Node
~~~~~~~~~~~~~~~~~~~~~~~~

#. Generate a default configuration from qdbd by running ``qdbd --gen-config > 192.168.1.3.conf``.

#. Edit the configuration file using your favorite editor.

#. Set the ``local::network::listen_on`` value to ``"192.168.1.3:2836"``.

#. Set the ``local::chord::bootstrapping_peers`` value to ``["192.168.1.1:2836"]``

#. Set the ``global::cluster::replication_factor`` value to 2.

#. Set the ``local::chord::node_id`` value to ``b600000000000000-0-0-0``

#. Save the file.

Starting the Daemons
~~~~~~~~~~~~~~~~~~~~

#. Copy the named configuration files to the qdbd folder on the respective nodes.

#. Start the quasardb daemon on the first node. ::

    qdbd -c 192.168.1.1.conf

#. Start the quasardb daemon on the second and third nodes. ::

    qdbd -c 192.168.1.2.conf

    qdbd -c 192.168.1.3.conf

As nodes come online, they will stabilize themselves by self-organizing into a ring and determining storage locations for data. For more information, see :ref:`stabilization`.

For more information about quasardb arguments and configuration parameters, see :doc:`../reference/qdbd`.


Talk to your cluster with the quasardb shell
=====================================================

The quasardb shell can connect to any node. The cluster will handle the client requests, routing each of them to the correct node.
If you add a node to the cluster, you do not have to make *any* change on the client side.

#. Run qdbsh::

    qdbsh qdb://192.168.1.2:2836

#. Test a couple of commands::

    ok:qdbsh> blob_put entry thisismycontent
    ok:qdbsh> blob_get entry
    thisismycontent
    ok:qdbsh> exit

#. Test that a different node acknowledges the entry::

    qdbsh qdb://192.168.1.3:2836

    ok:qdbsh> blob_get entry
    thisismycontent
