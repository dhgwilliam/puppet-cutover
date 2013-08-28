class cutover::pitcher inherits cutover {
  anchor { 'cutover::pitcher::begin': } ->
  file { $ssl_parents:
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0755',
  } ->
  file { $ssl_dir:
    ensure => directory,
    # owner => 'root',
    group => 'root',
    mode => '0751'
  } ->
  exec { 'create private key and request cert':
    command => "${which_puppet} agent -t --noop --server ${new_master} --rundir /tmp --ssldir ${ssl_dir}",
    creates => "${ssl_dir}/certificate_requests/${agent}.pem",
    # returns => [0,1],
  } ->
  file { 'ca cert':
    path      => "${ssl_dir}/certs/ca.pem",
    ensure    => file,
    show_diff => false,
    content   => retrieve_ca(),
  } ->
  file { 'node cert':
    path      => "${ssl_dir}/certs/${agent}.pem",
    ensure    => file,
    show_diff => false,
    content   => retrieve_cert($agent),
  } ->
  class { 'cutover::puppet_conf': } ->
  anchor { 'cutover::pitcher::end': }
}

