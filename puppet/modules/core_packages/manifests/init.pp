class core_packages {

    $packages = [
        'build-essential',
        'rake',
        'rubygems',
        'sshpass',
        'vim',
    ]

    exec { 'apt-get-up':
        command => 'apt-get update',
        timeout => 0
    }
    ->
    package { $packages:
        ensure => 'installed'
    }

}
