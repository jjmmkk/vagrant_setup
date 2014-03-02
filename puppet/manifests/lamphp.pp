import 'core.pp'

include augeas


# MySQL

class { 'mysql':
	root_password => 'root',
}


# Apache

class { 'apache': }

apache::module { 'rewrite': }

file { '/var/www':
    ensure => directory,
}
->
file { '/var/www/index.html':
    ensure => absent,
}


# PHP

class { 'php': }

$php_modules = [
	'cli',
	'curl',
	'gd',
	'imagick',
	'intl',
	'ldap',
	'memcached',
	'mysql',
	'xsl',
]
php::module { $php_modules: }
php::module { 'apc':
    module_prefix => 'php-',
}

php::ini { 'php':
	value => [
		'date.timezone = "Europe/Oslo"',
		'memory_limit = 1024M',
	],
	target => 'php.ini',
	service => 'apache',
}

include composer
