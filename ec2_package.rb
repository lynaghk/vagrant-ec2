#!/bin/env ruby
#Make a tarball of only the recipes called in dna.json
#Takes as an argument the path to a Vagrant VM's folder.
require 'rubygems'
require 'json'

COOKBOOK_PATH = File.dirname(__FILE__) + '/../cookbooks'

Dir.chdir(ARGV[0]) do
  #run vagrant to parse the `Vagrantfile` and write `dna.json`
  `vagrant` 
  
  recipe_names = JSON.parse(open('dna.json').read)["run_list"].map{|x|
    x.gsub('recipe', '').gsub(/(\[|\])/, '').gsub(/::.*$/, '')
  }.uniq

  open('recipe_list', 'w'){|f|
    f.puts recipe_names.map{|x|
      main_path = "#{COOKBOOK_PATH}/#{x}"
      if File.exists?(main_path)
        main_path
      else #this must be a vm-specific cookbook recipe, stored in this directory
        "cookbooks/#{x}"
      end
    }
  }
  
  `tar cvzf cookbooks.tgz --files-from recipe_list`
  `rm recipe_list`
end
