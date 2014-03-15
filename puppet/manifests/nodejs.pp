import 'components/core.pp'


class fix_nodejs_package {
	class { '::apt': }
	apt::ppa { 'ppa:chris-lea/node.js':}
}

class fix_nodejs_install inherits fix_nodejs_package {
	class { '::nodejs':
		version => 'latest',
		require => Apt::Ppa['ppa:chris-lea/node.js'],
	}
	package { 'npm':
		ensure => present,
		provider => 'npm',
		require => Class['::nodejs'],
	}
}

class { 'fix_nodejs_install': }
