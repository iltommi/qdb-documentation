quasardb cluster key generator
******************************

.. program:: qdb_cluster_keygen

Introduction
============

The quasardb cluster key generator generates the long term private (secret) and public key of the cluster. These keys are required to secure communication between the nodes and between the nodes and the clients.

Within a given cluster all nodes must share the same private key.

Usage
=====

The tool can output the keys in files or on the console. The private key file must be kept secure and must only be readable by the quasardb daemon.

To output the keys in /etc/qdbd/cluster_public.key and /etc/qdbd/cluster_private.key::

    qdb_cluster_keygen -p /etc/qdbd/cluster_public.key -s /etc/qdbd/cluster_private.key

To output both keys on the console:

    qdb_cluster_keygen -p - -s -

