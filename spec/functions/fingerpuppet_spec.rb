require 'spec_helper'

describe 'fingerpuppet' do
  it { should run.with_params() }
  it { should run.with_params('--server', 'old-master.puppet.labs') }

end
