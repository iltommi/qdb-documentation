Network protocol
**************************************************

Description
=====================================================

A client needs to know the address of only one node within the hive to request a hive. The only requirement is that the node needs to be fully joined. A node needs only a couple of minutes after startup to be fully joined.

When a request is made, an ID is computed from the alias (with the `SHA-3 <http://en.wikipedia.org/wiki/Skein_(hash_function)>`_ algorithm) and the ring is explored to find the proper node. If the ring cannot be explored because it's too unstable, the client will return an "unstable" error code (see :ref:`fault-tolerance`).

Once the proper node has been found, the request is sent. 

If the topology has changed between the time the node has been found and the request has been made, the target node will return a "wrong node" error to the client, and the client will search again for the valid node.

A client attempts to locate the valid node only three times. In other words, three consecutive errors will result in a definitive error returned to the user.

Data management
=====================================================

Data is sent and stored "as is", bit for bit. The user may add any kind of content to the wrpme hive, provided that the nodes have sufficient storage space. wrpme uses a low-level binary protocol that adds only few bytes of overhead per request.

Most high levels API support the language native serialization mechanism to transparently add and retrieve objects to/from a wrpme hive (see :doc:`../api/index`).

Metadata is associated with each entry. The wrpme hive ensures the metadata and the actual data are consistent at all time. 

.. note::
    It is currently not possible to obtain the metadata via the API.


Timeout
=====================================================

If the server does not reply to the client in the specified delay, the client will drop the request and return a "timeout" error code. This timeout is configurable and defaults to one minute.


