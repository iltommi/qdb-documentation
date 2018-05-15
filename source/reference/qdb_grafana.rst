quasardb for Grafana
******************

Introduction
============

Official QuasarDB Grafana plugin. It extends QuasarDB's support to allow integration with the _Grafana: https://grafana.com analytics and monitoring platform. You may read and download the connector's code from GitHub at  `<https://github.com/bureau14/qdb-grafana-plugin>`_


Prerequisites
=============

This documentation assumes you have:

- _Grafana: https://grafana.com installed;
- The latest version of _Node.JS: https://nodejs.org/ installed;
- The latest version of _YARN: https://yarnpkg.com/ installed;
- Both the QuasarDB daemon ``qdbd`` and the HTTP bridge ``qdb_httpd`` running.


Installation
============

Go to your Grafana plugins directory. On Linux-based systems, this is usually ``/var/lib/grafana/plugins``. Go to this directory and clone the Git repository like this:

.. code-block::

   grafana@server /var/lib/grafana/plugins # git clone https://github.com/bureau14/qdb-grafana-plugin.git
   Cloning into 'qdb-grafana-plugin'...
   remote: Counting objects: 139, done.
   remote: Compressing objects: 100% (35/35), done.
   remote: Total 139 (delta 21), reused 27 (delta 12), pack-reused 92
   Receiving objects: 100% (139/139), 83.72 KiB | 0 bytes/s, done.
   Resolving deltas: 100% (56/56), done.
   Checking connectivity... done.

Switch to this directory and build the plugin:

.. code-block::
   grafana@server /var/lib/grafana/plugins # cd qdb-grafana-plugin/
   grafana@server /var/lib/grafana/plugins/qdb-grafana-plugin # yarn install
   yarn install v1.6.0
   [...]
   Done in 3.27s
   grafana@server /var/lib/grafana/plugins/qdb-grafana-plugin # yarn build
   yarn run v1.6.0
   [..]
   Done in 1.20s.
   grafana@server

After this, restart your grafana server and the plugin should be added automatically.

Configuration
=============

Navigate your web browser to Grafana's datasource configuration, and click 'Add data source'. You will see *QuasarDB* as one of the available data sources. Configure the data source as follows:

.. image:: qdb_grafana_datasource_configuration.gif

The HTTP URL might differ in your configuration: it should point to the endpoint where ``qdb_httpd`` is running. This service is running on port ``8080`` by default.

After you are done, click *Save & Test* and you are ready to starting creating visualizations using QuasarDB.
