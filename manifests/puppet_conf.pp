class cutover::puppet_conf inherits cutover::pitcher {
  if $::pe_certs == 'true' {
    ini_setting { "puppet.conf server setting":
      path    => '/etc/puppet/puppet.conf',
      section => 'agent',
      setting => 'server',
      value   => $new_master,
      ensure  => present,
    } ->
    ini_setting { "puppet.conf ca_server setting":
      path    => '/etc/puppet/puppet.conf',
      section => 'agent',
      setting => 'ca_server',
      value   => $new_master,
      ensure  => present,
    } ->
    ini_setting { "puppet.conf ssldir setting":
      path    => '/etc/puppet/puppet.conf',
      section => 'agent',
      setting => 'ssldir',
      value   => $ssl_dir,
      ensure  => present,
    }
  }
}
