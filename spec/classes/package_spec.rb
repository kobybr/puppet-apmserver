require 'spec_helper'
describe 'apmserver::package' do
  let(:pre_condition) do
    "class { 'apmserver':
      manage_repo         => #{manage_repo},
      package_version     => '#{package_version}',
      package_ensure      => '#{package_ensure}',
      package_name        => '#{package_name}',
      package_config_path => '#{package_config_path}',
    }"
  end

  let(:manage_repo) { true }
  let(:package_version) { 'latest' }
  let(:package_ensure) { 'present' }
  let(:package_name) { 'apm-server' }
  let(:package_config_path) { '/etc/apm-server' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      context 'Standard conditions' do
        it { is_expected.to contain_package(package_name) }
        it { is_expected.to contain_class('elastic_stack::repo') }

        case os_facts[:osfamily]
        when 'RedHat'
          it { is_expected.to contain_file("#{package_config_path}/apm-server.yml.rpmnew") }
          it {
            is_expected.to contain_yumrepo('elastic').with(
              enabled: '1',
            )
          }
        when 'Debian'
          it { is_expected.to contain_file("#{package_config_path}/apm-server.yml.dpkg-dist") }

          it {
            is_expected.to contain_apt__source('elastic').with(
              ensure: 'present',
            )
          }
        end
      end

      context 'Repo not managed' do
        let(:manage_repo) { false }

        it { is_expected.not_to contain_class('elastic_stack::repo') }
      end
    end
  end
end
