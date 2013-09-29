link "/etc/apache2/sites-enabled/default" do
	to "/etc/apache2/sites-available/default"
	link_type :symbolic
	notifies :restart, "service[apache2]", :delayed
end
