quasardb shell
**************

.. program:: qdbsh

Introduction
============

The quasardb shell is a command line tool that enables you to add, update, delete and retrieve entries from a quasardb :term:`server` or :term:`cluster`.
The shell can be used interactively and non-interactively.
In :ref:`interactive mode <qdbsh-interactive-mode>`, the user enters commands to be executed on the server. Feedback is provided to indicate failure.
In :ref:`non-interactive mode <qdbsh-noninteractive-mode>`, a single command - supplied as a parameter - is executed and the program exits.


Cheat sheet
===========

By default qdbsh will attempt to connect to a qdbd running on the same machine and listening on the port 2836. If this is not the case - for example if your daemon runs on 192.168.1.1 and listens on the port 303 - you will run qdbsh as such::

    qdbsh --daemon=192.168.1.1:303

When connecting to a cluster, any server within the cluster is capable of servicing requests. There is no "master" or "preferred" server. There is no performance impact of choosing one server instead of the other, except, perhaps, the physical capabilities of the server.

Command line options
---------------------

 ===================================== ============================ ==============
                Option                             Usage                Default
 ===================================== ============================ ==============
 :option:`-h`                          display help
 :option:`--daemon`                    the daemon to connect to     127.0.0.1:2836
 ===================================== ============================ ==============

Commands
--------

 ===================================== ==========================================================
                Command                                  Usage
 ===================================== ==========================================================
 :ref:`help <qdbsh_help>`              display help
 :ref:`version <qdbsh_version>`        display quasardb version
 :ref:`get <qdbsh_get>`                get a piece of data
 :ref:`put <qdbsh_put>`                put data, fails if entry already exists
 :ref:`update <qdbsh_update>`          put data, replace existing entry if any
 :ref:`get_update <qdbsh_getupdate>`   atomically get and udpdate an existing entry if any
 :ref:`cas <qdbsh_cas>` atomically     compare and swap an entry in case of match
 :ref:`remove <qdbsh_del>`             remove given entry
 :ref:`remove_all <qdbsh_removeall>`   remove all entries
 :ref:`exit <qdbsh_exit>`              exit the shell (interactive mode only)
 ===================================== ==========================================================

.. _qdbsh-interactive-mode:

Interactive mode
================

The interactive mode enables the user to enter as many commands as needed. The shell will provide the user with feedback upon success and failure. If needed, it will display the content of retrieved entries.

As soon as qdbsh is properly initialized, the following prompt is displayed::

    qdbsh:ok >

This means the shell is ready to accept commands. Only one command at a time may be specified.
It is executed as soon as enter is pressed and cannot be canceled or roll-backed.

To exit the shell, enter the command ``exit``. To list the available commands, type ``help``.
For the list of supported commands, see :ref:`qdbsh-commands-reference`

If the command is expected to output content on success (such as the get command), it will be printed on the standard output stream.
Keep in mind though, that binary content may not be correctly printed and may even corrupt your terminal display.

When the last command has been successfully executed, the prompt will stay::

    qdbsh:ok >

In case of error, the prompt turns into::

    qdbsh:ko >

Examples
--------

Add a new :term:`entry` named "alias" whose content is "content" and print it::

    qdbsh:ok > put alias content
    qdbsh:ok > get alias
    content
    qdbsh:ok >

Remove an entry named "alias"::

    qdbsh:ok >delete alias
    qdbsh:ok >

.. _qdbsh-noninteractive-mode:

Non-interactive mode
====================

Non-interactive mode enables the user to run one command without waiting for any input.
Non-interactive mode supports standard input and output and can be integrated in a tool chain à la Unix.
Performance-wise, non-interactive mode implies establishing and closing a connection to the quasardb server every time the shell is run.

The command to be executed is supplied as a parameter to the shell. For the list of supported commands, see :ref:`qdbsh-commands-reference`.

As for interactive, mode, the server and port to which to connect is specified with the :option:`--daemon` parameter. Only one command may be specified per run.

When successful, the result of the command will be printed on the standard output stream and the shell will exit with the code 0. Most commands produce no output when successful (silent success).

In case of error, the shell will output an error message on the standard error output stream and will exit with the code 1.

Examples
--------

Unless otherwise specified, the server is listening on the port 2836 on the localhost.

Save the content of an entry named "biography" in a text file named "biography.txt"::

    qdbsh get biography > biography.txt


Compress a file named "myfile" and add its content to an entry named "myfile" to a quasardb server deployed on 192.168.1.1: ::

    bzip2 -c myfile | qdbsh --server=192.168.1.1 put myfile

.. _qdbsh-parameters-reference:

Reference
=========

Options
-------

Parameters can be supplied in any order and are prefixed with ``--``. The arguments format is parameter dependent. Any parameter not in this list will be parsed by qdbsh as a quasardb command. See :ref:`qdbsh-interactive-mode` for more information.

