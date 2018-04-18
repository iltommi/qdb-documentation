quasardb shell
**************

.. program:: qdbsh

Introduction
============

The quasardb shell is a command line tool that enables you to add, update, delete and retrieve entries from a quasardb node or cluster.
The shell can be used interactively and non-interactively.
In :ref:`interactive mode <qdbsh-interactive-mode>`, the user enters commands to be executed on the node. Feedback is provided to indicate failure.
In :ref:`non-interactive mode <qdbsh-noninteractive-mode>`, a single command - supplied as a parameter - is executed and the program exits.

By default `qdbsh` will attempt to connect in interactive mode to a `qdbd` daemon running on 127.0.0.1:2836. If this is not the case - for example if your `qdbd` daemon runs on 192.168.1.1 and listens on the port 303 - you will need to pass the address and port as a ``qdb://`` URI string, shown below::

    qdbsh qdb://192.168.1.1:303

When connecting to a cluster, any node within the cluster is capable of servicing requests. There is no "master" or "preferred" node. There is no performance impact of choosing one node instead of the other, except, perhaps, the physical capabilities of the node.


Quick Reference
===============

Command line options
---------------------

 ===================================== ============================ ====================
                Option                             Usage                Default
 ===================================== ============================ ====================
 :option:`-h`, :option:`--help`        display help
 :option:`-v`, :option:`--version`     display quasardb version
 :option:`-c`                          run a qdb command
 ===================================== ============================ ====================

Commands
--------

 =================================================================================== =================================================================
                Command                                                                                Usage
 =================================================================================== =================================================================
 :ref:`help <qdbsh_help>`                                                             display the help
 :ref:`exit <qdbsh_exit>`                                                             exit the shell (interactive mode only)
 :ref:`blob_compare_and_swap alias content comparand <qdbsh_blob_compare_and_swap>`   atomically compare and swap the Blob with the comparand
 :ref:`blob_get alias <qdbsh_blob_get>`                                               return the content of the Blob
 :ref:`blob_get_and_update alias content <qdbsh_blob_get_and_update>`                 atomically get and update the Blob
 :ref:`blob_put alias content <qdbsh_blob_put>`                                       create a new Blob; fails if Blob already exists
 :ref:`blob_remove_if alias comparand <qdbsh_blob_remove_if>`                         remove the Blob if the value matches the comparand
 :ref:`blob_update alias content <qdbsh_blob_update>`                                 update an existing Blob or creates a new Blob
 :ref:`cluster_purge <qdbsh_cluster_purge>`                                           remove ALL entries on the WHOLE cluster (dangerous!)
 :ref:`cluster_trim <qdbsh_cluster_trim>`                                             remove unused versions of entries from the cluster
 :ref:`cluster_status <qdbsh_cluster_status>`                                         print status information about a cluster
 :ref:`expires_at alias expiry <qdbsh_expires_at>`                                    set the absolute expiry time of the entry
 :ref:`expires_from_now alias delta <qdbsh_expires_from_now>`                         set the expiry time of the entry to seconds relative to now
 :ref:`get_expiry alias <qdbsh_get_expiry>`                                           return the absolute expiry time of the entry
 :ref:`get_type alias <qdbsh_get_type>`                                               return the type of the entry
 :ref:`remove alias <qdbsh_remove>`                                                   remove the entry from the cluster
 :ref:`int_add alias value <qdbsh_int_add>`                                           atomically increment the Integer by the value
 :ref:`int_get alias <qdbsh_int_get>`                                                 return the value of the Integer
 :ref:`int_put alias value <qdbsh_int_put>`                                           create a new Integer; fails if Integer already exists
 :ref:`int_update alias value <qdbsh_int_update>`                                     update an existing Integer or create a new Integer
 :ref:`node_config host <qdbsh_node_config>`                                          return the node configuration as a JSON string
 :ref:`node_status host <qdbsh_node_status>`                                          return the node status as a JSON string
 :ref:`node_stop host reason <qdbsh_node_stop>`                                       shut down the quasardb daemon on a host
 :ref:`node_topology host reason <qdbsh_node_topology>`                               return the node topology as a JSON string
 :ref:`deque_back alias <qdbsh_deque_back>`                                           return the value at the back of the Deque
 :ref:`deque_front alias <qdbsh_deque_front>`                                         return the value at the front of the Deque
 :ref:`deque_pop_back alias <qdbsh_deque_pop_back>`                                   remove and return the value from the back of the Deque
 :ref:`deque_pop_front alias <qdbsh_deque_pop_front>`                                 remove and return the value from the front of the Deque
 :ref:`deque_push_back alias content <qdbsh_deque_push_back>`                         add a value to the back of the Deque
 :ref:`deque_push_front alias content <qdbsh_deque_push_front>`                       add a value to the front of the Deque
 :ref:`attach_tag alias tag <qdbsh_attach_tag>`                                       add a tag to an entry
 :ref:`detach_tag alias tag <qdbsh_detach_tag>`                                       removes a tag from an entry
 :ref:`get_tagged tag <qdbsh_get_tagged>`                                             get entries with the given tag
 :ref:`has_tag alias tag <qdbsh_has_tag>`                                             returns true if the entry has the tag
 :ref:`stream_to_buffer alias <qdbsh_stream_to_buffer>`                               dumps the content of a stream
 :ref:`stream_from_buffer alias content <qdbsh_stream_from_buffer>`                   write content into a stream
 :ref:`stream_to_file alias file_path <qdbsh_stream_to_file>`                         dumps the content of a stream into a file
 :ref:`stream_from_file alias file_path <qdbsh_stream_from_file>`                     loads a file and adds it into a file
 :ref:`version <qdbsh_version>`                                                       display the quasardb version

 =================================================================================== =================================================================


