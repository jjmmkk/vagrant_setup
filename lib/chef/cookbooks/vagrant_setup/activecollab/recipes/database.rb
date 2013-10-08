include_recipe "mysql::server"
include_recipe "database::mysql"

mysql_database_user node['mysql']['username'] do
	connection( {
		:host => 'localhost',
		:username => node['mysql']['username'],
		:password => node['mysql']['server_root_password']
	} )
	database_name node['mysql']['name']
	password node['mysql']['password']
	privileges [:all]
	action :grant
end

mysql_database node['mysql']['name'] do
	connection( {
		:host => 'localhost',
		:username => node['mysql']['username'],
		:password => node['mysql']['server_root_password']
	} )
	action :create
end
