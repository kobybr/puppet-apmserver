Elastic APM server
==================

[![Build Status](https://travis-ci.com/kobybr/puppet-apmserver.svg)](https://travis-ci.com/kobybr/puppet-apmserver)
[![Puppet Forge](https://img.shields.io/puppetforge/v/kobybr/apmserver.svg)](https://forge.puppetlabs.com/kobybr/apmserver)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/kobybr/apmserver.svg)](https://forge.puppetlabs.com/kobybr/apmserver)
[![Puppet Forge Score](https://img.shields.io/puppetforge/f/kobybr/apmserver.svg?style=flat)](https://forge.puppet.com/kobybr/apmserver/scores)
![Puppet Forge Endorsement](https://img.shields.io/puppetforge/e/kobybr/apmserver.svg?style=flat)
![GitHub last commit](https://img.shields.io/github/last-commit/kobybr/puppet-apmserver.svg?style=flat)

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

`manage_repo`
Enable repo management by enabling official Elastic repositories.

`repo_version`
The version to be used with elastic_stack for setting repository version.

`merge_default_config`
Merge config settings from the *apm-server.yml* file provided in the rpm.  Default: *true*

`package_ensure`
Control if the managed package shall be *present* or *absent*

`package_version`
To set the specific version you want to install (ex. 6.5.4).  Default: latest

`package_name`
Name of the package to install.  Default: apm-server

`package_config_path`
Path to the directory in which to install configuration files.  Default: '/etc/apm-server'

`service_ensure`
Whether the service should be running.  Default: *running*

`service_enable`
Whether the service should be enabled to start at boot.  Default: *true*

`service_name`
Name of service to manage.  Default: apm-server

`apmserver_config_custom`
Custom configuration settings.  Default: {}

`apmserver_default_config_file`
Full path to the packages default configuration file.  Default: undef
