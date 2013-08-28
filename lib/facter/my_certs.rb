Facter.add("pe_certs") do
  ca_check = "/usr/bin/openssl x509 -noout -text -in /etc/puppetlabs/puppet/ssl/certs/ca.pem"
  ca_code = `#{ca_check}; echo $?`.to_i
  cert_check = "/usr/bin/openssl x509 -noout -text -in /etc/puppetlabs/puppet/ssl/certs/#{Facter.fqdn}.pem"
  cert_code = `#{cert_check}; echo $?`.to_i
  puts "ca: #{ca_code} cert: #{cert_code}"
  if ca_code == 0 and cert_code == 0
    setcode { "true" }
  else
    setcode { "false" }
  end
end


