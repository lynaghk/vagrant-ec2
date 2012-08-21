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


#Try to match and extract a port provided to the script
ADDR=$1
IP=${ADDR%:*}
PORT=${ADDR#*:}
if [ "$IP" == "$PORT" ] ; then

    PORT=22
fi

USERNAME=ubuntu
COOKBOOK_TARBALL=$2/cookbooks.tgz
DNA=$2/dna.json

#make sure this matches the CHEF_FILE_CACHE_PATH in `bootstrap.sh`
CHEF_FILE_CACHE_PATH=/tmp/cheftime

#Upload everything to the home directory (need to use sudo to copy over to $CHEF_FILE_CACHE_PATH and run chef)
echo "Uploading cookbooks tarball and dna.json"
scp -i $EC2_SSH_PRIVATE_KEY -r -P $PORT \
  $COOKBOOK_TARBALL \
  $DNA \
  $USERNAME@$IP:.

echo "Running chef-solo"

#check to see if the bootstrap script has completed running
eval "ssh -q -t -p \"$PORT\" -l \"$USERNAME\" -i \"$EC2_SSH_PRIVATE_KEY\" $USERNAME@$IP \"sudo -i which chef-solo > /dev/null \""

if [ "$?" -ne "0" ] ; then
    echo "chef-solo not found on remote machine; it is probably still bootstrapping, give it a minute."
    exit
fi

#Okay, run it.
eval "ssh -t -p \"$PORT\" -l \"$USERNAME\" -i \"$EC2_SSH_PRIVATE_KEY\" $USERNAME@$IP \"sudo -i sh -c '\
cp -r /home/$USERNAME/cookbooks.tgz $CHEF_FILE_CACHE_PATH && \
cp -r /home/$USERNAME/dna.json $CHEF_FILE_CACHE_PATH && \
chef-solo -c $CHEF_FILE_CACHE_PATH/solo.rb -j $CHEF_FILE_CACHE_PATH/dna.json -r $CHEF_FILE_CACHE_PATH/cookbooks.tgz'\""
