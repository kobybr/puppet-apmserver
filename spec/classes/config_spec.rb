require 'spec_helper'

describe 'apmserver::config' do
  let(:pre_condition) do
    "class { 'apmserver':
      merge_default_config          => #{merge_default_config},
      package_ensure                => '#{package_ensure}',
      package_config_path           => '#{package_config_path}',
      apmserver_config_custom       => #{apmserver_config_custom},
      apmserver_default_config_file => '#{apmserver_default_config_file}',
    }"
  end

  let(:merge_default_config) { true }
  let(:package_ensure) { 'present' }
  let(:package_config_path) { '/etc/apm-server' }
  let(:apmserver_config_custom) do
    {
      'apm-server' => { 'host' => '10.1.1.1:8200' },
      'output.elasticsearch' => {
        'hosts' => ['192.168.1.1:9200', '192.168.1.2:9200'],
        'enabled' => true,
      },
    }
  end

  let(:apmserver_default_config_file) { 'spec/fixtures/files/apm-server.yml.rpmnew' }

  let(:apmserver_config_defaults) do
    { 'output.elasticsearch' => { 'enabled' => true, 'indices' => [{ 'when.contains' => { 'processor.event' => 'sourcemap' }, 'index' => 'apm-%{[beat.version]}-sourcemap' }, { 'when.contains' => { 'processor.event' => 'error' }, 'index' => 'apm-%{[beat.version]}-error-%{+yyyy.MM.dd}' }, { 'when.contains' => { 'processor.event' => 'transaction' }, 'index' => 'apm-%{[beat.version]}-transaction-%{+yyyy.MM.dd}' }, { 'when.contains' => { 'processor.event' => 'span' }, 'index' => 'apm-%{[beat.version]}-span-%{+yyyy.MM.dd}' }, { 'when.contains' => { 'processor.event' => 'metric' }, 'index' => 'apm-%{[beat.version]}-metric-%{+yyyy.MM.dd}' }, { 'when.contains' => { 'processor.event' => 'onboarding' }, 'index' => 'apm-%{[beat.version]}-onboarding-%{+yyyy.MM.dd}' }] }, 'xpack.monitoring.enabled' => true } # rubocop:disable LineLength
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      context 'Standard conditions' do
        it {
          is_expected.to contain_file("#{package_config_path}/apm-server.yml")
            .with(
              'content' => %r{---\napm-server:\n  host: 10.1.1.1:8200\noutput.elasticsearch:\n  hosts:\n  - 192.168.1.1:9200\n  - 192.168.1.2:9200\n  indices:\n  - index: apm-%{\[beat.version\]}-sourcemap\n    when.contains:\n      processor.event: sourcemap\n  - index: apm-%{\[beat.version\]}-error-%{\+yyyy.MM.dd}\n    when.contains:\n      processor.event: error\n  - index: apm-%{\[beat.version\]}-transaction-%{\+yyyy.MM.dd}\n    when.contains:\n      processor.event: transaction\n  - index: apm-%{\[beat.version\]}-span-%{\+yyyy.MM.dd}\n    when.contains:\n      processor.event: span\n  - index: apm-%{\[beat.version\]}-metric-%{\+yyyy.MM.dd}\n    when.contains:\n      processor.event: metric\n  - index: apm-%{\[beat.version\]}-onboarding-%{\+yyyy.MM.dd}\n    when.contains:\n      processor.event: onboarding\n  enabled: true\n}, # rubocop:disable LineLength
            )
        }
      end
      context 'Do not merge with default configuration' do
        let(:merge_default_config) { false }

        it {
          is_expected.to contain_file("#{package_config_path}/apm-server.yml")
            .with(
              'content' => %r{---\napm-server:\n  host: 10.1.1.1:8200\noutput.elasticsearch:\n  hosts:\n  - 192.168.1.1:9200\n  - 192.168.1.2:9200\n  enabled: true\n},
            )
        }
      end
      context 'No custom configuration' do
        let(:apmserver_config_custom) { {} }

        it {
          is_expected.to contain_file("#{package_config_path}/apm-server.yml")
            .with(
              'content' => %r{---\napm-server:\n  host: localhost:8200\noutput.elasticsearch:\n  hosts:\n  - localhost:9200\n  indices:\n  - index: apm-%{\[beat.version\]}-sourcemap\n    when.contains:\n      processor.event: sourcemap\n  - index: apm-%{\[beat.version\]}-error-%{\+yyyy.MM.dd}\n    when.contains:\n      processor.event: error\n  - index: apm-%{\[beat.version\]}-transaction-%{\+yyyy.MM.dd}\n    when.contains:\n      processor.event: transaction\n  - index: apm-%{\[beat.version\]}-span-%{\+yyyy.MM.dd}\n    when.contains:\n      processor.event: span\n  - index: apm-%{\[beat.version\]}-metric-%{\+yyyy.MM.dd}\n    when.contains:\n      processor.event: metric\n  - index: apm-%{\[beat.version\]}-onboarding-%{\+yyyy.MM.dd}\n    when.contains:\n      processor.event: onboarding\n}, # rubocop:disable LineLength
            )
        }
      end
    end
  end
end
