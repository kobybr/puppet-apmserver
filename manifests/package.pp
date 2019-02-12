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
  String $version      = $apmserver::_package_version,
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

  $install_options = $::osfamily ? {
    'Debian' => undef,
    default  => undef,
  }

  $_file_ensure = $ensure ? {
    /(purged|absent)/ => $ensure,
    default  => 'file',
  }

  if ($manage_repo == true) {
    contain '::elastic_stack::repo'
    ensure_packages( $package_name, {
      ensure          => $_ensure,
      require         => Class[elastic_stack::repo],
      install_options => $install_options,
      before          => File["${config_path}/apm-server.yml.rpmnew"],
    } )
  } else {
    ensure_packages( $package_name, {
      ensure          => $_ensure,
      install_options => $install_options,
      before          => File["${config_path}/apm-server.yml.rpmnew"],
    } )
  }

  file { "${config_path}/apm-server.yml.rpmnew":
    ensure             => $_file_ensure,
    replace            => false,
    source             => "file://${config_path}/apm-server.yml",
    source_permissions => 'use_when_creating',
    subscribe          => Package[ $package_name ],
  }

}
