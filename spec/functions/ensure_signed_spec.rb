require 'spec_helper'
require 'puppet'
require 'mocha/api'
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_internals'

RSpec.configure { |config| config.mock_framework = :mocha }

describe 'ensure_signed' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should raise an error when args != 1' do
    expect { scope.function_ensure_signed(['agent.puppet.labs', 'new-master.puppet.labs']) }.to raise_error(ArgumentError)
    expect { scope.function_ensure_signed([]) }.to raise_error(ArgumentError)
  end

  it 'should run without errors if the cert is already signed' do
    scope.stubs(:function_fingerpuppet).returns('{"state":"signed","fingerprint":"02:68:0D:A9:FA:B9:E6:D1:25:88:32:14:2B:98:BA:70","dns_alt_names":[],"name":"old-master.puppet.labs","fingerprints":{"SHA512":"4E:85:D6:67:32:02:C4:3F:CE:94:B0:8C:D1:64:AA:67:9C:02:C1:13:6B:D0:47:06:6A:97:28:60:50:36:17:64:BA:D9:F8:36:E9:05:EA:DD:25:DF:DA:2D:12:CF:C3:36:FF:59:0A:A7:DC:E6:15:E4:03:06:A0:39:0E:C9:F2:D3","MD5":"02:68:0D:A9:FA:B9:E6:D1:25:88:32:14:2B:98:BA:70","SHA256":"59:9B:D9:86:5F:10:8C:E2:8D:D9:FB:81:F2:8C:23:41:2E:FB:E8:34:C8:E0:47:9E:E4:B5:55:4D:52:1B:22:07","default":"02:68:0D:A9:FA:B9:E6:D1:25:88:32:14:2B:98:BA:70","SHA1":"54:F1:4B:F0:E8:A2:E9:3D:A0:79:AD:DA:6D:F2:6B:2D:80:E8:8B:60"}}')
    expect { scope.function_ensure_signed(['old-master.puppet.labs']) }.not_to raise_error
  end

  it 'should raise error when status_response !matches cert name' do
    scope.stubs(:function_fingerpuppet).returns('{"state":"signed","fingerprint":"02:68:0D:A9:FA:B9:E6:D1:25:88:32:14:2B:98:BA:70","dns_alt_names":[],"name":"old-master.puppet.labs","fingerprints":{"SHA512":"4E:85:D6:67:32:02:C4:3F:CE:94:B0:8C:D1:64:AA:67:9C:02:C1:13:6B:D0:47:06:6A:97:28:60:50:36:17:64:BA:D9:F8:36:E9:05:EA:DD:25:DF:DA:2D:12:CF:C3:36:FF:59:0A:A7:DC:E6:15:E4:03:06:A0:39:0E:C9:F2:D3","MD5":"02:68:0D:A9:FA:B9:E6:D1:25:88:32:14:2B:98:BA:70","SHA256":"59:9B:D9:86:5F:10:8C:E2:8D:D9:FB:81:F2:8C:23:41:2E:FB:E8:34:C8:E0:47:9E:E4:B5:55:4D:52:1B:22:07","default":"02:68:0D:A9:FA:B9:E6:D1:25:88:32:14:2B:98:BA:70","SHA1":"54:F1:4B:F0:E8:A2:E9:3D:A0:79:AD:DA:6D:F2:6B:2D:80:E8:8B:60"}}')
    expect { scope.function_ensure_signed(['agent.puppet.labs']) }.to raise_error(Puppet::Error)
  end
end
