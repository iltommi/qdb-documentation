quasardb shell
**************

.. program:: qdbsh

Introduction
============

The quasardb shell is a command line tool that enables you to add, update, delete and retrieve entries from a quasardb server or cluster.
The shell can be used interactively and non-interactively.
In :ref:`interactive mode <qdbsh-interactive-mode>`, the user enters commands to be executed on the server. Feedback is provided to indicate failure.
In :ref:`non-interactive mode <qdbsh-noninteractive-mode>`, a single command - supplied as a parameter - is executed and the program exits.

By default qdbsh will attempt to connect in interactive mode to a qdbd server running on 127.0.0.1:2836. If this is not the case - for example if your qdbd server runs on 192.168.1.1 and listens on the port 303 - you will need to pass the address and port as a qdb:// string, shown below::

    qdbsh qdb://192.168.1.1:303

When connecting to a cluster, any server within the cluster is capable of servicing requests. There is no "master" or "preferred" server. There is no performance impact of choosing one server instead of the other, except, perhaps, the physical capabilities of the server.


Quick Reference
===============

Command line options
---------------------

 ===================================== ============================ ====================
                Option                             Usage                  Default
 ===================================== ============================ ====================
 :option:`-h`                          display help                  
 :option:`-v`                          display quasardb version      
 :option:`-c`                          run a qdb command
 ===================================== ============================ ====================

Commands
--------

 ========================================================== ==========================================================
                Command                                                  Usage
 ========================================================== ==========================================================
 :ref:`cas alias content comparand <qdbsh_cas>`              atomically compares and swaps the entry
 :ref:`exit <qdbsh_exit>`                                    exit the shell (interactive mode only)
 :ref:`expires_at alias expiry <qdbsh_expiresat>`            sets the absolute expiry time of the entry
 :ref:`expires_from_now alias delta <qdbsh_expiresfromnow>`  sets the entry expiry time to seconds relative to now.
 :ref:`get <qdbsh_get>`                                      returns the entry content
 :ref:`get_expiry <qdbsh_getexpiry>`                         returns the entry's aboslute expiry time
 :ref:`get_and_update alias <qdbsh_getupdate>`               atomically get and update the entry
 :ref:`help <qdbsh_help>`                                    display help
 :ref:`node_config host <qdbsh_nodeconfig>`                  returns the node configuration as a JSON string
 :ref:`node_status host <qdbsh_nodestatus>`                  returns the node status as a JSON string
 :ref:`node_topology host <qdbsh_nodetopology>`              returns the node topology as a JSON string
 :ref:`prefix_get prefix <qdbsh_prefixget>`                  returns the list of aliases matching the given prefix
 :ref:`put <qdbsh_put>`                                      put data, fails if entry already exists
 :ref:`purge_all <qdbsh_purgeall>`                           removes ALL entries on the WHOLE cluster (Dangerous!)
 :ref:`remove alias <qdbsh_remove>`                          removes the entry
 :ref:`remove_if alias data <qdbsh_removeif>`                removes the entry in case of match
 :ref:`stop_node host reason <qdbsh_stopnode>`               stops the node
 :ref:`trim_all <qdbsh_trimall>`                             removes unused versions of entries from the cluster
 :ref:`update alias data <qdbsh_update>`                     updates the entry. The entry will be created if it doesn't exist
 :ref:`version <qdbsh_version>`                              display quasardb version
 
 ========================================================== ==========================================================





.. _qdbsh-interactive-mode:

Interactive mode
================

The interactive mode enables the user to enter as many commands as needed. The shell will provide the user with feedback upon success and failure. If needed, it will display the content of retrieved entries.

As soon as qdbsh is properly initialized, the following prompt is displayed::

    qdbsh:ok >

This means the shell is ready to accept commands. Only one command at a time may be specified.

**A command is executed as soon as Enter is pressed and cannot be canceled or rolled back.**

To exit the shell, enter the command ``exit``. To list the available commands, type ``help``.
For the list of supported commands, see :ref:`qdbsh-commands-reference`

If the command is expected to output content on success (such as the get command), it will be printed on the standard output stream.
Keep in mind though, that binary content may not be correctly printed and may even corrupt your terminal display.

When the last command has been successfully executed, the prompt will show::

    qdbsh:ok >

In case of error, the prompt turns into::

    qdbsh:ko >

