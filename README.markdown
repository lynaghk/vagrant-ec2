Vagrant-EC2
=============
This repository shows how to use the same `chef-solo`-based provisioning scheme for Vagrant virtual machines and Amazon's EC2. This is useful because you'll be able to test the deployment procedures as you develop within a clean Vagrant machine. Running continuous deployment locally also saves tons of partial instance-hours, which can run into the hundreds of cents (I'm not made of money, people).

These scripts have been tested only on Ubuntu Linux.

Development (local)
===================
Just use Vagrant as you normally would:

    cd a_vagrant_machine/
    vagrant up
    vagrant ssh


Production (EC2)
================
Start up a new EC2 instance (`ami-af7e2eea` is a US west coast Ubuntu 10.10 64-bit server)

    ec2-run-instances ami-af7e2eea                 \
      --instance-type t1.micro                     \
      --key yournamehere                           \
      --user-data-file bootstrap.sh

find its IP with

    ec2-describe-instances

and provision it using the same recipes as the demo Vagrant machine machine by running

    ./setup.sh <ip address> a_vagrant_machine/

DONE!

Don't forget to turn off your instances when you're finished:

    ec2-terminate-instances <i-instance_id>



Converting existing Vagrantfiles
================================
Just add three lines in the provisioning section of your `Vagrantfile` so it looks like this:

    config.vm.provision :chef_solo do |chef|

      <your provisioning here>

      require 'json'
      open('dna.json', 'w'){|f| f.write chef.json.to_json}
      open('.cookbooks_path.json', 'w'){|f| f.puts JSON.generate chef.cookbooks_path }      

    end


Setup local machine
===================
On your local machine, you will need the following

+ [ec2-api-tools](http://packages.ubuntu.com/maverick/ec2-api-tools) Ubuntu multiverse package (this is not currently in Debian's apt repositories; you'll need to download the Ubuntu `.deb` package  and use `dpkg --install`)
+ [VirtualBox 4](http://www.virtualbox.org/wiki/Downloads)
+ [Vagrant](http://vagrantup.com) rubygem; `gem install vagrant`
+ The `lucid32` Vagrant base box; `vagrant box add lucid32 http://files.vagrantup.com/lucid32.box`.
  Take a look at the [vagrant-ubuntu](https://github.com/lynaghk/vagrant-ubuntu) repository for scripts to make custom Ubuntu-based Vagrant base boxes.

Add to your .bashrc

    EC2_PRIVATE_KEY=/path/to/pk-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem
    EC2_CERT=/path/to/cert-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem
    EC2_SSH_PRIVATE_KEY=/path/to/pk-yournamehere.pem
    JAVA_HOME=/usr/lib/jvm/java-6-sun/
    EC2_URL=https://ec2.us-west-1.amazonaws.com


More details
============
See the official page for more details: [http://keminglabs.com/vagrant-ec2/](http://keminglabs.com/vagrant-ec2/).

Thanks
======
This project is sponsored by [Keming Labs](http://keminglabs.com), a technical design studio specializing in data visualization.
