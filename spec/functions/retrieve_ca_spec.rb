require 'spec_helper'
require 'puppet'

describe 'retrieve_ca' do
  it 'should run successfully with 0 params' do
    expect { subject.call([]) }.not_to raise_error()
  end

  it 'should return something that resembles a certificate' do
    expect { subject.call([]) =~ /-----BEGIN CERTIFICATE-----/ }
  end

  it 'should raise error when run with more than 0 args' do
    expect { subject.call(['new-master.puppet.labs']) }.to raise_error(ArgumentError)
  end
end
