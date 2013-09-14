#
# Cookbook Name:: npm_registry
# Recipe:: default
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

_npm_registry = node['npm_registry'];
_git = _npm_registry['git']
_couchdb = _npm_registry['couchdb']
_registry = _npm_registry['registry']
_isaacs = _npm_registry['isaacs']
_replication = _npm_registry['replication']
_cron = _replication['cron']

package 'curl' do
  action :install
end

execute 'killall beam' do
  command 'killall beam'
  returns [0, 1]
  action :run
end

service 'couchdb' do
  action :restart
end

__file_exists = File.exists?(_couchdb['couch'])

http_request 'create registry database' do
  url _registry['url']
  not_if { __file_exists }
  action :put
end

log "Created database at #{_registry['url']}" do
  not_if { __file_exists }
end

git "#{Chef::Config['file_cache_path']}/npmjs.org" do
  repository _git['url']
  reference _git['reference']
  not_if { __file_exists }
  action :sync
end

log "Cloned #{_git['url']}@#{_git['reference']}" do
  not_if { __file_exists }
end

execute 'npm install couchdb -g' do
  command 'npm install couchapp -g'
  cwd "#{Chef::Config['file_cache_path']}/npmjs.org"
  not_if { __file_exists }
  action :run
end

execute 'npm install couchapp' do
  command 'npm install couchapp'
  cwd "#{Chef::Config['file_cache_path']}/npmjs.org"
  not_if { __file_exists }
  action :run
end

execute 'npm install semver' do
  command 'npm install semver'
  cwd "#{Chef::Config['file_cache_path']}/npmjs.org"
  not_if { __file_exists }
  action :run
end

execute 'push.sh' do
  command './push.sh'
  cwd "#{Chef::Config['file_cache_path']}/npmjs.org"
  environment({'npm_package_config_couch' => _registry['url']})
  not_if { __file_exists }
  action :run
end

execute 'load-views.sh' do
  command './load-views.sh'
  cwd "#{Chef::Config[:file_cache_path]}/npmjs.org"
  environment({'npm_package_config_couch' => _registry['url']})
  not_if { __file_exists }
  action :run
end

bash 'COPY _design/app' do
  code <<-EOH
    curl #{_registry['url']}/_design/scratch -X COPY -H destination:'_design/app'
  EOH
  not_if { __file_exists }
end

execute "couchapp push www/app.js #{_registry['url']}" do
  command "couchapp push www/app.js #{_registry['url']}"
  cwd "#{Chef::Config['file_cache_path']}/npmjs.org"
  not_if { __file_exists }
  action :run
end

if _replication['use_replication'] && _cron['use_cron']
  __authentication = ''

  if !_couchdb['username'].empty?() && !_couchdb['password'].empty?()
    __authentication = "#{_couchdb['username']}:#{_couchdb['password']}@"

    log "Using authentication for cron.d replication"
  end

  cron_d 'npm_registry' do
    action :create
    minute _cron['minute']
    hour _cron['hour']
    weekday _cron['weekday']
    day _cron['day']
    command %Q{curl -X POST -H "Content-Type:application/json" http://#{__authentication}localhost:#{_couchdb['port']}/_replicate -d '{"source":"#{_isaacs['registry']['url']}", "target":"registry"}'}
  end

  log "Configured cron.d replication"
end