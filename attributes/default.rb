#
# Cookbook Name:: npm_registry
# Attributes:: default
#
# Copyright 2013 Cory Roloff
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['npm_registry']['git']['url']                      = 'https://github.com/isaacs/npmjs.org.git'
default['npm_registry']['git']['reference']                = 'master'

default['npm_registry']['couchdb']['couch']                = '/usr/local/var/lib/couchdb/registry.couch'
default['npm_registry']['couchdb']['username']             = ''
default['npm_registry']['couchdb']['password']             = ''
default['npm_registry']['couchdb']['port']                 = '5984'

default['npm_registry']['registry']['url']                 = 'http://localhost:5984/registry'

default['npm_registry']['isaacs']['registry']['url']       = 'http://isaacs.iriscouch.com/registry/'

default['npm_registry']['replication']['use_replication']  = false

default['npm_registry']['replication']['cron']['use_cron'] = false
default['npm_registry']['replication']['cron']['minute']   = '*'
default['npm_registry']['replication']['cron']['hour']     = '*'
default['npm_registry']['replication']['cron']['weekday']  = '*'
default['npm_registry']['replication']['cron']['day']      = '*'
default['npm_registry']['replication']['cron']['month']    = '*'