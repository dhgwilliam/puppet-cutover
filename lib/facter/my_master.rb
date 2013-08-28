Facter.add("which_puppet") do
  setcode do
    Facter::Util::Resolution.exec('/bin/which puppet')
  end
end

Facter.add("my_master") do
  setcode do
    Facter::Util::Resolution.exec("#{Facter.which_puppet} agent --configprint server")
  end
end

Facter.add("my_ca") do
  setcode do
    Facter::Util::Resolution.exec("#{Facter.which_puppet} agent --configprint server")
  end
end
