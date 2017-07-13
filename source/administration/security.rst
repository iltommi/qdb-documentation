Security
**************************************************

Privileges
------------
quasardb does not need administrative privileges. Running the daemon as an account with administrative privileges is strongly discouraged.

quasardb only needs the following privileges:

  * The ability to listen on a TCP port. The default port is 2836.
  * Read and write-permission on the hard drive to persist entries. The default location is ``./db/``.
  * Read and write-permission to its log files, if enabled. Log files are disabled by default.

For more information on how to change the quasardb daemon configuration for your environment, see :doc:`../reference/qdbd`.

Authentication
---------------
QuasarDB has a built-in authentication mechanism based on asymetric cryptography, supports end-to-end strong encryption as well as message integrity.

..note::
    The key exchange algorithm used is X25519, encryption is done with the XSalsa20 stream cipher, and authentication is made using Poly1305 MAC. The implementation is based on libsodium.

When configuring a cluster, the administrator must generate a long-term cluster key pair that will be reused for the nodes within the cluster, the public key part will be used by the clients connecting to the cluster, whereas the secret key should only be kept on the server and must never be communicated to any client (see :doc:`../reference/qdb_cluster_keygen`).

The admnistrator then must add users to the cluster. Each user has a long-term key pair made of a private (also known as secret) key and public key. The server will keep the public key of each user will keep the secret authentication information (see :doc:`../reference/qdb_user_add`).

It is possible to completely disable security and authentication, for example for test clusters or clusters running in physically secure environments.

Perfect forward secrecy
-----------------------
The QuasarDB security protocol provides perfect forward secrecy by default. This means that communications recorded in the past cannot be decoded should any of the long-term private key be compromised.

Each client connecting to the cluster uses a two phase authentication where a temporary, short-term key pair is generated and exchanged using the long-term keys to generate a symmetric session key.

Design
-------

The quasardb protocol, especially the serialization layer, has been designed to resist buffer overflows and most of current denial of service (DoS) attacks. Keep in mind, however, that quasardb is *designed* to accept large amounts of requests or arbitraty sizes and will therefore not limit incoming or outgoing requests in any way.