.. _qdbsh-interactive-mode:

Interactive mode
================

Use `qdbsh` interactive mode to enter as many commands as needed. The shell provides you with feedback upon success and failure or displays the content of retrieved entries.

Unless otherwise specified, `qdbsh` assumes the daemon is running on localhost and on the port 2836.

Once `qdbsh` has connected to a cluster, the following prompt is displayed::

    qdbsh >

This means the shell is ready to accept commands. Only one command at a time may be specified.

**A command is executed as soon as Enter is pressed and cannot be canceled or rolled back.**

To exit the shell, enter the command ``exit``. To list the available commands, type ``help``.
For the list of supported commands, see :ref:`qdbsh-commands-reference`

If the command is expected to output content on success (such as the get command), it will be printed on the standard output stream.
**Binary content may not print correctly and may even corrupt your terminal display.**

If the previous command executes successfully, the prompt shows::

    qdbsh >

If the previous command fails, the prompt turns into::

    qdbsh!>

As of quasardb 2.0.0, `qdbsh` in interactive mode supports tab completion and command history (using the Up/Down and PgUp/PgDn keys).

Examples
--------

Add a new Blob named "alias" whose content is "content" and print it::

    qdbsh > blob_put alias content
    qdbsh > blob_get alias
    content
    qdbsh >

Remove an entry named "alias"::

    qdbsh > remove alias
    qdbsh >

.. _qdbsh-noninteractive-mode:

Non-interactive mode
====================

Use `qdbsh` non-interactive mode to run one command without waiting for any input. Non-interactive mode supports standard input and output and can be integrated in a tool chain à la Unix. Performance-wise, non-interactive mode implies establishing and closing a connection to the quasardb cluster every time the `qdbsh` executable is run.

The command to be executed is supplied as an argument to the :option:`-c` parameter. For the list of supported commands, see :ref:`qdbsh-commands-reference`.

When successful, the result of the command will be printed on the standard output stream and the shell will exit with the code 0. Most commands produce no output when successful (silent success).

In case of error, the shell will output an error message on the standard error output stream and will exit with the code 1.

Examples
--------

Unless otherwise specified, `qdbsh` assumes the daemon is running on localhost and on the port 2836.

Save the content of a Blob named "biography" in a text file named "biography.txt"::

    qdbsh -c blob_get biography > biography.txt


Compress a file named "myfile", then add its content to an entry named "myfile" on the quasardb node at 192.168.1.1: ::

    bzip2 -c myfile | qdbsh qdb://192.168.1.1:2836 -c blob_put myfile

.. _qdbsh-parameters-reference:

Reference
=========

Options
-------

Parameters can be supplied in any order and are prefixed with ``--``. The arguments format is parameter dependent. See :ref:`qdbsh-interactive-mode` for more information.

.. option:: -h, --help

    Displays basic usage information.

.. option:: -v, --version

    Displays the version information for the quasardb shell.

