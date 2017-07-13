quasardb user adder
******************************

.. program:: qdb_user_add

Introduction
============

The server keeps a user list in a JSON format, which contais the list of authorized users.

Example::

    {
        "users": [
            {
                "username": "root",
                "public_key": "PoCzwwX8Gdq7Mzz/RG6rH6vRhX84/RupFvVOjXauOEBM="
            },
            {
                "username": "quant",
                "public_key": "Pr0vI41GyHTjJX5ufc+ga0KDdzEfd5OZ6J6F5V42AHj4="
            },
            {
                "username": "pnl",
                "public_key": "PIsIvNyuiaNCQspxpz6LCDdUpP3AbKlFa3iOsj1QKgBQ="
            }
        ]
    }

The user list only contains public key. To connect to a cluster, an user will use it name and private key.

The private key must only be known to the administrator and the authorized user.

The quasardb user adder tool enables you to authorize users to a quasardb secured cluster in generating the required public/private key pair and updating the users list file.

Usage
=====

The user adder tool can write the information to files or on the standard output. If the provided output file for the public key already exists, the new user will be added to the existing file.

To add an user named "alice" to the user files contained in /etc/qdbd/users.cfg and store the private key in the local file alice_private.key::

    qdb_user_add -u alice -p /etc/qdbd/users.cfg -s alice_private.key

To add an user named "alice" to the user files contained in /etc/qdbd/users.cfg and output the private key to the console::

    qdb_user_add -u alice -p /etc/qdbd/users.cfg -s -

To generate a key pair for an user alice and output everything on the console::

    qdb_user_add -u alice -p - -s -