Your first wrpme hive
**************************************************

wrpme is specifically design to be run as a hive, meaning multiple instances of the daemon distributed among multiple physical servers.
This tutorial will guide you through the steps required to distribute the load on several nodes. If you have not done so yet, going through the introductory tutorial is highly recommended (see :doc:`tut_quick`).

Create a three instances hive
=======================================

It is assumed we have a network of three machines: 192.168.1.1, 192.168.1.2 and 192.168.1.3
All nodes are equal in features and responsibility, making a hive very resilient to failure. 
There is no theoretical limit to the number of nodes a hive may have.

#. Run an instance on the first machine::
    
    wrpmed -a 192.168.1.1:5909 -l wrpmed.log
    
  By default wrpmed listens on 127.0.0.1. To have other machines access to it you need to specify 192.168.1.1 as the listen address.
    
#. Run an instance on the second machine, and indicate that its peer is the first machine::

    wrpmed -a 192.168.1.2:5909 --peer=192.168.1.1:5909 -l wrpmed.log
    
#. Run an instance on the second machine, and indicate that its peer is the first machine::

    wrpmed -a 192.168.1.3:5909 --peer=192.168.1.1:5909 -l wrpmed.log

The hive will now automatically *stabilize* it self. 
:term:`Stabilization` is the process during which nodes exchange information to agree on where data should be located.
During the stabilization phase the hive is considered *unstable* which means requests may fail.
The stabilization duration depends on the number of nodes. In our case the hive should be fully stabilized in less than twenty seconds. 
If a node fails, the data it was responsible for will not be available, but the rest of the hive will detect the failure, re-stabilize itself automatically and remain available. Additionally, since all data can be persisted to disk, if the failed node rejoins the hive, the data it was responsible for will be available again.

See :doc:`../reference/wrpmed` for more information.

Talk to your hive with the wrpme shell
=====================================================

The wrpme shell can connect to any node. The hive will handle the client requests, routing each of them to the correct node. 
If you add a node to the hive, you do not have to make *any* change on the client side.

#. Run wrpmesh::

    wrpmesh --daemon=192.168.1.2:5909
    
#. Test a couple of commands::

    > put entry thisismyentry
    > get entry
    thisismyentry
    > exit
   
#. Test that a different node acknowledges the entry::

    wrpmesh --daemon=192.168.1.3:5909
    
    > get entry
    thisismyentry