.. option:: -c <command>

   Specifies a command to run in non-interactive mode. For the list of supported commands, see :ref:`qdbsh-commands-reference`.

   Argument
        The command and required parameters for the command.

   Example
        If the `qdbd` daemon is on localhost and listens on port 3001 and we want to add an entry::

            qdbsh qdb://127.0.0.1:3001 -c blob_put title "There and Back Again: A Hobbit's Tale"

.. _qdbsh-commands-reference:

Commands
--------

A command generally requires one or several arguments. Each argument is separated by one or several space characters.


.. _qdbsh_help:
.. option:: help

    Display basic usage information and lists all available commands.

.. _qdbsh_exit:
.. option:: exit

    Exit the shell.

.. _qdbsh_cls:
.. option:: cls

    Clears the screen.

.. _qdbsh_show:
.. option:: show

    Display the content of a time series table.

.. _qdbsh_select:
.. option:: select

    Run a select query on the database.

.. _qdbsh_blob_compare_and_swap:
.. option:: blob_compare_and_swap <alias> <content> <comparand>

    Atomically compare the value of an existing Blob with the comparand and replace it with the new content in case of match. The Blob must already exist.

    :param alias: *(string)* the alias of the Blob
    :param content: *(string)* the new content of the Blob
    :param comparand: *(string)* the value to compare against content
    :return: *(string)* the original content of the Blob or an error message

    .. note::
        * The alias must not contain the space character and its length must be below 1024.
        * The new content must only be printable characters. This is only a `qdbsh` restriction.
        * There must be one space and only one space between the comparand and the content.
        * There is no practical limit to the comparand length. All characters until the end of the input are used for the comparand, including space characters.


.. _qdbsh_blob_get:
.. option:: blob_get <alias>

    Retrieve an existing Blob from the cluster and print it to standard output.

    :param alias: *(string)* the alias of the Blob
    :return: *(string)* the content of the Blob or an error message

    *Example*
        Retrive a Blob whose alias is "alias" and whose content is the string "content"::

            qdbsh > blob_get alias
            content
            qdbsh >

    .. note::
        * The alias must not contain the space character.
        * The alias must not be longer than 1024 characters.


.. _qdbsh_blob_get_and_update:
.. option:: blob_get_and_update <alias> <content>

    Atomically get the previous value of a Blob and replace it with the specified content. The Blob must already exist.

    :param alias: *(string)* the alias of the Blob
    :param content: *(string)* the new content of the Blob
    :return: *(string)* the content of the Blob or an error message

    *Example*
        Add a Blob whose alias is "myentry", and whose content is the string "MagicValue"::

            blob_put myentry MagicValue

        Update the content to "VeryMagicValue" and get the previous content::

            blob_get_and_update myentry MagicValue
            VeryMagicValue

    .. note::
        * The alias must not contain the space character and its length must be below 1024.
        * There must be one space and only one space between the alias and the content.
        * There is no practical limit to the content length. All characters until the end of the input are added to the content, including space characters.


.. _qdbsh_blob_put:
.. option:: blob_put <alias> <content>

    Add a new Blob to the cluster. The Blob must not already exist.

    :param alias: *(string)* the alias of the Blob
    :param content: *(string)* the content of the Blob
    :return: nothing if successful, an error message otherwise

    *Example*
        Add a Blob whose alias is "myentry" and whose content is the string "MagicValue"::

            blob_put myentry MagicValue

    .. note::
        * The alias must not contain the space character and its length must be below 1024.
        * There must be one space and only one space between the alias and the content.
        * There is no practical limit to the content length. All characters until the end of the input are added to the content, including space characters.


.. _qdbsh_blob_remove_if:
.. option:: blob_remove_if <alias> <comparand>

    Atomically compare the Blob with the comparand and remove it in case of match.

    :param alias: *(string)* The alias of the Blob
    :param comparand: *(string)* The value to compare against the content of the Blob
    :returns: true if the Blob was successfully removed, false otherwise.


.. _qdbsh_blob_update:
.. option:: blob_update <alias> <content>

    Add or update a Blob. If the Blob doesn't exist it is created, otherwise it is changed to the new specified value.

    :param alias: *(string)* the alias of the Blob
    :param content: *(string)* the content of the Blob
    :return: nothing if successful, an error message otherwise.

    *Example*
        Add a Blob whose alias is "myentry" and whose content is the string "MagicValue"::

            blob_update myentry MagicValue

        Change the value of the Blob "myentry" to the content "MagicValue2"::

            blob_update myentry MagicValue2

    .. note::
        * The alias cannot contain the space character and its length must be below 1024.
        * There must be one space and only one space between the alias and the content.
        * There is no practical limit to the content length and all characters until the end of the input will be added to the content, including space characters.


