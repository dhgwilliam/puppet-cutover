require 'spec_helper'
require 'puppet'
require 'mocha/api'
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_internals'

RSpec.configure { |config| config.mock_framework = :mocha }

describe 'retrieve_cert' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should raise an error with more than 1 params' do
    expect { subject.call(['new-master.puppet.labs', 'old-master.puppet.labs']) }.to raise_error(ArgumentError)
  end

  it 'should return something that looks like a certificate' do
    cert = subject.call(['new-master.puppet.labs'])
    expect(cert).to match(/-----BEGIN CERTIFICATE-----/)
  end
end
