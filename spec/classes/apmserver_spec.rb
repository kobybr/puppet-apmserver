require 'spec_helper'

describe 'apmserver' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('apmserver::config') }
        it { is_expected.to contain_class('apmserver::package') }
        it { is_expected.to contain_class('apmserver::service') }
      end
      context 'with manage repo' do
        let(:params) { { manage_repo: true } }

        it { is_expected.to contain_class('elastic_stack::repo') }
      end
      context 'without manage repo' do
        let(:params) { { manage_repo: false } }

        it { is_expected.not_to contain_class('elastic_stack::repo') }
      end
    end
  end
end
