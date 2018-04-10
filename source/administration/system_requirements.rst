System Requirements
===================

.. _sysreq-hardware:

Hardware Requirements
---------------------

Main build
^^^^^^^^^^

    * An Intel Westmere or better microarchitecture (AMD Bulldozer or better)
    * End-to-end ECC memory highly recommended (motherboard, CPU and memory)
    * At least 512 MB of RAM
    * At least 1 GiB of disk

Core2 build
^^^^^^^^^^^

    * An Intel Core or better microarchitecture
    * End-to-end ECC memory highly recommended (motherboard, CPU and memory)
    * At least 512 MB of RAM
    * At least 1 GiB of disk

ARM64 build
^^^^^^^^^^^

    * ARM64 architecture
    * At least 512 MB of RAM
    * At least 1 GiB of disk

It is strongly advised to have a homogenous hardware configuration within a cluster.

Software Requirements
---------------------

All nodes must be time-synchronized. NTP may deliver a satisfactory time synchronization level, however PTP is recommended. For the most demanding use case, timing PCIe cards may be required.

.. _sysreq-freebsd:

FreeBSD Requirements
^^^^^^^^^^^^^^^^^^^^

    * FreeBSD 11, x86_64
    * libc++ v1
    * Python 2.7.x (optional)
    * Java JDK (optional)
        * Oracle Java JDK EE 8
        * Oracle Java JDK EE 9
        * OpenJDK 8
        * OpenJDK 9

All other required libraries are included in the quasardb package.

.. _sysreq-linux:

Linux Requirements
^^^^^^^^^^^^^^^^^^

    * An x86_64 native distribution
    * Kernel 2.6 or higher
    * libc 2.17 or higher
    * Python 2.7.x (optional)
    * Java JDK (optional)
        * Oracle Java JDK EE 8
        * Oracle Java JDK EE 9
        * OpenJDK 8
        * OpenJDK 9


All other required libraries are included in the quasardb package.

.. _sysreq-windows:

Windows Requirements
^^^^^^^^^^^^^^^^^^^^

    * One of the following 32-bit or 64-bit operating systems:
        * Windows Server 2008
        * Windows 7
        * Windows Server 2012
        * Windows 8
        * Windows 8.1
        * Windows Server 2016
        * Windows 10
    * Python 2.7.x (optional)
    * Java JDK (optional)
        * Oracle Java JDK EE 8
        * Oracle Java JDK EE 9
        * OpenJDK 8
        * OpenJDK 9

.. warning::
    Prior to Windows 8 and Windows Server 2012, the operating system is not able to deliver highly accurate timestamps. This can result in a higher rate of transaction conflicts and less accurate entries metadata.

All other required libraries are included in the quasardb installer.

Best Practices
--------------

    * 64-bit platforms and operating systems are preferred due to their ability to access and allocate larger quantities of RAM.
    * RAID 1 and RAID 5 disk configurations are optional but may reduce maintenance in case of disk failure.
    * Use the operating system of your choice; FreeBSD, Linux, and Windows are all equally supported.
