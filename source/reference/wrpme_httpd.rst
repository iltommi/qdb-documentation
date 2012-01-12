wrpme web server
****************

.. highlight:: js

Introduction
============

The wrpme web server is a web bridge that enables any software that understands JSON or JSONP to communicate with a wrpme :term:`cluster`.

Launching the web server
========================

The web server binary is wrpme_httpd (wrpme_httpd.exe on Windows). By default it listens on the IPv4 localhost (127.0.0.1) and the port 8080. It does not require specific privileges to run (i.e. you don't need to run the server from an administrator account). 
This can be configured, see :ref:`wrpme_httpd-parameters-reference`

In other words, for most cases, the command line will look as: ::

    ./wrpme_httpd &

or on Windows: ::

    wrpme_httpd

Interfacing with the cluster
==============================

To function properly, the web server must:

 #. Run on the same :term:`node` than a wrpme :term:`server` from the :term:`cluster` you wish to interface to. It is of course possible to run one web server per node but this is not necessary.
 #. Run with privileges greater or equal than the wrpme server. The most practical solution is to run as the same user.
 #. If the daemon does not listen on the default port, you must specify the daemon's port with the daemon-port option.

If these two conditions are met the web server is *hot plug'n'play*. In other words:

 * No configuration on the cluster nor on the web server is required.
 * There is no launch order. The cluster can be started after the web server and vice versa.
 * The web server can be stopped and started at any time without any information loss.
 * The content provided by the web server is *real time*.

Using the server
================

The server accepts specific URLs (See :ref:`wrpme_httpd-url-reference`) and will service data depending on the URL and its parameters.

If the URL does not exists, the server will return a page not found (404) error.

.. _wrpme_httpd-parameters-reference:

Parameters reference
====================

Parameters can be supplied in any order and are prefixed with ``--``. The arguments format is parameter dependent.

.. program:: wrpme_httpd

.. option:: -h, --help

    Displays basic usage information.

    Example
        To display the online help, type: ::

            wrpme_httpd --help

.. option:: -a <address>:<port>, --address=<address>:<port>

    Specifies the address and port on which the server will listen.

    Argument
        A string representing one address the server listens on and a port. The string can be a host name or an IP address.

    Default value
        127.0.0.1:8080, the IPv4 localhost and the port 8080

    Example
        Listen on all addresses and the port 80::

            wrpmed --address=0.0.0.0:80

.. option:: -t <count>, --threads=<count>

    Specifies the number of threads to use. May improve performance.

    Argument
        An integer greater than 0 representing the number of listening threads.

    Default value
        1

    Example
        To use two listening threads::

            wrpme_httpd --threads=2

.. option:: --daemon <address>:<port>

   Specifies the address and port of the daemon daemon on which the server will connect.

   Argument
        The address and port of a machines where a wrpme daemon is running.

   Default value
        127.0.0.0:5909, the IPv4 localhost address and the port 5909

   Example
        If the daemon listen on the localhost and on the port 5009::

            wrpme_httpd --daemon-port=localhost:5009

.. option:: -o, --log-console

    Activates logging on the console.

.. option:: -l <path>, --log-file=<path>

    Activates logging to one or several files.

    Argument
        A string representing one (or several) path(s) to the log file(s).

    Example
        Log in /var/log/wrpmed.log: ::

            wrpme_httpd --log-file=/var/log/wrpmed.log

.. option:: --log-level=<value>

    Specifies the log verbosity.

    Argument
        A string representing the amount of logging required. Must be one of:

        * detailed (most output)
        * debug
        * info
        * warning
        * error
        * panic (least output)

    Default value
        info

    Example
        Request a debug level logging: ::

            wrpme_httpd --log-level=debug

.. option:: --log-flush-interval=<delay>

    How frequently log messages are flushed to output, in seconds.

    Argument
        An integer representing the number of seconds between each flush.

    Default value
        3

    Example
        Flush the log every minute: ::

            wrpme_httpd --log-flush-interval=60



.. highlight:: html

.. _wrpme_httpd-url-reference:

URL reference
=============

.. describe:: get

    Obtain an :term:`entry` from the cluster.

    :param alias: specifies the :term:`alias` of the entry to obtain.
    :param callback: *(optional)* specifies a callback in order to obtain JSONP output instead of JSON (required for cross site scripting).
    :returns: A JSON or JSONP structure containing the alias and :term:`content` (in Base64) of the entry. If the entry cannot be found, the content string will be empty.

    *Schema*::

        {
            "name":"get",
            "properties":
            {
                "alias":
                {
                    "type":"string",
                    "description":"alias name of the entry",
                    "required":true
                },
                "content":
                {
                    "type":"string",
                    "description":"Base64 encoding of the entry's content",
                    "required":true
                }
            }
        }

    *Example*:
        Get the entry with the alias ``MyData`` from the server ``myserver.org listening`` on the port 8080::
            
            http://myserver.org:8080/get?alias=MyData

    .. note::
        Requesting large entries (i.e., larger than 10 MiB) through the web bridge is not recommended.

.. describe:: global_status

    Displays global statistics.

    :param callback: *(optional)* specifies a callback in order to obtain JSONP output instead of JSON (required for cross site scripting).
    :returns: A JSON or JSONP structure with up-to-date statistics.

    *Schema*::

        {
            "name":"global_status",
            "properties":
            {
                "node_id":
                {
                    "type":"string",
                    "description":"the unique 256-bit identifier of the node",
                    "required":true
                },
                "listening_addresses":
                {
                    "type":"array",
                    "items":
                    {
                        "type":"string"
                    },
                    "description":"the addresses and port the daemon listens on",
                    "required":true
                },
                "timestamp":
                {
                    "type":"string",
                    "description":"the timestamp of the latest statistics update",
                    "required":true
                },
                "startup":
                {
                    "type":"string",
                    "description":"the startup timestamp",
                    "required":true
                },
                "engine_version":
                {
                    "type":"string",
                    "description":"the engine version",
                    "required":true
                },
                "engine_build_date":
                {
                    "type":"string",
                    "description":"the engine build timestamp",
                    "required":true
                },

                "name":"entries",
                "properties":
                {
                    "count":
                    {
                        "type":"number",
                        "description":"the current number of entries in the cluster",
                        "required":true
                    },
                    "paged_count":
                    {
                        "type":"number",
                        "description":"the entries on the cluster that are paged to disk",
                        "required":true
                    },
                    "max_count":
                    {
                        "type":"number",
                        "description":"the maximum allowed count of entries in memory",
                        "required":true
                    },
                    "size":
                    {
                        "type":"number",
                        "description":"the current amount of data, in bytes, managed by the cluster",
                        "required":true
                    },
                    "max_size":
                    {
                        "type":"number",
                        "description":"the maximum allowed amount of data in memory",
                        "required":true
                    },
                    "add_count":
                    {
                        "type":"number",
                        "description":"the total number of adds performed on the cluster",
                        "required":true
                    },
                    "update_count":
                    {
                        "type":"number",
                        "description":"the total number of updates performed on the cluster",
                        "required":true
                    },
                    "remove_count":
                    {
                        "type":"number",
                        "description":"the total number of removals performed on the cluster",
                        "required":true
                    },
                    "get_count":
                    {
                        "type":"number",
                        "description":"the total number of gets performed on the cluster",
                        "required":true
                    },
                    "eviction_count":
                    {
                        "type":"number",
                        "description":"the number of entries that have been evicted",
                        "required":true
                    },
                    "pagein_count":
                    {
                        "type":"number",
                        "description":"the number of entries that have been paged in",
                        "required":true
                    }
                }
            }
        }

    *Example*:
        Regular JSON output from the server myserver.org listening on the port 8080::
            
            http://myserver.org:8080/global_status

        JSONP output with a callback named "MyCallback" from the server myserver.org listening on the port 8080::
            
            http://myserver.org:8080/global_status?callback=MyCallback

.. describe:: view

    Interactive node status display.

    :returns: HTML 5 and javascript code to be rendered in a capable browser that represent the current node status.
