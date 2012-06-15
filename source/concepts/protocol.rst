Network protocol
**************************************************

Description
=====================================================

The client needs to know only one node from the hive to do requests. The only requirement is that the node needs to have finished joining the ring.

When a request is made, an ID is computed from the alias and the ring is explored to find the proper node. If the ring cannot be explored because it's too unstable, the client will return an "unstable" error code (see :ref:`fault-tolerance`).

Once the proper node has been found, the request is sent. Of course, if the topology has changed between the time the node has been found and the request has been made, the target node will return a "wrong node" error to the client, and the client will search again for the valid node.

A client attempts to locate the valid node only three times. That means that three consecutive errors will result in a definitive error returned to the user.


Data management
=====================================================

Data is sent and stored "as is", bit for bit. The user may add any kind of content to the wrpme hive, provided that the nodes have sufficient storage space. wrpme uses a low-level binary protocol that adds only few bytes of overhead per request.

Most high levels API support the language native serialization mechanism to transparently add and retrives objects to a wrpme hive (see :doc:`../api/index`).

Metadata is associated with each entry. The wrpme hive ensures the metadata and the actual data are consistent at all time. 

.. note::
    It is currently not possible to query the metadata via the API.


Timeout
=====================================================

If the server does not reply to the client in the specified delay, the client will drop the request and return a "timeout" error code. This timeout is configurable and defaults to one minute.


