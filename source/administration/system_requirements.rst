System Requirements
===================

.. _sysreq-hardware:

Hardware Requirements
---------------------

    * An IA32 or AMD64 platform
    * End-to-end ECC memory (motherboard, CPU and memory)
    * At least 1 GiB of RAM (the exact amount depends on your use case)
    * At least 10 GiB of disk (the exact amount depends on your use case, see :ref:`operations-db-storage`)
    * 1 Gbit ethernet port

It is strongly advised to have a homogenous hardware configuration within a cluster.


Software Requirements
---------------------

.. _sysreq-freebsd:

FreeBSD Requirements
^^^^^^^^^^^^^^^^^^^^

    * FreeBSD 8 or 9, amd64 only
    * libc++ v1
    * Python 2.7.x (optional)
    * Java JDK (optional)
        * Oracle Java JDK SE 1.6
        * Oracle Java JDK EE 1.6
        * Oracle Java JDK SE 1.7
        * Oracle Java JDK EE 1.7
        * OpenJDK 6
        * OpenJDK 7u


All other required libraries are included in the quasardb package.


.. _sysreq-linux:

Linux Requirements
^^^^^^^^^^^^^^^^^^

    * An amd64 native distribution
    * Kernel 2.6 or higher
    * libc 2.5 or higher
    * Python 2.7.x (optional)
    * Java JDK (optional)
        * Oracle Java JDK SE 1.6
        * Oracle Java JDK EE 1.6
        * Oracle Java JDK SE 1.7
        * Oracle Java JDK EE 1.7
        * OpenJDK 6
        * OpenJDK 7u


All other required libraries are included in the quasardb package.


.. _sysreq-windows:

Windows Requirements
^^^^^^^^^^^^^^^^^^^^

    * One of the following 32-bit or 64-bit operating systems:
        * Windows XP (Requires Service Pack 3 or higher)
        * Vista
        * 7
        * 8
        * Server 2008
        * Server 2012
    * Python 2.7.x (optional)
    * Java JDK (optional)
        * Oracle Java JDK SE 1.6
        * Oracle Java JDK EE 1.6
        * Oracle Java JDK SE 1.7
        * Oracle Java JDK EE 1.7
        * OpenJDK 6
        * OpenJDK 7u


All other required libraries are included in the quasardb installer.

Best Practices
--------------

    * 64-bit platforms and operating systems are preferred due to their ability to access and allocate larger quantities of RAM.
    * RAID 1 and RAID 5 disk configurations are optional but may reduce maintenance in case of disk failure.
    * Use the operating system of your choice; FreeBSD, Linux, and Windows are all equally supported.
