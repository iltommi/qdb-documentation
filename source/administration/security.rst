Security
**************************************************

Privileges
------------
quasardb does not need administrative privileges. Running the daemon as an account with administrative privileges is strongly discouraged.

quasardb only needs the following privileges:

  * The ability to listen on a TCP port. The default port is 2836.
  * Read and write-permission on the hard drive to persist entries. The default location is ./db/.
  * Read and write-permission to its log files, if enabled. Log files are disabled by default.

For more information on how to change the quasardb daemon configuration for your environment, see :doc:`../reference/qdbd`.

Authentication
----------------
There is no authentication mechanism of any sort; access to the server implies access to any entry, should the key be known. 

If the stored data is sensitive, it is strongly advised to cipher this data.

quasardb is generally used within an internal network. It is strongly discouraged to expose a quasardb cluster directly to the public (for example on the Internet). 

Should public write access be necessary, a better approach is to design a proxy client that will authenticate and sanitize requests before handing them over to quasardb.

Design
-------

The quasardb protocol, especially the serialization layer, has been designed to resist buffer overflows and most of current denial of service (DoS) attacks. Keep in mind, however, that quasardb is *designed* to accept large amounts of requests or arbitraty sizes and will therefore not limit incoming or outgoing requests in any way.

