#
# Cookbook Name:: monit
# Attributes:: default
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

default.monit.interval    120
default.monit.start_delay 240

default.monit.mail.server  "localhost"
default.monit.mail.from    "monit@#{node.fqdn}"
default.monit.mail.to      "ops@example.com"
default.monit.mail.subject "monit alert -- $SERVICE $EVENT"

default.monit.web.enabled false
default.monit.web.bind_to "localhost"
default.monit.web.port    2812
default.monit.web.allow   "localhost"
