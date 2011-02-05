#!/bin/bash
#This script uploads everything required for `chef-solo` to run
set -e

if test -z "$2"
then
  echo "I need 
1) IP address of a machine to provision
2) Path to a Vagrant VM folder (a folder containing a Vagrantfile) that you want me to extract Chef recipes from"
  exit 1
fi


#Run the Ruby script that reads Vagrantfile to make dna.json and cookbook tarball
echo "Making cookbooks tarball and dna.json"
ruby `dirname $0`/ec2_package.rb $2

IP=$1
USERNAME=ubuntu
COOKBOOK_TARBALL=$2/cookbooks.tgz
DNA=$2/dna.json

#make sure this matches the CHEF_FILE_CACHE_PATH in `bootstrap.sh`
CHEF_FILE_CACHE_PATH=/tmp/cheftime

#Upload everything to the home directory (need to use sudo to copy over to $CHEF_FILE_CACHE_PATH and run chef)
echo "Uploading cookbooks tarball and dna.json"
scp -i $EC2_SSH_PRIVATE_KEY -r \
  $COOKBOOK_TARBALL \
  $DNA \
  $USERNAME@$IP:.

echo "Running chef-solo"
eval "ssh -t -l \"$USERNAME\" -i \"$EC2_SSH_PRIVATE_KEY\" $USERNAME@$IP \"sudo -i 'cd $CHEF_FILE_CACHE_PATH && \
cp -r /home/$USERNAME/cookbooks.tgz . && \
cp -r /home/$USERNAME/dna.json . && \
chef-solo -c solo.rb -j dna.json -r cookbooks.tgz'\""
