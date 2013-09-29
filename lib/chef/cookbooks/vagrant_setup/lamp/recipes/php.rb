pkgs = [
	"php5-curl",
	"php5-gd",
	"php5-mcrypt",
	"php5-mysql"
]

pkgs.each do |pkg|
	package pkg do
		action :install
	end
end
