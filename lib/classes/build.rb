require 'erb'

module Build

	class Build

		@@vms_dir = 'vms'

		def initialize()
			@setup = Build.prompt_setup()
			@vm_name = Build.prompt_vm_name()
			@vm_dir = Build.get_vm_dir(@vm_name)
		end

		def self.get_vm_dir(vm_name)
			return [@@vms_dir, vm_name] * '/'
		end

		def self.prompt_setup()
			setups = Dir['setups/*'].each { |e| e.gsub!('setups/', '') }
			setups_list = ''
			setups.each_with_index do |setup_name, index|
				setups_list << "#{index + 1}) #{setup_name}\n"
			end

			while true
				STDOUT.puts('Choose a setup (n)')
				STDOUT.puts(setups_list)
				STDOUT.print('> ')
				setup = STDIN.gets.chomp.to_i - 1
				unless setups[setup].nil?
					break
				end
			end

			return setups[setup]
		end

		def self.prompt_vm_name()
			STDOUT.puts('Give the VM a name (alphanumerics, underscores, dashes)')
			while true
				STDOUT.print('> ')
				vm_name = STDIN.gets.chomp
				if vm_name =~ /^[a-zA-Z0-9\-_]+$/
					break
				end
			end

			if File.exists?(Build.get_vm_dir(vm_name))
				STDOUT.puts("VM '#{vm_name}' already exists")
				exit
			end
			return vm_name
		end

	end


	class Contained < Build

		def initialize()
			super

			@config_path = ['../../setups', @setup, 'config.json'] * '/'
			@chef_path = '../../lib/chef'
			@cookbook_paths = [
				[@chef_path, 'cookbooks/opscode'] * '/',
				[@chef_path, 'cookbooks/vagrant_setup'] * '/'
			]
			@role_paths = [[@chef_path, 'roles'] * '/']

			Rake::sh "mkdir -p #{@vm_dir}"
			# The 'data' directory will be the shared directory of the host
			Rake::sh "mkdir -p #{@vm_dir}/data"

			vagrantfile_template = ::ERB.new(File.read('lib/templates/vagrantfile.erb'))
			vagrantfile_contents = vagrantfile_template.result(binding)
			File.open([@vm_dir, 'Vagrantfile'] * '/', 'w') { |file| file.write( vagrantfile_contents ) }

			Rake::sh "cd #{@vm_dir} && vagrant up --provision"
		end

	end


	# @todo
	class Standalone < Build

		def initialize()
			super

			STDOUT.puts('Not yet implemented')
		end

	end

end
