module Puppet::Parser::Functions
  newfunction(:fingerpuppet, :type => :rvalue) do |args|
    cmd = ['env', 'HOME=/var/lib/puppet', '/usr/bin/fingerpuppet'].join(" ")
    args.each { |arg| cmd << " " << arg }
    `#{cmd}`
  end
end
