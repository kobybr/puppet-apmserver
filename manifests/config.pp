# Manage APM server configuration
#
# @summary Manage APM server configuration
#
# @example
#   include apmserver::config
class apmserver::config (
  Boolean $merge_default_config                   = $apmserver::merge_default_config,
  String $package_ensure                          = $apmserver::package_ensure,
  String $package_config_path                     = $apmserver::package_config_path,
  Hash $apmserver_config_custom                   = $apmserver::apmserver_config_custom,
  String $ori_ext                                 = $apmserver::_ori_ext,
  Optional[String] $apmserver_default_config_file = $apmserver::apmserver_default_config_file,
){

  $_file_ensure = $package_ensure ? {
    /(purged|absent)/ => $package_ensure,
    default  => 'file',
  }

  if $merge_default_config {
    $_apmserver_config_defaults = $apmserver_default_config_file ? {
      undef   => loadyaml("${package_config_path}/apm-server.yml.${ori_ext}"),
      default => loadyaml($apmserver_default_config_file),
    }
  } else {
    $_apmserver_config_defaults = {}
  }

  $apmserver_config_combined = deep_merge($_apmserver_config_defaults, $apmserver_config_custom).to_yaml

  file { "${package_config_path}/apm-server.yml":
    ensure  => $_file_ensure,
    content => $apmserver_config_combined,
    mode    => '0600',
  }

}
