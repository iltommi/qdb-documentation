********
REST API
********

The REST API is a part of the *web-bridge*: https://github.com/bureau14/qdb-web-bridge

To install, please follow the instruction  on the GitHub project page.


Features available on all types of entries
==========================================

Get the list of tags attached to an entry
-----------------------------------------

This is the equivalent of :c:func:`qdb_get_tags` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>GET</span> /api/v1/entries/<span class='nx'>:alias</span>/tags
    </div>

Parameters
""""""""""

+-------------+-------------+---------+------------------------------------------------------------+
| Name        | Type        | Default | Description                                                |
+=============+=============+=========+============================================================+
| ``limit``   | ``integer`` | ``100`` | Max number of results                                      |
+-------------+-------------+---------+------------------------------------------------------------+

Response
""""""""

.. sourcecode:: javascript

    {
        "aliases": [
            ":alias1",
            ":alias2",
            // ...
        ],
        "links": {
            "next": "/api/v1/entries/:alias/tags?skip=100"
        }
    }

| Results are paginated.
| A link to the next page is provided in the response.
| The link is not present on the last page.


Attaching a tag to an entry
---------------------------

This is the equivalent of :c:func:`qdb_add_tag` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>PATCH</span> /api/v1/entries/<span class='nx'>:alias</span>?action=addTag&tag=<span class='nx'>:tag</span></pre>
    </div>


Attaches the tag ``:tag`` to the entry ``:alias``.

The entry must exist. The entry can be a tag, in fact you can even attach a tag to itself.

Parameters
""""""""""

+------------+------------+-------------------------------------+
| Name       | Type       | Description                         |
+============+============+=====================================+
| ``action`` | ``string`` | Type of operation, must be "addTag" |
+------------+------------+-------------------------------------+
| ``tag``    | ``string`` | The alias of the tag to attach      |
+------------+------------+-------------------------------------+

Response
""""""""

+-------------+-----------------+-------------------------------------------------------+
| HTTP Status | Meaning         | Description                                           |
+=============+=================+=======================================================+
| ``200``     | Success         | Tag is now attached to the specified entry            |
+-------------+-----------------+-------------------------------------------------------+
| ``304``     | Not Modified    | Tag was already attached to the specified entry       |
+-------------+-----------------+-------------------------------------------------------+
| ``404``     | Not Found       | Entry doesn't exist                                   |
+-------------+-----------------+-------------------------------------------------------+
| ``422``     | Operation Error | Cannot attach the tag.                                |
|             |                 | Most likely because the specified alias is not a tag. |
|             |                 | See response content for details                      |
+-------------+-----------------+-------------------------------------------------------+
| ``5xx``     | Server Error    | See error message in response's content               |
+-------------+-----------------+-------------------------------------------------------+


Detaching a tag from an entry
-----------------------------

This is the equivalent of :c:func:`qdb_remove_tag` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>PATCH</span> /api/v1/entries/<span class='nx'>:alias</span>?action=removeTag&tag=<span class='nx'>:tag</span></pre>
    </div>


Detaches the tag ``:tag`` from the entry ``:alias``.

Parameters
""""""""""

+------------+------------+----------------------------------------+
| Name       | Type       | Description                            |
+============+============+========================================+
| ``action`` | ``string`` | Type of operation, must be "removeTag" |
+------------+------------+----------------------------------------+
| ``tag``    | ``string`` | The alias of the tag to detach         |
+------------+------------+----------------------------------------+

Response
""""""""

+-------------+-----------------+-------------------------------------------------------+
| HTTP Status | Meaning         | Description                                           |
+=============+=================+=======================================================+
| ``200``     | Success         | Tag is now detached from the specified entry          |
+-------------+-----------------+-------------------------------------------------------+
| ``304``     | Not modified    | Tag was not attached to the specified entry           |
+-------------+-----------------+-------------------------------------------------------+
| ``404``     | Not found       | Entry doesn't exist                                   |
+-------------+-----------------+-------------------------------------------------------+
| ``422``     | Operation Error | Cannot detach the tag.                                |
|             |                 | Most likely because the specified alias is not a tag. |
|             |                 | See response content for details                      |
+-------------+-----------------+-------------------------------------------------------+
| ``5xx``     | Server Error    | See error message in response's content               |
+-------------+-----------------+-------------------------------------------------------+



Removing an entry from the database
-----------------------------------

This is the equivalent of :c:func:`qdb_remove` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>DELETE</span> /api/v1/entries/<span class='nx'>:alias</span></pre>
    </div>


Parameters
""""""""""

