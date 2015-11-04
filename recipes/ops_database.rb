#
# Cookbook Name:: osl-openstack
# Recipe:: ops_database
#
# Copyright (C) 2015 Oregon State University
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
# this is required because of the fedora deps. Will be fixed once its moved into
# a _common recipe.
include_recipe 'osl-openstack'
include_recipe 'openstack-ops-database::server'
include_recipe 'openstack-ops-database::openstack-db'
include_recipe 'openstack-ops-messaging::server'
include_recipe 'memcached'