require 'spec_helper'

describe 'apmserver::package' do
  let(:pre_condition) { 'include apmserver' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