As of quasardb 2.0.0, qdb_shell's interactive mode supports tab completion and command history (using the up/down and pgup/pgdn keys).

Examples
--------

Add a new entry named "alias" whose content is "content" and print it::

    qdbsh:ok > put alias content
    qdbsh:ok > get alias
    content
    qdbsh:ok >

Remove an entry named "alias"::

    qdbsh:ok >remove alias
    qdbsh:ok >

.. _qdbsh-noninteractive-mode:

Non-interactive mode
====================

Non-interactive mode enables the user to run one command without waiting for any input.
Non-interactive mode supports standard input and output and can be integrated in a tool chain à la Unix.
Performance-wise, non-interactive mode implies establishing and closing a connection to the quasardb server every time the shell is run.

The command to be executed is supplied as an argument to the -c parameter. For the list of supported commands, see :ref:`qdbsh-commands-reference`.

When successful, the result of the command will be printed on the standard output stream and the shell will exit with the code 0. Most commands produce no output when successful (silent success).

In case of error, the shell will output an error message on the standard error output stream and will exit with the code 1.

Examples
--------

Unless otherwise specified, qdbsh assumes the server is running on localhost and on the port 2836.

Save the content of an entry named "biography" in a text file named "biography.txt"::

    qdbsh -c get biography > biography.txt


Compress a file named "myfile", then add its content to an entry named "myfile" on the quasardb server at 192.168.1.1: ::

    bzip2 -c myfile | qdbsh qdb://192.168.1.1:2836 -c put myfile

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
        If the qdbd server is on localhost and listens on port 3001 and we want to add an entry::

            qdbsh qdb://127.0.0.1:3001 -c put title "There and Back Again: A Hobbit's Tale"

.. _qdbsh-commands-reference:

Commands
--------

A command generally requires one or several arguments. Each argument is separated by one or several space characters.

.. _qdbsh_cas:
.. option:: cas <alias> <content> <comparand>

    Atomically compares the value of an existing entry with comparand and replaces it with content in case of match. The entry must already exist.

    :param alias: *(string)* the alias of the entry to get and update.
    :param content: *(string)* the new content of the entry.
    :param comparand: *(string)* the value to compare the content to
    :return: *(string)* the entry's original content or an error message

    .. note::
        The alias cannot contain the space character and its length must be below 1024.
        The new content can only be printable characters. This is a qdbsh restriction only.
        There must be one space and only one space between the comparand and the content. There is no practical limit to the comparand length and all characters until the end of the input will be used for the comparand, including space characters.
    
    
.. _qdbsh_exit:
.. option:: exit

    Exits the shell.


.. _qdbsh_expiresat:
.. option:: expires_at <alias> <expiry>
    
    Sets the expiry time of an existing entry from the quasardb cluster.
    
    :param alias: A string representing the entry's alias for which the expiry must be set.
    :param expiry: The absolute time at which the entry expires.



.. _qdbsh_expiresfromnow:
.. option:: expires_from_now <alias> <delta>
    
    Sets the expiry time of an existing entry from the quasardb cluster.
    
    :param alias: A string representing the entry's alias for which the expiry must be set.
    :param delta: A time, relative to the call time, after which the entry expires.



.. _qdbsh_get:
.. option:: get <alias>

    Retrieves an existing entry from the server and print it to standard output.

    :param alias: *(string)* the alias of the entry to be retrieved.
    :return: *(string)* the entry's content or an error message

    *Example*
        Retrives an entry whose alias is "alias" and whose content is the string "content"::

            qdbsh:ok > get alias
            content
            qdbsh:ok >

    .. note::
        The entry alias may not contain the space character.
        The alias may not be longer than 1024 characters.


.. _qdbsh_getexpiry:
.. option:: get_expiry <alias>

    Retrieves the expiry time of an existing entry.

    :param alias: *(string)* the alias of the entry
    :return: *(string)* the expiry time of the alias



.. _qdbsh_getupdate:
.. option:: get_and_update <alias> <content>

    Atomically gets the previous value of an existing entry and replace it with the specified content. The entry must already exist.

    :param alias: *(string)* the alias of the entry to get and update.
    :param content: *(string)* the new content of the entry.
    :return: *(string)* the entry's content or an error message

    *Example*
        Adds an entry whose alias is "myentry", and whose content is the string "MagicValue"::

            put myentry MagicValue

        Update the content to "VeryMagicValue" and gets the previous content::

            get_and_update myentry MagicValue
            VeryMagicValue

    .. note::
        The alias cannot contain the space character and its length must be below 1024.
        There must be one space and only one space between the alias and the content. There is no practical limit to the content length and all characters until the end of the input will be added to the content, including space characters.


