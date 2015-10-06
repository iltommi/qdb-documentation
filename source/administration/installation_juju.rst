
JuJu Charms Installation
========================

The quasardb JuJu charm is only supported on Ubuntu at this time.


Ubuntu Instance
---------------

 #. Install JuJu on your machine using the `JuJu quickstart instructions <https://jujucharms.com/get-started>`_.
 #. Clone the JuJu charm repository with ``git clone https://github.com/bureau14/qdb-juju-charms``.
 #. Enter the directory for your Ubuntu installation.
 #. Install the first quasardb node with ``juju deploy quasardb-xtp``.
 #. Complete the Configuration and Test instructions for :doc:`installation_deb`.
 #. Add more nodes with ``juju add-unit quasardb-xtp``.
 #. Repeat Configuration and Test for each node.