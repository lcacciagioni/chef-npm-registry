#!/usr/bin/env rake

desc 'Runs foodcritic linter'
task :lint do
	sh 'foodcritic --epic-fail any .'
end

task :default => 'lint'