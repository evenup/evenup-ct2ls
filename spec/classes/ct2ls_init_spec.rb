require 'spec_helper'

describe 'ct2ls', :type => :class do

  let(:params) {{:access_key_id => 'abcde', :secret_access_key => '12345'}}

  it { should create_class('ct2ls') }
  it { should contain_class('ct2ls::install') }
  it { should contain_class('ct2ls::config') }
  it { should contain_class('ct2ls::service') }

end
