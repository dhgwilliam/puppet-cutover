require 'json'

module Puppet::Parser::Functions
  newfunction(:ensure_signed) do |args|
    raise ArgumentError, "ensure_signed expects one argument" unless args.count == 1
    @certname = args.first

    response = function_fingerpuppet(['--cert_status', @certname])
    raise Puppet::Error, "The status response didn't match the certname" if !response.match(@certname)

    begin
      state = JSON::parse(response)['state']
    rescue
      return
    end

    if state != 'signed' and state == 'requested'
      function_fingerpuppet(['--sign', @certname])
    end
  end
end
