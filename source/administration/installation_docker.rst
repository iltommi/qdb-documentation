
Docker Installation
====================

Docker is currently not recommended for production.

Available docker images
-----------------------

We currently offer the following images:

 * `qdb <https://hub.docker.com/r/bureau14/qdb/>`_ - The quasardb daemon
 * `qdb-http <https://hub.docker.com/r/bureau14/qdb-http/>`_ - The quasardb web console
 * `qdb-dev <https://hub.docker.com/r/bureau14/qdb-dev/>`_ - A daemon with the quasardb API for development purposes
 * `qdb-dev-python <https://hub.docker.com/r/bureau14/qdb-dev-python/>`_ - A daemon with the Python API and pre-installed tools

Tags
----

The following tags are used:

 * lts: Long term service release
 * latest: The latest release
 * nightly: the nightly build

Every release is also tagged with its version number. For example, 2.0.1 has the following tags: lts, 2, 2.0 and 2.0.1.

Software Installation
---------------------

Depending on your host operating system, all of the following docker commands may require root permissions.

 #. Verify your system meets the :doc:`system_requirements`.
 #. Install `Docker <https://www.docker.com>`_ for your host operating system.
 #. Install the qdb image using ``docker pull bureau14/qdb``.
 #. Install the qdb-http image using ``docker pull bureau14/qdb-http``.

Configuration
-------------

 #. Connect to the qdb-server using ``docker exec -ti qdb-server /bin/bash``.
 #. Edit the qdbd configuration file using ``vi /etc/qdb/qdbd.conf``.
     * Add node IP addresses to ``local::chord::bootstrapping_peers`` to connect the node to a cluster.
     * Set other values as needed. See :ref:`qdbd-config-file-reference` for more information.
 #. Exit the qdb-server docker using ``exit``.
 #. Determine which host directory will contain your database and license file. The required size depends on your use case, see :ref:`operations-db-storage`.
 #. Copy the license file to the database directory.
 #. (optional) Connect to the qdb-http-server using ``docker exec -ti qdb-http-server /bin/bash``.
 #. (optional) Edit the qdb_httpd configuration file using ``vi /etc/qdb/qdb_httpd.conf``.
     * Set other values as needed. See :ref:`qdb_httpd-config-file-reference` for more information.
 #. (optional) Exit the qdb-http-server docker using ``exit``.

Test the Node
-------------

 #. Run the qdb image using ``docker run -d -p 2836:2836 -v <db-dir>:/var/lib/qdb --name qdb-server bureau14/qdb`` where <db-dir> is the database directory you selected above.
 #. (optional) Run the qdb-httpd image, connecting it to the qdb-server image using ``docker run --link qdb-server:db -d -p 8080:8080 --name qdb-http-server bureau14/qdb-http``.
 #. Verify the qdb-server and qdb-http-server docker images started without errors using ``docker ps``.
 #. Test the node for TCP configuration problems with ``qdb_max_conn``.


Test the Cluster
----------------

 #. Benchmark the cluster with ``qdb-benchmark``. See :doc:`../reference/qdb-benchmark` for more information.

