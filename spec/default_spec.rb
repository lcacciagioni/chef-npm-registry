require 'spec_helper'

describe "#{File.basename(Dir.getwd)}::default" do
	let(:runner) {
		ChefSpec::ChefRunner.new(
			platform: 'ubuntu', version: '12.04'
		).converge("#{described_cookbook}::default")
	}

	it 'should' do

	end
end