module Puppet::Parser::Functions
  newfunction(:retrieve_cert, :type => :rvalue) do |args|
    raise ArgumentError, "retrieve_cert takes exactly one argument" unless args.count == 1
    @certname = args.first

    function_ensure_signed([@certname])
    function_fingerpuppet(['--certificate', @certname])
  end
end
