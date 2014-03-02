import 'core.pp'


# MySQL

class { 'mysql':
	root_password => 'root',
}


# Apache

class { 'apache': }

apache::mod { 'rewrite': }

file { '/var/www':
    ensure => directory,
    owner => 'root',
    group => 'root',
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
        'memory_limit = 1024M'
    ],
    target => 'php.ini',
}

include composer
