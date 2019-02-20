require 'spec_helper'

describe 'apmserver::service' do
  let(:pre_condition) do
    "class { 'apmserver':
      service_ensure => '#{service_ensure}',
      service_enable => '#{service_enable}',
      service_name   => '#{service_name}',
    }"
  end

  let(:service_ensure) { 'running' }
  let(:service_enable) { 'true' }
  let(:service_name) { 'apm-server' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      context 'Standard conditions' do
        it {
          is_expected.to contain_service(service_name).with(
            'ensure' => service_ensure,
            'enable' => service_enable,
            'name'   => service_name,
          )
        }
      end

      context 'With service disabled' do
        let(:service_ensure) { 'stopped' }
        let(:service_enable) { 'false' }

        it {
          is_expected.to contain_service(service_name).with(
            'ensure' => service_ensure,
            'enable' => service_enable,
            'name'   => service_name,
          )
        }
      end
    end
  end
end
