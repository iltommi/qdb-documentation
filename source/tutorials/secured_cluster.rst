A secured cluster
*****************

In the other tutorials you may have noticed the presence of the security flag.

By default a cluster is secured and requires the generation of a cluster key pair and users to be added. In this tutorial, we will see how this is done.

We will assume that configuration files are stored in the /etc/qdbd directory and that binaries are installed in /usr/local/bin.

Generating a cluster key pair
=============================

The private key will have to be shared for all the servers of the cluster. It must be kept private and only the daemon requires it.

To generate a key pair you use the quasardb cluster key generator (see :doc:`../reference/qdb_cluster_keygen`)::

  qdb_cluster_keygen -p /etc/qdb/cluster_public.key -s /etc/qdb/cluster_private.key

It is very important that the private key remains unaccessible to third parties. Clients connecting to the cluster do not need the private key, only the public key.

.. note::
  It's best to keep the cluster public key file in a read accessible location different from the QuasarDB configuration directory.

Creating an user
================

We will create an user named "alice" and add that to the user file. We will store the private key in a local directory, as we will need it to connect to the cluster.

To add an user you use the quasardb user adder tool (see :doc:`../reference/qdb_user_add`)::

  qdb_user_add -u alice -p /etc/qdb/users.cfg -s alice_private.key

We can create, if we need to, a second user named "bob"::

  qdb_user_add -u bob -p /etc/qdb/users.cfg -s bob_private.key

The user adder tool will update the users.cfg, preserving our user named "Alice".

Generating the daemon configuration
===================================

We will generate a default configuration file and update the security information with the files we just generated.

To generate a default configuration, we use the --gen-config switch from the daemon::

  qdbd --gen-config > /etc/qdb/qdbd.cfg

In this generated a configuration file, we need to update the security section of this file::

      "security": {
        "enable_stop": false,
        "enable_purge_all": false,
        "enabled": true,
        "cluster_private_file": "/etc/qdb/cluster_private.key",
        "user_list": "/etc/qdb/users.cfg"
    }

We strongly recommend to use an absolute path for the cluster private file as well as the users list.

Running the daemon with our secure setup
========================================

We now need to run the daemon with our updated configuration::

  qdbd -c /etc/qdb/qdbd.cfg

When security is properly setup, the following lines should appear in the log::

  11:12:08.989481000   24348      info    successfully loaded cluster private key from "/etc/qdb/cluster_private.key"
  11:12:08.989760100   24348      info    successfully loaded 2 users from "/etc/qdb/users.cfg"

If the daemon fails to load either the key or the user file, ensure the daemon has proper read access to these files and that the path is valid.

Establishing a secure connection from the shell
===============================================

To connect the shell securely to the cluster, we need:

 * The cluster *public* key file. In our case it's /etc/qdb/cluster_public.key
 * The user *private* credentials file. In our case it's either alice_private.key or bob_private.key

You will see that the credential file contains both the private key and the user name.

To securely connect as alice::

  qdbsh --cluster-public-key-file=/etc/qdb/cluster_public.key --user-credentials-file=alice_private.key

To securely connect as bob::

  qdbsh --cluster-public-key-file=/etc/qdb/cluster_public.key --user-credentials-file=bob_private.key

When succesfully connected, you should be greeted by the shell prompt::

  quasardb shell version 2.1.0 build d34dc0d3 2017-01-11 00:00:00 +0200
  Copyright (c) 2009-2017 quasardb. All rights reserved.

  qdbsh>

If either the cluster key or the user key are invalid, you will have the following error::

  Can't connect to cluster: Login failed for the user.

If you connect to the cluster without specifying any credentials, you will have the following error::

  Can't connect to cluster: Invalid reply from the remote host.

This is because the shell attempts to connect to the cluster using the unsecured protocol and the server answers with the secure protocol.

Connecting the console to the daemon
====================================

Since the cluster is now secured, you must specify security parameters for the daemon as well. We will add an user for the console and configure the web bridge for secure connection.

First let's add a www user to the daemon::

  qdb_user_add -u www -p /etc/qdb/users.cfg -s /etc/qdb/www_private.key

You will need to restart the daemon for the new user to be accounted.

Then we will configure authentication on the web bridge::

  qdb_httpd --gen-config > /etc/qdb/qdb_httpd.cfg

There are two security settings for the console, the user authentication to the console and the secure connection to the daemon.

We will do both::

  {
    // other sections ommitted
    "user": "admin",
    "password": "a_better_password", // please use another password :-)
    "cluster_public_key_file": "/etc/qdb/cluster_public.key",
    "user_key_file": "/etc/qdb/www_private.key"
  }

What we have done:

  * We added an user "amdmin" with the password "a_better_password". This login password is used to connect to the console through a web browser.
  * We specified the cryptographic information required for the web bridge to connect to the daemon.

You can then run the quasardb web bridge with this new configuration::

  /usr/local/bin/qdb_httpd -c /etc/qdb/qdb_httpd.cfg

And the web console will appear in your browser if you navigate to::

  http://127.0.0.1:8080/

If it does not, make sure that you correctly specified all information and that no error appears in the web bridge log.

Growing the cluster
===================

Now that you've set up your secure cluster, you may want to add more nodes. To do that, you need to make sure that the private key as well as the user directory are present in the node you want to add to the cluster.

Once this is done, you connect the node to your cluster like you would do without the security active. The node will authenticate itself with the cluster private key and be recognized as a special user.