file "/var/www/index.html" do
  action :delete
  only_if { File.exists?("/var/www/index.html") }
end

cookbook_file "activeCollab.tar.gz" do
	path "/var/www/activeCollab.tar.gz"
	action :create_if_missing
end

bash 'unpack activeCollab' do
	code <<-EOH
		cd /var/www \
		&& tar -ixzf activeCollab.tar.gz \
		&& cd /var/www/activecollab \
		&& mv * .[^.]* .. \
		&& cd /var/www \
		&& rm -rf activecollab
	EOH
	not_if { ::File.exists?("/var/www/index.php") }
end

file "/var/www/config/config.php" do
	mode "777"
	owner "www-data"
	group "www-data"
end

dirs = [
	"/var/www/public/files",
	"/var/www/cache",
	"/var/www/upload"
]
dirs.each do |dir|
	directory dir do
		mode "1777"
		owner "www-data"
		group "www-data"
	end
end
