#
# Cookbook Name:: npm_registry
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

require 'minitest/spec'
require 'net/http'

describe_recipe 'npm_registry::default' do
	it 'should receive status 200 on /_replicator' do
		assert_equal 200, Net::HTTP.get_response(URI("#{node['npm_registry']['registry']['url']}/_replicator")).code
	end

	it 'should receive status 200 on /_replicator/_design/_replicator' do
		assert_equal 200, Net::HTTP.get_response(URI("#{node['npm_registry']['registry']['url']}/_replicator")).code
	end

	it 'should receive status 200 on /registry' do
		assert_equal 200, Net::HTTP.get_response(URI("#{node['npm_registry']['registry']['url']}/registry")).code
	end
end