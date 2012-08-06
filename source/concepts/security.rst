Security
**************************************************

Privileges
------------
wrpme does not need any specific privileges and it is strongly discouraged to run the daemon with an account that has administrative privileges.

wrpme only need to be able to listen to a TCP port, to write to its log files and to write to disk to persist entries.

Authentication
----------------
There is no authentication mechanism of any sort, access to the server implies access to all the entries, should the key be known. 

If the data to store is sensitive, it is strongly advised to cipher this data.

wrpme is generally used within a "safe" zone and it is strongly discouraged to expose a wrpme cluster directly to the public (for example on the Internet). 

Should write access be given, a better approach is to design a proxy client that will authenticate and sanitize requests before handing them over to wrpme.

Design
-------
The wrpme protocol, especially the serialization part, has been designed to resist buffer overflows and most of current denial of service (DOS) attacks, keep in mind however that wrpme is *designed* to accept large amounts of requests and will therefore not limit incoming or outgoing requests.

