Upgrade a Cluster
=================

There are two methods to upgrade a cluster, :ref:`online-upgrade` and :ref:`offline-upgrade`.

.. warning::
    Do not upgrade your cluster to a new major version, such as 1.0.0 to 2.0.0, without `contacting Quasardb <contact.html>`_ for assistance.

.. _online-upgrade:

Online Upgrade
--------------

An online upgrade allows you to upgrade to a new patch version, such as 1.1.4 to 1.1.5. You can upgrade each node individually, without downtime for the cluster. During the online upgrade period, client requests may receive “error try again” or “connection refused” errors. The administration console may show incorrect information until the cluster is fully upgraded.

Before You Begin
^^^^^^^^^^^^^^^^

 #. Inform quasardb support that you will be upgrading your cluster.
 #. Make a list of all nodes to upgrade.
 #. Verify the cluster is in a period of low traffic.

Upgrade
^^^^^^^

For each node in the cluster:

 #. :ref:`Shut down <shutdown>` the qdb_httpd web server on the node, if applicable.
 #. :ref:`Shut down <shutdown>` the qdbd daemon on the node.
 #. Read the qdbd daemon log file to verify the daemon closed properly and no error occurred.
 #. Verify the operating system shows the qdbd daemon is no longer running.
 #. Uninstall the old version of quasardb.
 #. Install the new version of quasardb.
 #. Copy the new license file and configuration file to the new installation location, if applicable.
 #. Start the qdbd daemon on the node.
 #. Start the qdb_httpd web server on the node, if applicable.
 #. Verify the operating system shows the qdbd daemon is running.
 #. Read the qdbd daemon log file to verify the daemon started properly and has stabilized.
 #. The node upgrade is complete!

Once all nodes are upgraded:

 #. Test your ring with :doc:`../reference/qdb_shell` to verify it is responding to requests properly.
 #. Force refresh any browsers viewing the :doc:`../reference/qdb_httpd`.


.. _offline-upgrade:

Offline Upgrade
---------------

An offline upgrade allows you to upgrade to a new patch or minor version of quasardb, such as 1.0.0 to 1.0.1 or 1.1.0. However, you must take the entire cluster offline during the upgrade.

Before You Begin
^^^^^^^^^^^^^^^^

 #. Inform quasardb support that you will be upgrading your cluster.
 #. Make a list of all nodes to upgrade.
 #. Record which node is the origin node, that is, the node with zero bootstrapping peers in its configuration file.


Upgrade
^^^^^^^

For each node in the cluster:

 #. :ref:`Shut down <shutdown>` the qdb_httpd web server on the node, if applicable.
 #. :ref:`Shut down <shutdown>` the qdbd daemon on the node.
 #. Read the qdbd daemon log file to verify the daemon closed properly and no error occurred.
 #. Verify the operating system shows the qdbd daemon is no longer running.
 #. Uninstall the old version of quasardb.
 #. Install the new version of quasardb.
 #. Copy the new license file and configuration file to the new installation location, if applicable.
 #. Repeat for each node.

To bring the cluster online:

 #. Start the qdbd daemon on the origin node.
 #. Start the qdb_httpd web server on the origin node, if applicable.
 #. Verify the origin node's operating system shows the qdbd daemon is running.
 #. Read the qdbd daemon log file on the origin node to verify the daemon started properly and has stabilized.
 #. Repeat for each node.
 #. The upgrade is complete!

Once all nodes are upgraded:

 #. Test your ring with :doc:`../reference/qdb_shell` to verify it is responding to requests properly.
 #. Force refresh any browsers viewing the :doc:`../reference/qdb_httpd`.
