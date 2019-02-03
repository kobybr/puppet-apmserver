# Manage APM server configuration
#
# @summary Manage APM server configuration
#
# @example
#   include apmserver::config
class apmserver::config (
  Boolean $merge_default_config = $apmserver::merge_default_config,
  String $ensure = $apmserver::package_ensure,
  String $version = $apmserver::package_version,
  String $config_path = $apmserver::package_config_path,
  Hash $apmserver_config_custom = $apmserver::apmserver_config_custom,
){

  $_ensure = $ensure ? {
    'absent' => $ensure,
    default  => 'file',
  }

  if $merge_default_config {
    $apmserver_config_defaults = loadyaml("${config_path}/apm-server.yml.${version}")
  }

  $apmserver_config_combined = deep_merge($apmserver_config_defaults, $apmserver_config_custom).to_yaml

  file { "${config_path}/apm-server.yml":
    ensure  => $_ensure,
    content => $apmserver_config_combined,
    mode    => '0600',
  }

}
