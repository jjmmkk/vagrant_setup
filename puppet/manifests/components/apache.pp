class { 'apache': }

apache::module { 'rewrite': }

file { '/var/www':
    ensure => directory,
}
->
file { '/var/www/index.html':
    ensure => absent,
}