.. option:: -h, --help

    Displays basic usage information.

    Example
        To display the online help, type: ::

            qdbsh --help

.. option:: --daemon <address>:<port>

   Specifies the address and port of the daemon daemon on which the shell will connect.
   Either a DNS name, an IPv4 or an IPv6 address.

   Argument
        The address and port of a machines where a quasardb daemon is running.

   Default value
        127.0.0.0:2836, the IPv4 localhost address and the port 2836

   Example
        If the daemon listen on the localhost and on the port 3001::

            qdbsh --daemon=localhost:3001

.. _qdbsh-commands-reference:

Commands
--------

A command generally requires one or several arguments. Each argument is separated by one or several space characters.

.. _qdbsh_help:
.. option:: help

    Displays basic usage information and list all available commands.

.. _qdbsh_get:
.. option:: get <alias>

    Retrieves an existing entry from the server and print it to standard output.

    :param alias: *(string)* the :term:`alias` of the entry to be retrieved.
    :return: *(string)* the entry's content or an error message

    *Example*
        Retrives an entry whose alias is "alias" and whose content is the string "content"::

            qdbsh:ok > get alias
            content
            qdbsh:ok >

    .. note::
        The entry alias may not contain the space character.
        The alias may not be longer than 1024 characters.

.. _qdbsh_put:
.. option:: put <alias> <content>

    Adds a new entry to the server. The entry must not already exist.

    :param alias: *(string)* the :term:`alias` of the entry to create
    :param content: *(string)* the content of the entry
    :return: nothing if successful, an error message otherwise

    *Example*
        Adds an entry whose alias is "myentry" and whose content is the string "MagicValue"::

            put myentry MagicValue

    .. note::
        The alias cannot contain the space character and its length must be below 1024.
        There must be one space and only one space between the alias and the content.
        There is no practical limit to the content length and all characters until the end of the input will be added to the content, including space characters.

.. _qdbsh_update:
.. option:: update <alias> <content>

    Adds or updates an entry to the server. If the entry doesn't exist it will be created, otherwise it will be changed to the new specified value.

    :param alias: *(string)* the :term:`alias` of the entry to create or update.
    :param content: *(string)* the content of the entry.
    :return: Nothing if successful, an error message otherwise.

    *Example*
        Adds an entry whose alias is "myentry" and whose content is the string "MagicValue"::

            update myentry MagicValue

        Change the value of the entry "myentry" to the content "MagicValue2"::

            update myentry Magicvalue2

    .. note::
        The alias cannot contain the space character and its length must be below 1024.
        There must be one space and only one space between the alias and the content. There is no practical limit to the content length and all characters until the end of the input will be added to the content, including space characters.

.. _qdbsh_getupdate:
.. option:: get_update <alias> <content>

    Atomically gets the previous value of an existing entry and replace it with the specified content. The entry must already exist.

    :param alias: *(string)* the :term:`alias` of the entry to get and update.
    :param content: *(string)* the new content of the entry.
    :return: *(string)* the entry's content or an error message

    *Example*
        Adds an entry whose alias is "myentry", and whose content is the string "MagicValue"::

            put myentry MagicValue

        Update the content to "VeryMagicValue" and gets the previous content::

            get_update myentry MagicValue
            VeryMagicValue

    .. note::
        The alias cannot contain the space character and its length must be below 1024.
        There must be one space and only one space between the alias and the content. There is no practical limit to the content length and all characters until the end of the input will be added to the content, including space characters.

.. _qdbsh_cas:
.. option:: cas <alias> <content> <comparand>

    Atomically compares the value of an existing entry with comparand and replaces it with content in case of match. The entry must already exist.

    :param alias: *(string)* the :term:`alias` of the entry to get and update.
    :param content: *(string)* the new content of the entry.
    :param comparand: *(string)* the value to compare the content to
    :return: *(string)* the entry's original content or an error message

    .. note::
        The alias cannot contain the space character and its length must be below 1024.
        The new content can only be printable characters. This is a qdbsh restriction only.
        There must be one space and only one space between the comparand and the content. There is no practical limit to the comparand length and all characters until the end of the input will be used for the comparand, including space characters.

.. _qdbsh_del:
.. option:: remove <alias>

    Removes an existing entry on the server. It is an error to delete a non-existing entry.

    :param alias: *(string)* the :term:`alias` of the entry to delete
    :return: Nothing if successful, an error message otherwise

    *Example*
        Removes an entry named "obsolete"::

            del obsolete

.. _qdbsh_removeall:
.. option:: remove_all

    Removes all entries from the server. This command is not atomic.

    :return: Nothing if successful, an error message otherwise

    .. caution::
        All entries will be deleted and will not be recoverable. If the cluster is unstable, the command may not be executed by all nodes. The command will nevertheless return success.

.. _qdbsh_exit:
.. option:: exit

    Exits the shell.

.. _qdbsh_version:
.. option:: version

    Displays version information.
