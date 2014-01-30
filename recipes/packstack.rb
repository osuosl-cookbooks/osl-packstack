#
# Cookbook Name:: osl-packstack
# Recipe:: packstack
#
# Copyright 2013, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Setup the epel repo
case node['platform']
when "centos"
  include_recipe "yum-epel"
end

# Using these vars enhances readability
platfrm_vers = node['platform_version'].to_i
release_ver = node['osl-packstack']['rdo']['release'].downcase # Sanity check, and I'd like to start from an ensured lowercase

# Setup the rdo repo
case node['platform']
when "centos"
  yum_repository "openstack-#{release_ver}" do
    description "Openstack #{release_ver.capitalize} repo." # Make first letter capital
    baseurl "http://repos.fedorapeople.org/repos/openstack/openstack-#{release_ver}/epel-#{platfrm_vers}/"
    # RDO repo gpg key
    case release_ver
    when "grizzly"
      gpgkey "https://raw.github.com/redhat-openstack/rdo-release/grizzly/RPM-GPG-KEY-RDO-Grizzly"
    when "havana"
      gpgkey "https://raw.github.com/redhat-openstack/rdo-release/master/RPM-GPG-KEY-RDO-Havana"
    end
    action :create
  end
end

#Install packstack and related packages
%w{openstack-packstack openstack-utils}.each do |pkg|
  package pkg do
    action :install
  end
end

# Setup packstack ssh key for packstack puppet cms
directory "/root/.ssh" do
  owner "root"
  group "root"
  action :create
end


case node['osl-packstack']['type']
when "compute"
  include_recipe "osl-packstack::compute"
else
end


## Setup root private ssh key
ssh_key = Chef::EncryptedDataBagItem.load("ssh-keys", "packstack-root")

template "/root/.ssh/id_rsa" do
  variables(:key => ssh_key['id_rsa'])
  owner "root"
  mode "600"
  source "id_rsa.erb"
end

template "/root/.ssh/id_rsa.pub" do
  variables(:pub_key => ssh_key['id_rsa.pub'])
  owner "root"
  mode "644"
  source "id_rsapub.erb"
end

## TODO: Convert this ssh private key into a more dynamic cookbook
