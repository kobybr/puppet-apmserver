# Top-level apmserver class which may manage installation of the Elastic APM server
# package, service , package repository, and other global options and parameters.
#
# @summary Install and manage Elastic's APM server
#
# @example Install and manage the apm-server with all default settings
#   include '::apmserver'
#
# @example To install and manage the apm-server with custom settings:
#   $apmserver_config_custom = {
#     'apm-server' => { 'host' => "${::ipaddress}:8200" },
#     'output.elasticsearch' => {
#       'hosts' => [ '192.168.1.1:9200', '192.168.1.2:9200' ],
#       'enabled' => true,
#     },
#   }
#
#   class {'::apmserver':
#     apmserver_config_custom => $apmserver_config_custom,
#   }
#
#  @example To install and manage the apm-server with a hiera YAML file:
#    ---
#    apmserver::custom_config:
#      apm-server:
#        host: 10.1.1.1:8200
#      output.elasticsearch:
#        hosts:
#        - 192.168.1.1:9200
#        - 192.168.1.2:9200
#        enabled: true
#
#    class {'::apmserver':
#      apmserver_config_custom => hiera_hash('apmserver::custom_config', {}),
#    }
#
# @param manage_repo
#   Enable repo management by enabling official Elastic repositories. Default: true
#
# @param repo_version
#   The version to be used with elastic_stack for setting repository version. Default: 7
#
# @param merge_default_config
#   Merge config settings from the apm-server.yml file provided in the rpm.  Default: true
#
# @package_ensure
#   Control if the managed package shall be present or absent
#
# @package_version
#   To set the specific version you want to install.  Default: latest
#
# @package_name
#   Name of the package to install.  Default: apm-server
#
# @package_config_path
#   Path to the directory in which to install configuration files.  Default: <OS dependent>
#
# @service_ensure
#   Whether the service should be running.  Default: running
#
# @service_enable
#   Whether the service should be enabled to start at boot.  Default: true
#
# @service_name
#   Name of service to manage.  Default: apm-server
#
# @apmserver_config_custom
#   Custom configuration settings.  Default: {}
#
# @apmserver_default_config_file
#   Full path to the packages default configuration file.  Default: undef
# 
# @config_owner
#   Parameter to set the owner of the configuration file
# 
# @config_group
#   Parameter to set the group of the configuration file
#
class apmserver (
  Boolean $manage_repo,
  Integer $repo_version,
  Boolean $merge_default_config,
  String $package_ensure,
  String $package_version,
  String $package_name,
  String $package_config_path,
  String $service_ensure,
  String $service_enable,
  String $service_name,
  Hash $apmserver_config_custom = {},
  Optional[String] $apmserver_default_config_file = undef,
  String $config_owner,
  String $config_group,
){

  if $::osfamily == 'RedHat' {
    if ($package_version =~ /.+-\d/ or $package_version in [ 'present', 'installed', 'latest', 'held' ]) {
      $_package_version = $package_version
    } else {
      $_package_version = "${package_version}-1"
    }
  } else {
    $_package_version = $package_version
  }

  $_ori_ext = $::osfamily ? {
    'Debian' => 'dpkg-dist',
    default  => 'rpmnew',
  }

  contain '::apmserver::package'
  contain '::apmserver::config'
  contain '::apmserver::service'

  Class['::apmserver::package']
  -> Class['::apmserver::config']
  -> Class['::apmserver::service']
}
