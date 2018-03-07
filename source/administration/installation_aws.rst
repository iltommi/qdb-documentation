
Amazon Web Services Installation
================================

AWS Marketplace
-----------------

`Quasardb <https://aws.amazon.com/marketplace/seller-profile/ref=dtl_pcp_sold_by?id=6a474569-7e8f-4752-9278-b6609c3cd732>`_ is directly available on `AWS Marketplace <https://aws.amazon.com/marketplace/>`_ as a pre-configured `Linux node <https://aws.amazon.com/marketplace/pp/B01FUR400S/>`_.

Windows Instance
----------------

 #. Complete Amazon's `Setting Up <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html>`_ steps.
 #. Select a `Windows <https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/EC2_GetStarted.html>`_  EC2 instance. Make sure your purchased and configured options meet the :ref:`sysreq-windows`.
 #. If this instance will communicate with other quasardb nodes on EC2 instances, `configure the Windows security groups <https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/using-network-security.html>`_ to allow incoming access on the intended quasardb daemon port. The default port is 2836.
 #. Connect to your EC2 instance.
 #. Complete the quasardb :doc:`installation_windows` instructions.

Linux Instance
--------------

 #. Complete the `Setting Up <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html>`_ steps.
 #. Select a `Linux <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html>`_  EC2 instance. Make sure your purchased and configured options meet the :ref:`sysreq-linux`.
 #. If this instance will communicate with other quasardb EC2 instances, `configure the Linux security groups <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html>`_ to allow incoming access on the intended quasardb daemon port. The default port is 2836.
 #. Connect to your EC2 instance.
 #. Complete the quasardb installation instructions for your Linux distribution:

   * :doc:`installation_deb`
   * :doc:`installation_rpm`
   * :doc:`installation_other_linux`

