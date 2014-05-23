require 'spec_helper'

describe 'ct2ls', :type => :class do

  let(:params) { { :access_key_id => 'abcde', :secret_access_key => '12345' } }

  it { should create_class('ct2ls::install') }
  it { should contain_user('ct2ls') }
  it { should contain_group('ct2ls') }
  it { should contain_file('/usr/share/ct2ls').with(:ensure => 'directory') }
  it { should contain_file('/usr/share/ct2ls/ct2ls.rb') }
  it { should contain_file('/var/run/ct2ls').with(:ensure => 'directory') }
  it { should contain_file('/var/log/ct2ls').with(:ensure => 'directory') }

  context 'custom log dir' do
    let(:params) { { :logpath => '/usr/log/ct2ls', :access_key_id => 'abcde', :secret_access_key => '12345' } }
    it { should contain_file('/usr/log/ct2ls').with(:ensure => 'directory') }
  end

end
