require './lib/build'


# Task: Help
task :default => [:help]
task :help do
	system 'rake -D'
end


# Task: Build
desc 'Build a VM'
task :build do
	Build::Contained.new()
end
