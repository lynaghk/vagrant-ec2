#!/usr/bin/env ruby

require 'optparse'
require 'rake'
o = {
  :username => "ubuntu",
  :ssh_key => ENV["EC2_SSH_PRIVATE_KEY"],
  :port => 22
}
OptionParser.new do |opts|
  opts.banner = "Usage: setup.rb <ip address> <Vagrant VM folder>"

  opts.on("-u", "--username X", "SSH username") do |v|
    o[:username] = v
  end

  opts.on("-i", "--ident X", "SSH key") do |v|
    o[:ssh_key] = v
  end

  opts.on("-p", "--port X", "SSH port") do |v|
    o[:port] = v
  end
  
end.parse!

ip = ARGV[0]
vm_root = ARGV[1]
chef_file_cache_path = "/tmp/cheftime"


puts "making cookbooks tarball"
sh "ruby #{File.dirname(__FILE__)}/ec2_package.rb #{vm_root}"

cookbooks_tarball = "#{vm_root}/cookbooks.tgz"
dna = "#{vm_root}/dna.json"

puts "Uploading cookbooks tarball and dna.json"
sh "scp -i #{o[:ssh_key]} -r -P #{o[:port]} \
  #{cookbooks_tarball} \
  #{dna} \
  #{o[:username]}@#{ip}:."

completed = system "ssh -q -t -p #{o[:port]} -i #{o[:ssh_key]} #{o[:username]}@#{ip} 'sudo -i which chef-solo > /dev/null'"

if not completed
  puts "chef-solo not found on remote machine"
  exit 1
end

sh "ssh -t -p #{o[:port]} -i #{o[:ssh_key]} #{o[:username]}@#{ip} \"sudo -i sh -c 'cd #{chef_file_cache_path} && \
cp -r /home/#{o[:username]}/cookbooks.tgz . && \
cp -r /home/#{o[:username]}/dna.json . && \
chef-solo -c solo.rb -j dna.json -r cookbooks.tgz'\""
