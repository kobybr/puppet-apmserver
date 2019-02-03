# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include apmserver
class apmserver (
  Boolean $manage_repo,
  String $package_ensure,
  String $package_version,
  String $package_name,
  String $package_config_path,
  String $service_ensure,
  String $service_enable,
  String $service_name,
  Boolean $merge_default_config,
  Hash $apmserver_config_custom = {},
){

  contain '::apmserver::package'
  contain '::apmserver::config'
  contain '::apmserver::service'

  Class['::apmserver::package']
  -> Class['::apmserver::config']
  -> Class['::apmserver::service']
}
