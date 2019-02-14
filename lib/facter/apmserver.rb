require 'facter'

Facter.add(:pkg_versions) do
  confine osfamily: 'RedHat'

  setcode do
    pkg_versions = {}
    pkg_versions[:apmserver] = Facter::Util::Resolution.exec('rpm -q --queryformat \'%{VERSION}-%{RELEASE}\n\' apm-server')
    pkg_versions unless pkg_versions.empty?
  end
end

Facter.add(:pkg_versions) do
  confine osfamily: 'Debian'

  setcode do
    pkg_versions = {}
    pkg_versions[:apmserver] = Facter::Util::Resolution.exec('/usr/bin/dpkg-query --showformat=\'${Version}\n\' --show apm-server')
    pkg_versions unless pkg_versions.empty?
  end
end
