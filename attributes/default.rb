# osl-openstack default attributes

default['osl-openstack']['databases'] = {
  'bare-metal' => 'ironic',
  'block-storage' => 'cinder',
  'compute' => 'nova',
  'compute_api' => 'nova_api',
  'dashboard' => 'horizon',
  'database' => 'trove',
  'identity' => 'keystone',
  'image' => 'glance',
  'network' => 'neutron',
  'object-storage' => 'swift',
  'orchestration' => 'heat',
  'telemetry' => 'ceilometer'
}
default['osl-openstack']['data_bags'] = %w(
  db_passwords
  secrets
  service_passwords
  user_passwords
)
default['osl-openstack']['database_suffix'] = nil
default['osl-openstack']['databag_prefix'] = nil
default['osl-openstack']['cinder']['iscsi_role'] = nil
default['osl-openstack']['cinder']['iscsi_ips'] = []
default['osl-openstack']['image']['glance_vol'] = nil
default['osl-openstack']['endpoint_hostname'] = nil
default['osl-openstack']['network_hostname'] = nil
default['osl-openstack']['db_hostname'] = nil
default['osl-openstack']['bind_service'] = node['ipaddress']
default['osl-openstack']['seperate_network_node'] = false
default['osl-openstack']['physical_interface_mappings'] = []
default['osl-openstack']['vxlan_interface'] = {
  'controller' => {
    'default' => 'eth0'
  },
  'compute' => {
    'default' => 'eth0'
  }
}
default['osl-openstack']['node_type'] = 'compute'
default['osl-openstack']['nova_ssl_dir'] = '/etc/nova/pki'
default['osl-openstack']['libvirt_guests'] = {
  'on_boot' => 'ignore',
  'on_shutdown' => 'shutdown',
  'parallel_shutdown' => '25'
}
default['osl-openstack']['novnc'] = {
  'use_ssl' => true,
  'cert_file' => 'novnc.pem',
  'key_file' => 'novnc.key'
}
default['osl-openstack']['openpower']['yum']['repo-key'] = 'http://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl'
default['osl-openstack']['openpower']['yum']['uri'] =
  'http://ftp.osuosl.org/pub/osl/repos/yum/openpower/centos-$releasever/$basearch'
