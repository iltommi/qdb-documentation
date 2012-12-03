Your first quasardb hive
**************************************************

quasardb is designed to be run as a hive. A hive is multiple instances of the daemon running separate servers which collaborate to balance the load.
This tutorial will guide you through the steps required to setup such hive. If you have not done so yet, going through the introductory tutorial is highly recommended (see :doc:`tut_quick`).

.. important:: 
    A valid license is required to run the daemon (see :doc:`../license`). The path to the license file is specified by the ``--license-file`` option (see :doc:`../reference/qdbd`).

Create a three instances hive
=======================================

It is assumed we have a network of three machines: 192.168.1.1, 192.168.1.2 and 192.168.1.3. All nodes are equal in features and responsibility, making a hive very resilient to failure. The theoretical limit to the number of nodes a hive may have is so high (more than several trillions) that there is no practical limit.

#. Run an instance on the first machine. Each instance has got a different database directory (here it is instance1)::

    qdbd -a 192.168.1.1:2836 -l qdbd1.log --root=./instance1

  By default qdbd listens on 127.0.0.1. To have other machines access to it you need to specify 192.168.1.1 as the listen address.

#. Run an instance on the second machine, and indicate that its peer is the first machine. We also use a different database directory (instance2)::

    qdbd -a 192.168.1.2:2836 --peer=192.168.1.1:2836 -l qdbd2.log --root=./instance2

#. Run an instance on the second machine, and indicate that its peer is the first machine::

    qdbd -a 192.168.1.3:2836 --peer=192.168.1.1:2836 -l qdbd3.log --root=./instance3

The hive will now automatically *stabilize* it self. :term:`Stabilization` is the process during which nodes agree on how and where the data should be distributed. During the stabilization phase the hive is considered *unstable* which means requests may fail.

The stabilization duration depends on the number of nodes. In our case the hive should be fully stabilized in less than twenty seconds.

If a node fails, the data it was responsible for will not be available, but the rest of the hive will detect the failure, re-stabilize itself automatically and remain available. 

See :doc:`../reference/qdbd` for more information.

Talk to your hive with the quasardb shell
=====================================================

The quasardb shell can connect to any node. The hive will handle the client requests, routing each of them to the correct node.
If you add a node to the hive, you do not have to make *any* change on the client side.

#. Run qdbsh::

    qdbsh --daemon=192.168.1.2:2836

#. Test a couple of commands::

    > put entry thisismyentry
    > get entry
    thisismyentry
    > exit

#. Test that a different node acknowledges the entry::

    qdbsh --daemon=192.168.1.3:2836

    > get entry
    thisismyentry
