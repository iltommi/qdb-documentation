
Amazon Web Services Installation
================================

Windows Instance
----------------

 #. Complete Amazon's `Setting Up <http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html>`_ steps.
 #. Select a `Windows <http://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/EC2Win_GetStarted.html>`_  EC2 instance. Make sure your purchased and configured options meet the :ref:`sysreq-windows`.
 #. If this instance will communicate with other quasardb nodes on EC2 instances, `configure the Windows security groups <http://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/using-network-security.html>`_ to allow incoming access on the intended quasardb daemon port. The default port is 2836.
 #. Connect to your EC2 instance.
 #. Complete the quasardb :doc:`installation_windows` instructions.

Linux Instance
--------------

 #. Complete the `Setting Up <http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html>`_ steps.
 #. Select a `Linux <http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html>`_  EC2 instance. Make sure your purchased and configured options meet the :ref:`sysreq-linux`.
 #. If this instance will communicate with other quasardb EC2 instances, `configure the Linux security groups <http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html>`_ to allow incoming access on the intended quasardb daemon port. The default port is 2836.
 #. Connect to your EC2 instance.
 #. Complete the quasardb installation instructions for your Linux distribution:
   
   * :doc:`installation_deb`
   * :doc:`installation_rpm`
   * :doc:`installation_other_linux`

