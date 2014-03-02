Exec {
	path => [
		'/bin/',
		'/sbin/',
		'/usr/bin/',
		'/usr/sbin/'
	]
}

stage { 'core_prerun':
    before => Stage['main'],
}
class { 'stdlib':
    stage => 'core_prerun'
}
class { 'puppi':
    stage => 'core_prerun'
}
class { 'core_packages':
    stage => 'core_prerun'
}
class { 'git':
    stage => 'core_prerun'
}
