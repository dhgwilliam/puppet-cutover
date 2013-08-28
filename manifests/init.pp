class cutover (
  $old_master,
  $new_master,
  $agent        = $::fqdn,
  $ssl_dir      = '/etc/puppetlabs/puppet/ssl',
  $ssl_parents  = ['/etc/puppetlabs','/etc/puppetlabs/puppet'],
  $which_puppet = $::which_puppet,
) {
  if $my_master == $old_master {
    include cutover::pitcher
  }
}
