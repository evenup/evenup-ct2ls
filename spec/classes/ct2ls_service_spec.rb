require 'spec_helper'

describe 'ct2ls', :type => :class do

  let(:params) { { :access_key_id => 'abcde', :secret_access_key => '12345' } }

  it { should create_class('ct2ls::service') }
  it { should contain_service('ct2ls').with(:ensure => 'running', :enable => 'true' ) }

end
