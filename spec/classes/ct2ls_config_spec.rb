require 'spec_helper'

describe 'ct2ls', :type => :class do

  let(:params) { { :access_key_id => 'abcde', :secret_access_key => '12345' } }

  context 'default params' do
    it { should contain_file('/etc/ct2ls.yaml') }
    it { should contain_file('/etc/ct2ls.yaml').with(:content => /^\s+:access_key_id: abcde$/) }
    it { should contain_file('/etc/ct2ls.yaml').with(:content => /^\s+:secret_access_key: 12345$/) }
    it { should contain_file('/etc/ct2ls.yaml').with(:content => /^\s+:sqs_queue: cloudtrail$/) }
    it { should contain_file('/etc/ct2ls.yaml').with(:content => /^\s+:redis_host: localhost$/) }
    it { should contain_file('/etc/ct2ls.yaml').with(:content => /^\s+:redis_port: 6379$/) }
    it { should contain_file('/etc/ct2ls.yaml').with(:content => /^\s+:redis_db: 0$/) }
    it { should contain_file('/etc/ct2ls.yaml').with(:content => /^\s+:tmp_path: \/tmp$/) }
    it { should contain_file('/etc/ct2ls.yaml').with(:content => /^\s+:remove_original: true$/) }
    it { should contain_file('/etc/ct2ls.yaml').with(:content => /^\s+:logpath: \/var\/log\/ct2ls$/) }
    it { should contain_file('/etc/ct2ls.yaml').with(:content => /^\s+:loglevel: INFO$/) }
  end

end

