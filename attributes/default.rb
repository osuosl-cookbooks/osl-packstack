# osl-openstack default attributes

default['osl-openstack']['databases'] = {
  'block-storage' => 'cinder',
  'compute' => 'nova',
  'dashboard' => 'horizon',
  'identity' => 'keystone',
  'image' => 'glance',
  'network' => 'neutron',
  'orchestration' => 'heat',
  'telemetry' => 'ceilometer'
}
default['osl-openstack']['data_bags'] = %w(
  db_passwords
  secrets
  service_passwords
  user_passwords)
default['osl-openstack']['database_suffix'] = nil
default['osl-openstack']['databag_prefix'] = nil
default['osl-openstack']['vnc_bind_interface']['controller'] = 'eth1'
default['osl-openstack']['vnc_bind_interface']['compute'] = 'br42'
default['osl-openstack']['cinder']['iscsi_role'] = nil
default['osl-openstack']['cinder']['iscsi_ips'] = []

# Include Fedora attribute fixes that aren't in upstream
case platform
when 'fedora'
  # openstack-* cookbook attributes
  default['openstack']['compute']['platform']['dbus_service'] = 'dbus'
  default['openstack']['db']['python_packages']['mysql'] = %w(MySQL-python)
end

case node['kernel']['machine']
when 'ppc64'
  default['modules']['modules'] = %w(kvm_hv)
  case platform
  when 'fedora'
    # osl-openstack cookbook attributes
    default['yum']['fedora']['exclude'] = 'kernel* libvirt qemu* ksm ' \
      'libcacard* perf* python-perf*'
    default['yum']['updates']['exclude'] = 'kernel* libvirt qemu* ksm ' \
      'libcacard* perf* python-perf*'
    default['osl-openstack']['openpower']['yum']['repo-key'] = 'http://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl'
    default['osl-openstack']['openpower']['yum']['uri'] =
      'http://ftp.osuosl.org/pub/osl/repos/yum/openpower/f$releasever/ppc64'
    default['osl-openstack']['openpower']['kernel_version'] =
      value_for_platform(
        'fedora' => {
          '~> 20.0' => '3.16.0-1.fc20.ppc64',
          '~> 21.0' => '3.19.5-200.fc21.ppc64'
        }
      )
  end
end