None.

Response
""""""""

+-------------+--------------+-----------------------------------------+
| HTTP Status | Meaning      | Description                             |
+=============+==============+=========================================+
| ``200``     | Success      | Entry is now removed                    |
+-------------+--------------+-----------------------------------------+
| ``404``     | Not found    | Entry doesn't exist                     |
+-------------+--------------+-----------------------------------------+
| ``5xx``     | Server Error | See error message in response's content |
+-------------+--------------+-----------------------------------------+


Changing the expiry time of an entry
------------------------------------

This is the equivalent of :c:func:`qdb_expires_at` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>PATCH</span> /api/v1/entries/<span class='nx'>:alias</span>?action=setExpiry&expiry=<span class='nx'>:expiry</span></pre>
    </div>


Parameters
""""""""""

+------------+-------------+-------------------------------------------------+
| Name       | Type        | Description                                     |
+============+=============+=================================================+
| ``action`` | ``string``  | Type of operation, must be "setExpiry"          |
+------------+-------------+-------------------------------------------------+
| ``expiry`` | ``integer`` | The UNIX timestamp, or 0 if entry never expires |
+------------+-------------+-------------------------------------------------+

Response
""""""""

+-------------+-----------------+----------------------------------------------------------------+
| HTTP Status | Meaning         | Description                                                    |
+=============+=================+================================================================+
| ``204``     | Success         | Expiry time changed                                            |
+-------------+-----------------+----------------------------------------------------------------+
| ``404``     | Not found       | Entry doesn't exist                                            |
+-------------+-----------------+----------------------------------------------------------------+
| ``422``     | Operation Error | Cannot set expiry time.                                        |
|             |                 | Most likely because that type of entry doesn't support expiry. |
|             |                 | See response content for details                               |
+-------------+-----------------+----------------------------------------------------------------+
| ``5xx``     | Server Error    | See error message in response's content                        |
+-------------+-----------------+----------------------------------------------------------------+



Searching entry by prefix
-------------------------

This is the equivalent of :c:func:`qdb_prefix_get` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>GET</span> /api/v1/entries?prefix=<span class='nx'>:prefix</span>
    </div>

Gets the list of entries whose alias start with ``:prefix``.

Parameters
""""""""""

+------------+-------------+---------+---------------------------------------------------------------------------+
| Name       | Type        | Default | Description                                                               |
+============+=============+=========+===========================================================================+
| ``prefix`` | ``string``  |         | Alias prefix: entries whose name starts with this string will be returned |
+------------+-------------+---------+---------------------------------------------------------------------------+
| ``limit``  | ``integer`` | ``100`` | Max number of results                                                     |
+------------+-------------+---------+---------------------------------------------------------------------------+

Response
""""""""

.. sourcecode:: javascript

    {
        "aliases": [
            ":alias1",
            ":alias2",
            // ...
        ],
        "links": {
            "next": "/api/v1/entries?prefix=:prefix&skip=100"
        }
    }

| Results are paginated.
| A link to the next page is provided in the response.
| The link is not present on the last page.


Features available on blobs
===========================

Getting information on a blob
-----------------------------

This has not equivalent in the C API

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>GET</span> /api/v1/blobs/<span class='nx'>:alias</span>
    </div>

Parameters
""""""""""

None.

Response
""""""""

.. sourcecode:: javascript

    {
        "alias": ":alias",
        "type": "blob",
        "mime": "text/plain", // the MIME type (as detected by libmagic)
        "size": 1024, // the size of the blob, in bytes
        "expiry": 1469149260, // UNIX timestamp, or 0 if entry never expires
        "links": {
            "self": "/api/v1/blobs/:alias",
            "content": "/api/v1/blobs/:alias/content",
            "tags": "/api/v1/blobs/:alias/tags"
        }
    }


Creating a blob
---------------

This is the equivalent of :c:func:`qdb_blob_put` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>POST</span> /api/v1/blobs/<span class='nx'>:alias</span>
    </div>

    <div>
        The content of the blob must be sent in the request content.
    </div>

Parameters
""""""""""

None.

Response
""""""""

+-------------+-----------------+-----------------------------------------------+
| HTTP Status | Meaning         | Description                                   |
+=============+=================+===============================================+
| ``201``     | Success         | Blob created successfully                     |
+-------------+-----------------+-----------------------------------------------+
| ``422``     | Operation Error | Cannot create the blob.                       |
|             |                 | Most likely because the entry already exists. |
|             |                 | See response content for details              |
+-------------+-----------------+-----------------------------------------------+
| ``5xx``     | Server Error    | See error message in response's content       |
+-------------+-----------------+-----------------------------------------------+


