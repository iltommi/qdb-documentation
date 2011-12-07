wrpme database tool
******************************

Introduction
============

The wrpme database tool enables you to analyze, dump, repair and backup the persisted data of a wrpme instance.

Parameters reference
====================

Parameters can be supplied in any order and are prefixed with ``--``. The arguments format is parameter dependent. Any parameter not in this list will be parsed by wrpmesh as a wrpme command. See :ref:``wrpmesh-interactive-mode`` for more information.

.. program:: wrp_me_db_tool

.. option:: -h, --help

    Displays basic usage information.

    Example
        To display the online help, type: ::

            wrp_me_db_tool --help

.. option:: --database=<path>
    
    Specifies the path to the database on which to work.

    Arguments
        A string representing the path to the database, may be relative or absolute.

    Default value
        None

    Example
        Work on a database in the current directory::
            
            wrp_me_db_tool --database=.
            
        Work on a database in the /var/wrpme/db directory::
        
            wrp_me_db_tool --database=/var/wrpme/db directory

.. option:: --analyze, -a

    Requests an analysis of the database. A report will be printed on the standard output.

    Example
        Analyze the database in the current directory::
        
            wrp_me_db_tool --database=. --analyze

.. option:: --dump, -d

    Dumps the content of the database on the standard output.

    Example
        Dump the database in the current directory::
        
            wrp_me_db_tool --database=. --dump
            
.. option:: --backup=<path>, -b <path>

    Copies all the content of the database to a new database in the specified directory. If the directory does not exist it will be created.
    If a database exists in the destination directory, its content may be overwritten by the new content. 

    Arguments
        A string representing the path where a copy of the database will be created.

    Default value
        None
    
    Example
        Backup the database in /var/wrpme/db to /var/wrpme/db/backup ::
        
            wrp_me_db_tool --database=/var/wrpme/db --backup=/var/wrpme/db/backup 
            
.. option:: --repair, -r

    Attempts to repair the database. All data may not be recovered. Note that the :doc:`wrpmed` automatically attempts to repair the database if needed, this option
    is intended for offline operations.
    
    Example
        Repairs the database in the current directory::
        
            wrp_me_db_tool --database=. --repair
            
            
            
            
            
            
            
            
            
            
            
            