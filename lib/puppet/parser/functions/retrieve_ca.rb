module Puppet::Parser::Functions
  newfunction(:retrieve_ca, :type => :rvalue) do |args|
    raise ArgumentError, "retrieve_ca takes no arguments" unless args.count == 0

    function_fingerpuppet ['--certificate', 'ca']
  end
end