Updating a blob
---------------

This is the equivalent of :c:func:`qdb_blob_get` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>PUT</span> /api/v1/blobs/<span class='nx'>:alias</span>/content
    </div>

    <div>
        The content of the blob must be sent in the request content.
    </div>

Parameters
""""""""""

None.

Response
""""""""

+-------------+-----------------+---------------------------------------------------------+
| HTTP Status | Meaning         | Description                                             |
+=============+=================+=========================================================+
| ``204``     | Success         | Blob updated successfully                               |
+-------------+-----------------+---------------------------------------------------------+
| ``422``     | Operation Error | Cannot update the blob.                                 |
|             |                 | Most likely because the entry exists but is not a blob. |
|             |                 | See response content for details                        |
+-------------+-----------------+---------------------------------------------------------+
| ``5xx``     | Server Error    | See error message in response's content                 |
+-------------+-----------------+---------------------------------------------------------+


Reading the content of a blob
-----------------------------

This is the equivalent of :c:func:`qdb_blob_get` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>GET</span> /api/v1/blobs/<span class='nx'>:alias</span>/content
    </div>

Parameters
""""""""""

None.

Response
""""""""

+-------------+-----------------+---------------------------------------------------------+
| HTTP Status | Meaning         | Description                                             |
+=============+=================+=========================================================+
| ``200``     | Success         | The blob's content is in the HTTP response content      |
+-------------+-----------------+---------------------------------------------------------+
| ``404``     | Not Found       | The entry doesn't exist                                 |
+-------------+-----------------+---------------------------------------------------------+
| ``422``     | Operation Error | Cannot create the blob.                                 |
|             |                 | Most likely because the entry exists but is not a blob. |
|             |                 | See response content for details                        |
+-------------+-----------------+---------------------------------------------------------+
| ``5xx``     | Server Error    | See error message in response's content                 |
+-------------+-----------------+---------------------------------------------------------+


Finding a blob by its content
-----------------------------

This is the equivalent of :c:func:`qdb_blob_scan` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>GET</span> /api/v1/entries?pattern=<span class='nx'>:pattern</span>
    </div>

Gets the list of blobs which contains the specified by sequence.

Parameters
""""""""""

+-------------+-------------+---------+-----------------------------------------+
| Name        | Type        | Default | Description                             |
+=============+=============+=========+=========================================+
| ``pattern`` | ``string``  |         | Byte sequence to look for (url-encoded) |
+-------------+-------------+---------+-----------------------------------------+
| ``limit``   | ``integer`` | ``100`` | Max number of results                   |
+-------------+-------------+---------+-----------------------------------------+

Response
""""""""

.. sourcecode:: javascript

    {
        "aliases": [
            ":alias1",
            ":alias2",
            // ...
        ],
        "links": {
            "next": "/api/v1/entries?pattern=:pattern&skip=100"
        }
    }

| Results are paginated.
| A link to the next page is provided in the response.
| The link is not present on the last page.


Features available on tags
===========================

Getting information on a tag
-----------------------------

This has not equivalent in the C API

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>GET</span> /api/v1/tags/<span class='nx'>:alias</span>
    </div>

Parameters
""""""""""

None.

Response
""""""""

.. sourcecode:: javascript

    {
        "alias": ":alias",
        "type": "tag",
        "links": {
            "self": "/api/v1/tags/:alias",
            "entries": "/api/v1/tags/:alias/entries",
            "tags": "/api/v1/tags/:alias/tags"
        }
    }


Getting the list of tagged entries
----------------------------------

This is the equivalent of :c:func:`qdb_get_tagged` in the C API.

Query
"""""

.. raw:: html

    <div class='highlight'>
        <pre><span class='kd'>GET</span> /api/v1/tags/<span class='nx'>:alias</span>/entries
    </div>

Parameters
""""""""""

+-------------+-------------+---------+------------------------------------------------------------+
| Name        | Type        | Default | Description                                                |
+=============+=============+=========+============================================================+
| ``limit``   | ``integer`` | ``100`` | Max number of results                                      |
+-------------+-------------+---------+------------------------------------------------------------+

Response
""""""""

.. sourcecode:: javascript

    {
        "aliases": [
            ":alias1",
            ":alias2",
            // ...
        ],
        "links": {
            "next": "/api/v1/tags/:alias/entries?skip=100"
        }
    }

| Results are paginated.
| A link to the next page is provided in the response.
| The link is not present on the last page.