.. _qdbsh_cluster_purge:
.. option:: cluster_purge

    Remove all entries from the cluster. This command is not atomic. When activated:

      #. Replication and migration is stopped.
      #. The directories containing data and metadata are removed.
      #. All entries are cleared from memory.
      #. Replication and migration are restarted.

    :return: nothing if successful, an error message otherwise

    .. caution::
        All entries will be deleted and will not be recoverable. If the cluster is unstable, the command may not be executed by all nodes. The command will nevertheless return success.

.. _qdbsh_cluster_trim:
.. option:: cluster_trim

    Remove unused versions of entries from the cluster, freeing up disk space.

    :return: nothing if successful, an error message otherwise

.. _qdbsh_cluster_status:
.. option:: cluster_status

    Print status information about a cluster

    :return: information about the cluster status

.. _qdbsh_expires_at:
.. option:: expires_at <alias> <expiry>

    Set the expiry time of an existing entry from the quasardb cluster.

    :param alias: *(string)* A string with the alias of the entry for which the expiry must be set.
    :param expiry: *(string)* The absolute time at which the entry expires.
    :return: nothing if successful, an error message otherwise


.. _qdbsh_expires_from_now:
.. option:: expires_from_now <alias> <delta>

    Set the expiry time of an existing entry from the quasardb cluster.

    :param alias: *(string)* the alias of the entry for which the expiry must be set
    :param delta: *(string)* A time, relative to the call time, after which the entry expires
    :return: nothing if successful, an error message otherwise


.. _qdbsh_get_expiry:
.. option:: get_expiry <alias>

    Retrieve the expiry time of an existing entry.

    :param alias: *(string)* the alias of the entry
    :return: *(string)* the expiry time of the alias


.. _qdbsh_get_type:
.. option:: get_type <alias>

    Retrieve the type of an existing entry.

    :param alias: *(string)* the alias of the entry
    :return: *(string)* the type of the entry


.. _qdbsh_remove:
.. option:: remove <alias>

    Remove an entry from the cluster. The entry must already exist.

    :param alias: *(string)* the alias of the entry to delete
    :return: nothing if successful, an error message otherwise

    *Example*
        Removes an entry named "obsolete"::

            remove obsolete


.. _qdbsh_int_add:
.. option:: int_add <alias> <value>

    Atomically increment the Integer by the value

    :param alias: *(string)* the alias of the Integer
    :param value: *(string)* the value to add to the Integer
    :return: the value of the Integer after the addition


.. _qdbsh_int_get:
.. option:: int_get <alias>

    Return the value of the Integer

    :param alias: *(string)* the alias of the Integer
    :return: *(string)* the value of the Integer


.. _qdbsh_int_put:
.. option:: int_put <alias> <value>

    Add a new Integer to the cluster. The Integer must not already exist.

    :param alias: *(string)* the alias of the Integer
    :param value: *(string)* the value of the Integer
    :return: nothing if successful, an error message otherwise


.. _qdbsh_int_update:
.. option:: int_update <alias> <value>

    Add or update an Integer. If the Integer doesn't exist it is created, otherwise it is changed to the new specified value.

    :param alias: *(string)* the alias of the Integer
    :param content: *(string)* the content of the Integer
    :return: nothing if successful, an error message otherwise.


.. _qdbsh_node_config:
.. option:: node_config <host>

    Return the node configuration as a JSON string

    :param host: *(string)* The node designated by its host and port number (e.g. "127.0.0.1:2836")
    :return: *(string)* The node configuration.

.. _qdbsh_node_status:
.. option:: node_status <host>

    Return the node status as a JSON string.

    :param host: *(string)* The node designated by its host and port number (e.g. "127.0.0.1:2836")
    :return: *(string)* The node status.


.. _qdbsh_node_topology:
.. option:: node_topology <host>

    Return the node topology (list of predecessors and successors) as a JSON string.

    :param host: *(string)* The node designated by its host and port number (e.g. "127.0.0.1:2836")
    :return: *(string)* The node topology.


