An installation tutorial for people with very little time
*********************************************************

A minimal wrpme setup requires deploying the wrpme daemon (wrpmed executable) on a server and making sure the client can access it. 

Installing a wrpme daemon in three steps
========================================

#. Download the **server** from the `official download page <http://www.wrpme.com/downloads.html>`_
   
#. Install the server

   On FreeBSD and Linux you just need to expand the tarball.
   
   On Windows its comes as an automated setup, *including both the 32-bit and the 64-bit version* of the server.
   
#. Run the daemon

   The daemon binary is wrpmed on Unix, wrpmed.exe on Windows. The daemon will by default listen on the IPv4 localhost, on the port 5909, persist its content to the disk asynchronously, limit itself to 1 GiB and will not log at all. See :doc:`../reference/wrpmed` for more configuration options.

Using the wrpme shell to test your wrpme installation
=====================================================

The wrpme shell offers an interactive mode from which the user can enter commands. The name of the binary is wrpmesh and it is included in the server package you downloaded and installed.

#. Run wrpmesh.

  By default wrpmesh will attempt to connect to a wrpmed running on the same machine and listening on the port 5909. If this is not the case - for example if your daemon runs on 192.168.1.1 and listens on the port 303 - you will run wrpmesh as such: ::
    
    wrpmesh --daemon=192.168.1.1:303

#. Add an entry into the server

  On the prompt type::
  
    put entry thisismycontent
    get entry
  
  Type `help` to get a list of available commands. See :doc:`../reference/wrpme_shell` for more information.
   
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
   