require 'spec_helper'

describe "#{File.basename(Dir.getwd)}::default" do
	let(:chef_run) {
		ChefSpec::ChefRunner.new(
			platform: 'ubuntu', version: '12.04'
		).converge("#{described_cookbook}::default")
	}

	it 'installs curl' do
		expect(chef_run).to install_package 'curl'
	end

	it 'kills beam' do
		expect(chef_run).to execute_command('killall beam')
	end

	it 'restarts couchdb' do
		expect(chef_run).to restart_service 'couchdb'
	end
end