.. _qdbsh_node_stop:
.. option:: node_stop <host>

    Stop the node designated by its host and port number. The stop is generally effective within a few seconds of being issued, which allows inflight calls to complete successfully.

    :param host: *(string)* The node designated by its host and port number (e.g. "127.0.0.1:2836")


.. _qdbsh_deque_back:
.. option:: deque_back <alias>

    Get the value at the end of the Deque.

    :param alias: *(string)* the alias of the Deque
    :return: *(string)* the value of the last item in the Deque.


.. _qdbsh_deque_front:
.. option:: deque_front <alias>

    Get the value at the start of the Deque.

    :param alias: *(string)* the alias of the Deque
    :return: *(string)* the value of the first item in the Deque.


.. _qdbsh_deque_pop_back:
.. option:: deque_pop_back <alias>

    Remove the value at the end of the Deque and return its value.

    :param alias: *(string)* the alias of the Deque
    :return: *(string)* the value of the last item in the Deque.

.. _qdbsh_deque_pop_front:
.. option:: deque_pop_front <alias>

    Remove the value at the start of the Deque and return its value.

    :param alias: *(string)* the alias of the Deque
    :return: *(string)* the value of the first item in the Deque.


.. _qdbsh_deque_push_back:
.. option:: deque_push_back <alias> <content>

    Append the value to the Deque.

    :param alias: *(string)* the alias of the Deque
    :param content: *(string)* the value to add to the end of the Deque.
    :return: nothing if successful, an error message otherwise.


.. _qdbsh_deque_push_front:
.. option:: deque_push_front <alias> <content>

    Prepend the value to the Deque.

    :param alias: *(string)* the alias of the Deque
    :param content: *(string)* the value to add to the start of the Deque.
    :return: nothing if successful, an error message otherwise.

.. _qdbsh_attach_tag:
.. option:: attach_tag <alias> <tag>

    Add a tag to the specified entry.

    :param alias: *(string)* the alias of the entry
    :param tag: *(string)* the tag to assign to the entry

.. _qdbsh_get_tagged:
.. option:: get_tagged <tag>

    Get a list of entries tagged with the specified tag.

    :param tag: *(string)* the tag to search for


.. _qdbsh_has_tag:
.. option:: has_tag <alias> <tag>

    Determine if an entry has a specified tag.

    :param alias: *(string)* the alias of the entry
    :param tag: *(string)* the tag to compare against the entry

.. _qdbsh_stream_to_buffer:
.. option:: stream_to_buffer <alias>

    Dumps the whole content of the stream to the standard output. Warning, the stream may contain a lot of data. The entry must be a stream and must already exist.
    The stream is read in chunks from the database for maximum performance and reduced memory usage.

    :param alias: *(string)* the alias of the entry, which must be a stream
    :return: nothing if successful, an error message otherwise.

.. _qdbsh_stream_from_buffer:
.. option:: stream_from_buffer <alias> <content>

    Write the buffer to the stream. If an entry with an identical name already exists, it will be overwritten and not appended.

    :param alias: *(string)* the alias of the entry, which must be a stream
    :param content: *(string)* the buffer to write to the stream
    :return: nothing if successful, an error message otherwise.

.. _qdbsh_stream_to_file:
.. option:: stream_to_file <alias> <path>

    Dumps the whole content of the stream to the specified file. If the file already exists, it will be overwitten. The entry must be a stream and must already exist.
    The stream is read in chunks from the database for maximum performance and reduced memory usage.

    :param alias: *(string)* the alias of the entry, which must be a stream
    :param path: *(string)* the path to the file to which the content of the stream will be dumped
    :return: nothing if successful, an error message otherwise.

.. _qdbsh_stream_from_file:
.. option:: stream_from_file <alias> <path>

    Reads content from the specified file and writes it to the stream. If an entry with an identical name already exists, it will be overwritten and not appended. The file is read in chunks
    from disk for maximum performance and reduced memory usage.

    :param alias: *(string)* the alias of the entry, which must be a stream
    :param path: *(string)* the path to the file whose content will be written into the stream
    :return: nothing if successful, an error message otherwise.

.. _qdbsh_detach_tag:
.. option:: detach_tag <alias> <tag>

    Remove a tag from the entry.

    :param alias: *(string)* the alias of the entry
    :param tag: *(string)* the tag to remove from the entry
    :return: nothing if successful, an error message otherwise.

.. _qdbsh_version:
.. option:: version

    Display the version information for the quasardb shell.

