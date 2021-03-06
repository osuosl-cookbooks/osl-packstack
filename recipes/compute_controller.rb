#
# Cookbook:: osl-openstack
# Recipe:: compute_controller
#
# Copyright:: 2016-2021, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe 'osl-openstack'

osl_firewall_openstack 'osl-openstack'

include_recipe 'openstack-compute::nova-setup'
include_recipe 'openstack-compute::conductor'
include_recipe 'openstack-compute::api-os-compute'
include_recipe 'openstack-compute::api-metadata'
include_recipe 'openstack-compute::placement_api'
include_recipe 'openstack-compute::vncproxy'
include_recipe 'openstack-compute::scheduler'
include_recipe 'openstack-compute::identity_registration'

delete_lines 'remove dhcpbridge on controller' do
  path '/usr/share/nova/nova-dist.conf'
  pattern '^dhcpbridge.*'
  backup true
  notifies :restart, 'service[apache2]'
  notifies :restart, 'service[openstack-nova-novncproxy]'
  notifies :restart, 'service[nova-consoleauth]'
  notifies :restart, 'service[nova-scheduler]'
end

delete_lines 'remove force_dhcp_release on controller' do
  path '/usr/share/nova/nova-dist.conf'
  pattern '^force_dhcp_release.*'
  backup true
  notifies :restart, 'service[apache2]'
  notifies :restart, 'service[openstack-nova-novncproxy]'
  notifies :restart, 'service[nova-consoleauth]'
  notifies :restart, 'service[nova-scheduler]'
end

platform_options = node['openstack']['compute']['platform']
proxy_service = "service[#{platform_options['compute_vncproxy_service']}]"
ssl_dir = node['osl-openstack']['nova_ssl_dir']
novnc = node['osl-openstack']['novnc']

directory '/etc/nova/pki'

certificate_manage 'novnc' do
  cert_path ssl_dir
  cert_file novnc['cert_file']
  key_file  novnc['key_file']
  chain_file 'novnc-bundle.crt'
  nginx_cert true
  owner node['openstack']['compute']['user']
  group node['openstack']['compute']['group']
  notifies :restart, proxy_service
end

template '/etc/sysconfig/openstack-nova-novncproxy' do
  source 'novncproxy.erb'
  mode '644'
  owner 'root'
  group 'root'
  variables(cert: ::File.join(ssl_dir, 'certs', novnc['cert_file']),
            key: ::File.join(ssl_dir, 'private', novnc['key_file']))
  notifies :restart, proxy_service
end

# TODO: Remove after rocky
# This is no longer needed
delete_resource(:execute, 'enable nova login')
