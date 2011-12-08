#!/usr/bin/env ruby
#Make a tarball of only the recipes called in dna.json
#Takes as an argument the path to a Vagrant VM's folder.
require 'rubygems'
require 'json'

Dir.chdir(ARGV[0]) do
  #run vagrant to parse the `Vagrantfile` and write out `dna.json` and `.cookbooks_path.json`.
  res = `vagrant`
  if $?.exitstatus != 0
    puts res
    exit 1
  end
  CookbooksPath = [JSON.parse(open('.cookbooks_path.json').read)].flatten
  
  recipe_names = JSON.parse(open('dna.json').read)["run_list"].map{|x|
    x.gsub('recipe', '').gsub(/(\[|\])/, '').gsub(/::.*$/, '')
  }.uniq

  open('recipe_list', 'w'){|f|
    f.puts recipe_names.map{|x|
      
      paths = CookbooksPath.map{|cookbook_path|
        "#{cookbook_path}/#{x}"
      }
      paths.reject!{|path| not File.exists?(path)}
      
      raise "Multiple cookbooks '#{x}' exist within `chef.cookbooks_path`; I'm not sure which one to use" if paths.length > 1
      raise "I can't find any cookbooks called '#{x}'" if paths.length == 0
      
      paths[0]
    }
  }
  #Have tar chop off all of the relative file business prefixes so we can just
  #upload everything to the same cookbooks directory
  #transforms = CookbooksPath.map{|path| "--transform=s,^#{path.gsub(/^\//, '')},cookbooks, "}
  #`tar czf cookbooks.tgz --files-from recipe_list #{transforms*' '} 2> /dev/null`
  `tar czf cookbooks.tgz --files-from recipe_list 2> /dev/null`
  `rm recipe_list`
end
