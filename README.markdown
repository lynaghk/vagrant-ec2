Vagrant + EC2
=============

This repository shows how to use the same `chef-solo` based provisioning scheme for Vagrant virtual machines and Amazon's EC2.
This is useful because you'll be able to test the deployment procedures as you develop within a clean Vagrant machine.
Running continuous deployment locally also saves tons of partial instance-hours, which can run into the hundreds of cents (I'm not made of money, people).


Development
===========
Just use Vagrant as you normally would:
  cd a_vagrant_machine/
  vagrant up
  vagrant ssh

Deploy to EC2
=============

Start up a new EC2 instance (in this case, the ami is an Ubuntu 10.10 64-bit server)
ec2-run-instances ami-af7e2eea                 \
  --instance-type t1.micro                     \
  --key yournamehere                           \
  --user-data-file bootstrap.sh

find its IP with
  ec2-describe-instances

and provision by running
  ./setup.sh <ip address>


DONE!

Don't forget to turn off your instances when you're done:
  ec2-terminate-instances <i-instance_id>




Setup controlling machine
=========================

On your local machine, you will need the following

+ [ec2-api-tools](http://packages.ubuntu.com/maverick/ec2-api-tools) Ubuntu multiverse package (this is not currently in Debian Apt repositories; you'll need to download the Ubuntu `.deb` package  and use `dpkg --install`)
+ [VirtualBox 4](http://www.virtualbox.org/wiki/Downloads)
+ [vagrant] rubygem; `gem install vagrant`

Add to your .bashrc

  EC2_PRIVATE_KEY=/path/to/pk-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem
  EC2_CERT=/path/to/cert-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem
  EC2_SSH_PRIVATE_KEY=/path/to/pk-yournamehere.pem
  JAVA_HOME=/usr/lib/jvm/java-6-sun/
  EC2_URL=https://ec2.us-west-1.amazonaws.com

