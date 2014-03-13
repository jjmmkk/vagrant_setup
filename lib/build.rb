module Build


	class Build

		@@vms_dir = 'vms'
		@@setups_dir = 'setups'
		@@synced_dir = 'synced_folder'

		def initialize()
			@setup = Build.prompt_setup()
			@provider = Build.prompt_provider()
			@vm_name = Build.prompt_vm_name()
			@vm_dir = Build.get_vm_dir(@vm_name)
		end

		def self.get_vm_dir(vm_name)
			return [@@vms_dir, vm_name] * '/'
		end

		def self.prompt_setup()
			setups = Dir["#{@@setups_dir}/*"].each { |e| e.gsub!("#{@@setups_dir}/", '') }
			return self.prompt_value_from_list( 'Choose a setup', setups )
		end

		def self.prompt_provider()
			providers = [
				'virtualbox',
				'vmware_fusion'
			]
			return self.prompt_value_from_list( 'Choose a provider', providers )
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

		def self.prompt_value_from_list (prompt, list)
			unless list.is_a? Array
				raise(ArgumentError, 'List must be an array')
			end

			prompt_list = ''
			list.each_with_index do |value, index|
				prompt_list << "#{index + 1}) #{value}\n"
			end

			while true
				STDOUT.puts("#{prompt} (n)")
				STDOUT.puts(prompt_list)
				STDOUT.print('> ')
				input = STDIN.gets.chomp
				if input =~ /\A[0-9]+\Z/
					chosen = input.to_i - 1
					unless list[chosen].nil?
						break
					end
				end
			end

			return list[chosen]
		end

	end


	class Contained < Build

		def initialize()
			super

			system "mkdir -p #{@vm_dir}"
			# The 'data' directory will be the shared directory of the host
			system "mkdir -p #{@vm_dir}/#{@@synced_dir}"
			system "cp -r #{@@setups_dir}/#{@setup}/* #{@vm_dir}/"
			system "cd #{@vm_dir} && vagrant up --provision --provider=#{@provider}"
		end

	end


end
