An installation tutorial for people with very little time
*********************************************************

A minimal wrpme setup requires deploying the wrpme daemon (wrpmed executable) on a server and making sure the client can access it. 

Installing a wrpme daemon in three steps
========================================

#. Download the server from the `official download page <http://www.wrpme.com/downloads.html>`_

   In the download section you will see the three supported architectures: `FreeBSD <http://www.freebsd.org/>`_, Linux and Windows. For each platform you can either download the server or the API. You will want to *download the server package*, not one of the API packages.
   
#. Install the server 

   On FreeBSD and Linux you just need to expand the tarball. All required binaries are included in the version.
   
   On Windows its comes as an automated setup. The *Windows setup includes both the 32-bit and the 64-bit version* of the server and will automatically install the one that's right for you.
   
#. Run the daemon

   The daemon binary is wrpmed on Unix, wrpmed.exe on Windows. The daemon *doesn't require special privileges* to be launched, unless you want it to listen on a port lower than 1024. By default it will listen on the IPv4 localhost, on the port 5909, persist its content to the disk asynchronously, limit itself to 1 GiB and will not log at all. See :doc:`../reference/wrpmed` for more information.
   
You've successfully deployed a single instance of the wrpme daemon, it's now time to test your setup.

Using the wrpme shell to test your wrpme installation
=====================================================

The wrpme shell is a command line utility that can add, retrieve, update and remove entries from the wrpme daemon. It offers and interactive mode from which the user can enter commands. The name of the binary is wrpmesh and it is included in the server package you downloaded and installed.

#. Run wrpmesh.

   By default wrpmesh will attempt to connect to a wrpmed running on the same machine and listening on the port 5909. If this is not the case - for example if your daemon runs on 192.168.1.1 and listens on the port 303 - you will run wrpmesh as such: ::
   
    wrpmesh --daemon=192.168.1.1:303
   
   wrpmesh will greet you with an interactive prompt from which you can enter commands to be executed on the wrpme daemon
   
#. Add an entry into the server

   On the prompt type::
   
    put entry thisismycontent
   
   If the only answer you get from wrpmesh is a new prompt of the form "ok:wrpmesh> " it means your command has been successfully executed and that your wrpme setup is functionnal. Feel free to run more commands. See :doc:`../reference/wrpme_shell` for more information.
   
Monitoring your installation from a web server
==============================================

wrpme comes with a web bridge in the form of a web server. This web bridge can be used to monitor your wrpme daemon and is updated in real time, meaning the information displayed by the web server is as fresh as it can be. The name of the binary is wrpme_httpd and it is included the server package you downloaded and installed.

All information is made available in both JSON and JSONP format.

 #. Run the server
 
    By default the server will listen on the localhost and on the port 8080. We may want to listen on all IPv4 interfaces instead. Run it as such::
    
        wrpme_httpd --address=0.0.0.0:8080
    
 #. Test it from a browser
 
    An HTML 5 web interface is available to monitor your node. If your server is on the machine 192.168.1.1, you therefore access the statistics as such::
    
        http://192.168.1.1/view
 
    You can also access to the statistics in JSON format. The global statistics URL is /global_status:: 
    
        http://192.168.1.1/global_status
        
    If you want the content in JSONP format, the URL becomes::
    
        http://192.168.1.1/global_status?callback=MyCallBack
        
    
    

   