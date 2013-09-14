require 'spec_helper'

describe "#{File.basename(Dir.getwd)}::default" do
	let(:chef_run) {
		ChefSpec::ChefRunner.new(
			:evaluate_guards => true,
			platform: 'ubuntu',
			version:'12.04'
		)
	}

	before(:each){
		File.stub(:exists?).and_call_original
	}

	it 'should install and configure default steps when the couch database file is missing' do
		File.should_receive(:exists?).with('/usr/local/var/lib/couchdb/registry.couch').and_return(false)

		chef_run.converge("#{described_cookbook}::default")

		expect(chef_run).to install_package 'curl'
		expect(chef_run).to execute_command 'killall beam'
		expect(chef_run).to restart_service 'couchdb'
	end

	it 'should install and configure default steps when the couch database file is not missing' do
		File.should_receive(:exists?).with('/usr/local/var/lib/couchdb/registry.couch').and_return(true)

		chef_run.converge("#{described_cookbook}::default")

		expect(chef_run).to install_package 'curl'
		expect(chef_run).to execute_command 'killall beam'
		expect(chef_run).to restart_service 'couchdb'
	end

	it 'should install and configure an NPM registry when the couch database file is missing' do
		File.should_receive(:exists?).with('/usr/local/var/lib/couchdb/registry.couch').and_return(false)

		chef_run.converge("#{described_cookbook}::default")

		expect(chef_run).to log "Created database at #{chef_run.node.default['npm_registry']['registry']['url']}"
		expect(chef_run).to log "Cloned #{chef_run.node.default['npm_registry']['git']['url']}@#{chef_run.node.default['npm_registry']['git']['reference']}"
		expect(chef_run).to execute_command 'npm install couchapp -g'
		expect(chef_run).to execute_command 'npm install couchapp'
		expect(chef_run).to execute_command 'npm install semver'
		expect(chef_run).to execute_command './push.sh'
		expect(chef_run).to execute_command './load-views.sh'
		expect(chef_run).to execute_bash_script "COPY _design/app"
		expect(chef_run).to execute_command "couchapp push www/app.js #{chef_run.node.default['npm_registry']['registry']['url']}"
	end

	it 'should not install and configure an NPM registry when the couch database file is not missing' do
		File.should_receive(:exists?).with('/usr/local/var/lib/couchdb/registry.couch').and_return(true)

		chef_run.converge("#{described_cookbook}::default")

		expect(chef_run).not_to log "Created database at #{chef_run.node.default['npm_registry']['registry']['url']}"
		expect(chef_run).not_to log "Cloned #{chef_run.node.default['npm_registry']['git']['url']}@#{chef_run.node.default['npm_registry']['git']['reference']}"
		expect(chef_run).not_to execute_command 'npm install couchapp -g'
		expect(chef_run).not_to execute_command 'npm install couchapp'
		expect(chef_run).not_to execute_command 'npm install semver'
		expect(chef_run).not_to execute_command './push.sh'
		expect(chef_run).not_to execute_command './load-views.sh'
		expect(chef_run).not_to execute_bash_script "COPY _design/app"
		expect(chef_run).not_to execute_command "couchapp push www/app.js #{chef_run.node.default['npm_registry']['registry']['url']}"
	end

	it 'should use cron.d replication without authentication' do
		chef_run.node.set['npm_registry']['replication']['use_replication'] = true
		chef_run.node.set['npm_registry']['replication']['cron']['use_cron'] = true

		chef_run.converge('cron::default', "#{described_cookbook}::default")

		expect(chef_run).not_to log 'Using authentication for cron.d replication'
		expect(chef_run).to log 'Configured cron.d replication'
	end

	it 'should use cron.d replication with authentication' do
		chef_run.node.set['npm_registry']['replication']['use_replication'] = true
		chef_run.node.set['npm_registry']['replication']['cron']['use_cron'] = true
		chef_run.node.set['npm_registry']['couchdb']['username'] = 'username'
		chef_run.node.set['npm_registry']['couchdb']['password'] = 'password'

		chef_run.converge('cron::default', "#{described_cookbook}::default")

		expect(chef_run).to log 'Using authentication for cron.d replication'
		expect(chef_run).to log 'Configured cron.d replication'
	end
end