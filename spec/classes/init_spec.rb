require 'spec_helper'
describe 'rsyslog_client' do
  context 'with default values for all parameters' do
    it { should contain_class('rsyslog_client') }
  end
end
