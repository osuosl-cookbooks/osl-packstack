name             'osl-openstack'
issues_url       'https://github.com/osuosl-cookbooks/osl-openstack/issues'
source_url       'https://github.com/osuosl-cookbooks/osl-openstack'
maintainer       'Oregon State University'
maintainer_email 'systems@osuosl.org'
license          'Apache-2.0'
chef_version     '>= 16.0'
description      'Installs/Configures osl-openstack'
version          '10.2.1'

depends 'apache2'
depends 'base'
depends 'certificate'
depends 'git'
depends 'ibm-power'
depends 'line'
depends 'memcached'
depends 'openstack-block-storage'
depends 'openstack-common', '~> 19.0'
depends 'openstack-compute'
depends 'openstack-dashboard'
depends 'openstack-identity'
depends 'openstack-image'
depends 'openstack-integration-test'
depends 'openstack-network'
depends 'openstack-ops-database'
depends 'openstack-ops-messaging'
depends 'openstack-orchestration'
depends 'openstack-telemetry'
depends 'openstackclient', '~> 19.0'
depends 'osl-apache'
depends 'osl-ceph'
depends 'osl-firewall'
depends 'osl-nrpe'
depends 'osl-repos'
depends 'selinux'
depends 'user'
depends 'yum-kernel-osuosl'
depends 'yum-qemu-ev'

supports 'centos', '~> 7.0'
