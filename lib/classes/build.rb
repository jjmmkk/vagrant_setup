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

			system "mkdir -p #{@vm_dir}"
			# The 'data' directory will be the shared directory of the host
			system "mkdir -p #{@vm_dir}/data"

			system "cp setups/#{@setup}/* #{@vm_dir}/"

			system "cd #{@vm_dir} && vagrant up --provision"
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
