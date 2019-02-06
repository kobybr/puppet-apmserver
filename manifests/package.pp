# Install APM server package
#
# @summary Install APM server package
#
# @example
#   include apmserver::package
#
class apmserver::package (
  Boolean $manage_repo = $apmserver::manage_repo,
  String $ensure       = $apmserver::package_ensure,
  String $version      = $apmserver::package_version,
  String $package_name = $apmserver::package_name,
  String $config_path  = $apmserver::package_config_path,
) {

  if $ensure == 'present' {
    $_ensure = $version
    $package_provider = undef
  } else {
    if ($::osfamily == 'Suse') {
      $_ensure = 'absent'
    } else {
      $_ensure = 'purged'
    }
  }

  if ($manage_repo == true) {
    contain '::elastic_stack::repo'
    ensure_packages( $package_name, {
      ensure => $_ensure,
      require => Class[elastic_stack::repo],
      before => File["${config_path}/apm-server.yml.${version}"]
    } )
  } else {
    ensure_packages( $package_name, {
      ensure => $_ensure,
      before => File["${config_path}/apm-server.yml.${version}"]
    } )
  }

  file { "${config_path}/apm-server.yml.${version}":
    ensure             => 'present',
    replace            => false,
    source             => "file://${config_path}/apm-server.yml",
    source_permissions => 'use_when_creating',
  }

}
