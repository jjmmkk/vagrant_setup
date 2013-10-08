# Load classes

require 'lib/classes/build'


# Help

task :default => [:help]
task :help do
	STDOUT.puts(`rake -D`)
end


# Build
task :build => ['build:contained']
namespace :build do

	desc "Build a contained VM, intended to be short lived"
	task :contained do
		Build::Contained.new()
	end

	# @todo
	desc "Build a standalone VM"
	task :standalone do
		Build::Standalone.new()
	end

end
