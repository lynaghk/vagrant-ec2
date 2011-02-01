#
# Cookbook Name:: monit
# Definition:: monit_check
#
# Copyright 2010, Estately, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

define :monit_check do

  required_keys = %w[
    pidfile
    start_command
    stop_command
  ]

  required_keys.each do |key|
    raise "Missing parameter #{key}" unless params.key?( key.to_sym )
  end

  template "/etc/monit/conf.d/#{params[:name]}" do
    cookbook "monit"
    source "monit_check.erb"

    owner "root"
    group "root"
    mode  0644

    variables params

    notifies :restart, resources( :service => "monit" )
  end

end
