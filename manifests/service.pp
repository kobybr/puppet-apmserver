# Manage APM server service
#
# @summary Manage APM server service
#
# @example
#   include apmserver::service
#
class apmserver::service (
  String $service_ensure = $apmserver::service_ensure,
  String $service_enable = $apmserver::service_enable,
  String $service_name = $apmserver::service_name,
) {

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }

}
