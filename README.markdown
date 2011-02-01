Vagrant + EC2
=============

This repository shows how to use the same `chef-solo` based provisioning scheme for Vagrant virtual machines and Amazon's EC2.
This is useful because you'll be able to test the deployment procedures as you develop within a clean Vagrant machine.
Running continuous deployment locally also saves many partial instance-hours, which can run into the hundreds of cents (I'm not made of money, people).







SETUP USING CHEF
===============
Setup config is the virtual_machines repo in the Vagrant file, then run any vagrant command (or just `vagrant`) to parse and print out a dna.json.
Then run `ec2_package.rb` in virtual_machines repo to make a cookbook tarball.
Point `setup.sh` to these files, then run the following:

ec2-run-instances ami-af7e2eea                 \
  --instance-type t1.micro                     \
  --key yournamehere                           \
  --user-data-file bootstrap_chef/bootstrap.sh

Find its IP with    
  ec2-describe-instances

To open up a plain ssh console (must run `ec2-authorize default -p 22` once)
  ssh -i $EC2_SSH_PRIVATE_KEY ubuntu@<ip address>

To configure with chef
  ./setup.sh <ip address>


DONE!

finish up & close down
  ec2-terminate-instances <i-instance_id>





Setup controlling machine
=========================

On your machine, you will need the following

+ [ec2-api-tools](http://packages.ubuntu.com/maverick/ec2-api-tools) Ubuntu multiverse package (this is not currently in Debian Apt repositories; you'll need to download the Ubuntu `.deb` package  and use `dpkg --install`)
+ [VirtualBox 4](http://www.virtualbox.org/wiki/Downloads)
+ [vagrant] rubygem; `gem install vagrant`

Add to your .bashrc

  EC2_PRIVATE_KEY=/path/to/pk-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem
  EC2_CERT=/path/to/cert-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem
  EC2_SSH_PRIVATE_KEY=/path/to/pk-yournamehere.pem
  JAVA_HOME=/usr/lib/jvm/java-6-sun/
  EC2_URL=https://ec2.us-west-1.amazonaws.com

