name             'osl-openstack'
issues_url       'https://github.com/osuosl-cookbooks/osl-openstack/issues'
source_url       'https://github.com/osuosl-cookbooks/osl-openstack'
maintainer       'Oregon State University'
maintainer_email 'systems@osuosl.org'
license          'Apache-2.0'
chef_version     '>= 14.0'
description      'Installs/Configures osl-openstack'
version          '8.2.1'

depends 'apache2'
depends 'base'
depends 'certificate'
depends 'chef-sugar'
depends 'firewall', '>= 2.2.0'
depends 'git'
depends 'ibm-power'
depends 'line'
depends 'memcached'
depends 'openstackclient', '~> 18.1'
depends 'openstack-block-storage'
depends 'openstack-common', '~> 18.0'
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
depends 'osl-apache', '< 5.0.0'
depends 'osl-ceph'
depends 'osl-munin'
depends 'osl-nrpe'
depends 'selinux'
depends 'systemd'
depends 'user'
depends 'yum-centos'
depends 'yum-epel'
depends 'yum-kernel-osuosl'
depends 'yum-qemu-ev'

supports 'centos', '~> 7.0'
