Security
**************************************************

Privileges
------------
quasardb does not need any specific privileges and it is strongly discouraged to run the daemon with an account that has administrative privileges.

quasardb only need to be able to listen to a TCP port, to write to its log files and to write to disk to persist entries.

Authentication
----------------
There is no authentication mechanism of any sort, access to the server implies access to any entry, should the key be known. 

If the data to store is sensitive, it is strongly advised to cipher this data.

quasardb is generally used within a "safe" zone and it is strongly discouraged to expose a quasardb cluster directly to the public (for example on the Internet). 

Should write access be given, a better approach is to design a proxy client that will authenticate and sanitize requests before handing them over to quasardb.

Design
-------

The quasardb protocol, especially the serialization part, has been designed to resist buffer overflows and most of current denial of service (DOS) attacks. Keep in mind, however, that quasardb is *designed* to accept large amounts of requests or arbitraty sizes and will therefore not limit incoming or outgoing requests in any way.

