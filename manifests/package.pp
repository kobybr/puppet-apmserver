# Install APM server package
#
# @summary Install APM server package
#
# @example
#   include apmserver::package
#
class apmserver::package (
  Boolean $manage_repo    = $apmserver::manage_repo,
  String $package_ensure  = $apmserver::package_ensure,
  String $package_version = $apmserver::_package_version,
  String $package_name    = $apmserver::package_name,
  String $config_path     = $apmserver::package_config_path,
  String $ori_ext         = $apmserver::_ori_ext,
) {

  if $package_ensure == 'present' {
    $_ensure = $package_version
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

  $_file_ensure = $package_ensure ? {
    /(purged|absent)/ => $package_ensure,
    default  => 'file',
  }

  if ($manage_repo == true) {
    contain '::elastic_stack::repo'
    ensure_packages( $package_name, {
      ensure          => $_ensure,
      require         => Class[elastic_stack::repo],
      install_options => $install_options,
      before          => File["${config_path}/apm-server.yml.${ori_ext}"],
    } )
  } else {
    ensure_packages( $package_name, {
      ensure          => $_ensure,
      install_options => $install_options,
      before          => File["${config_path}/apm-server.yml.${ori_ext}"],
    } )
  }

  file { "${config_path}/apm-server.yml.${ori_ext}":
    ensure             => $_file_ensure,
    replace            => false,
    source             => "file://${config_path}/apm-server.yml",
    source_permissions => 'use_when_creating',
    subscribe          => Package[ $package_name ],
  }

}
