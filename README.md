Elastic APM server
==================

[![Build Status](https://travis-ci.org/kobybr/puppet-apmserver.svg)](https://travis-ci.org/kobybr/puppet-apmserver)
[![Puppet Forge](https://img.shields.io/puppetforge/v/kobybr/puppet-apmserver.svg)](https://forge.puppetlabs.com/kobybr/puppet-apmserver)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/kobybr/puppet-apmserver.svg)](https://forge.puppetlabs.com/kobybr/puppet-apmserver)
[![Puppet Forge Score](https://img.shields.io/puppetforge/f/kobybr/puppet-apmserver.svg)](https://forge.puppetlabs.com/kobybr/puppet-apmserver/scores)

Usage
-----

To install and manage the apm-server with all default settings:
```puppet
include '::apmserver'
```

To install and manage the apm-server with custom settings:
```puppet
$apmserver_config_custom = {
  'apm-server' => { 'host' => "${::ipaddress}:8200" },
  'output.elasticsearch' => {
    'hosts' => [ '192.168.1.1:9200', '192.168.1.2:9200' ],
    'enabled' => true,
  },
}

class {'::apmserver':
  apmserver_config_custom => $apmserver_config_custom,
}
```

Example hiera YAML file:
```hiera_hash
---
apmserver::custom_config:
  apm-server:
    host: 10.1.1.1:8200
  output.elasticsearch:
    hosts:
    - 192.168.1.1:9200
    - 192.168.1.2:9200
    enabled: true
```
```puppet
class {'::apmserver':
  apmserver_config_custom => hiera_hash('apmserver::custom_config', {}),
}
```

Module Parameters
-----------------

###`manage_repo`

###`merge_default_config`

###`package_ensure`

###`package_version`

###`package_name`

###`package_config_path`

###`service_ensure`

###`service_enable`

###`service_name`

###`apmserver_config_custom`
