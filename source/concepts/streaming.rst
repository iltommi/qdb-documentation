Streaming
**************************************************

Motivation
=======================================

wrpme can store entries of arbitrary size, limited only by the hardware capabilities of the hive's node. However, the server capability often exceeds the client's capability, especially in terms of memory.

Additionally, the client may wish to consume the content as it receives it and waiting for everything to be received can be counterproductive. 

For example, if you use a wrpme hive to store digital videos and clients are video players, it is expected to be able to display the video as you download it.


Usage
=====================================================

.. note:: The streaming API is currently only available in C (see :doc:`../api/c`), support for other languages will be added in future releases. One can currently stream entry *from* the server, but not *to* the server.

The typical usage scenario is the following:

    #. A client opens a streaming handle for a given entry. The default buffer size is 1 MiB. If it is inappropriate, it needs to be set *before* opening the streaming handle via the appropriate API call.
    #. The client reads content for the entry. The API automatically reads the next chunk of available data. The result of the read is placed in the API allocated buffer.
    #. The client processes the buffer. For example, it may send the buffer to a video decoder.
    #. The client may manually set the offset if need be. Positioning the offset beyond the end results in an error.
    #. The client stops reading when the offset reaches the end. Reading beyond the end will result in an error.
    #. The client closes the handle. This frees all resources.

.. important::
    The streaming buffer is allocated by the API. The client should only read from the buffer and never attempt to free it manually. All resources are freed when the streaming handle is closed.

Conflicts
=====================================================

By design, streaming an entry does not "lock" access to this entry. This is to prevent a client that does not properly close its streaming handle to "lock out" an entry.

Therefore, streaming is one of the rare operations that is not ACID. When you stream an entry from the server, if this entry is updated by another client, the next call will result in a "conflicting operation" error and streaming will no longer be possible.

The client must therefore close its streaming handle and reopen a new one to resume streaming. It may set the offset to the previous position if need be (and if the updated entry is large enough to support the operation).

If another client removes the entry as you stream it, the next call will result in a "not found" error and streaming will no longer be possible.