.. _qdbsh_help:
.. option:: help

    Displays basic usage information and lists all available commands.

.. _qdbsh_nodeconfig:
.. option:: node_config <host>
    
    Returns the node configuration as a JSON string
    
    :param host: *(string)* The node designated by its host and port number (e.g. "127.0.0.1:2836")
    :return: *(string)* The node configuration.

.. _qdbsh_nodestatus:
.. option:: node_status <host>
    
    Returns the node status as a JSON string.
    
    :param host: *(string)* The node designated by its host and port number (e.g. "127.0.0.1:2836")
    :return: *(string)* The node status.

.. _qdbsh_nodetopology:
.. option:: node_topology <host>
    
    Returns the node topology (list of predecessors and successors) as a JSON string.
    
    :param host: *(string)* The node designated by its host and port number (e.g. "127.0.0.1:2836")
    :return: *(string)* The node topology.


.. _qdbsh_prefixget:
.. option:: prefix_get <prefix>
    
    Returns the list of aliases matching the given prefix.
    
    :param prefix: *(string)* A prefix to search for.
    :return: *(string)* The list of matching aliases.


.. _qdbsh_purgeall:
.. option:: purge_all
    
    Removes all entries from the cluster. This command is not atomic.

    :return: Nothing if successful, an error message otherwise

    .. caution::
        All entries will be deleted and will not be recoverable. If the cluster is unstable, the command may not be executed by all nodes. The command will nevertheless return success.


.. _qdbsh_put:
.. option:: put <alias> <content>

    Adds a new entry to the server. The entry must not already exist. Keys beginning with the string "qdb" are reserved and cannot be added to the cluster.

    :param alias: *(string)* the alias of the entry to create
    :param content: *(string)* the content of the entry
    :return: nothing if successful, an error message otherwise

    *Example*
        Adds an entry whose alias is "myentry" and whose content is the string "MagicValue"::

            put myentry MagicValue

    .. note::
        The alias cannot contain the space character and its length must be below 1024.
        There must be one space and only one space between the alias and the content.
        There is no practical limit to the content length and all characters until the end of the input will be added to the content, including space characters.



.. _qdbsh_remove:
.. option:: remove <alias>

    Removes an existing entry on the server. It is an error to delete a non-existing entry.

    :param alias: *(string)* the alias of the entry to delete
    :return: Nothing if successful, an error message otherwise

    *Example*
        Removes an entry named "obsolete"::

            remove obsolete

.. _qdbsh_removeif:
.. option:: remove_if <alias> <comparand>

    Atomically compares the entry with the comparand and removes it if, and only if, they match.

    :param alias: The entry's alias to delete.
    :param comparand: The entry's content to be compared to.
    :returns: True if the entry was successfully removed, false otherwise.

.. _qdbsh_stopnode:
.. option:: stop_node <host>
    
    Stops the node designated by its host and port number. This stop is generally effective within a few seconds of being issued, enabling inflight calls to complete successfully.
    
    :param host: *(string)* The node designated by its host and port number (e.g. "127.0.0.1:2836")


.. _qdbsh_trimall:
.. option:: trim_all

    Removes unused versions of entries from the cluster, freeing up disk space.
    
    :return: Nothing if successful, an error message otherwise


.. _qdbsh_update:
.. option:: update <alias> <content>

    Adds or updates an entry to the server. If the entry doesn't exist it will be created, otherwise it will be changed to the new specified value.

    :param alias: *(string)* the alias of the entry to create or update.
    :param content: *(string)* the content of the entry.
    :return: Nothing if successful, an error message otherwise.

    *Example*
        Adds an entry whose alias is "myentry" and whose content is the string "MagicValue"::

            update myentry MagicValue

        Change the value of the entry "myentry" to the content "MagicValue2"::

            update myentry MagicValue2

    .. note::
        The alias cannot contain the space character and its length must be below 1024.
        There must be one space and only one space between the alias and the content. There is no practical limit to the content length and all characters until the end of the input will be added to the content, including space characters.


.. _qdbsh_version:
.. option:: version

    Displays the version information for the quasardb shell.
