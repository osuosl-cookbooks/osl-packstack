require_relative 'spec_helper'
require 'chef/application'

describe 'osl-openstack::controller', controller: true do
  let(:runner) do
    ChefSpec::SoloRunner.new(REDHAT_OPTS) do |node|
      # Work around for base::ifconfig:47
      node.automatic['virtualization']['system']
    end
  end
  let(:node) { runner.node }
  cached(:chef_run) { runner.converge(described_recipe) }
  %w(
    identity_stubs
    image_stubs
    network_stubs
    compute_stubs
    block_storage_stubs
    dashboard_stubs
    telemetry_stubs
  ).each do |s|
    include_context s
  end
  %w(
    osl-apache::default
    firewall::openstack
    firewall::memcached
    firewall::vnc
    osl-openstack::default
    memcached
    osl-openstack::identity
    osl-openstack::image
    osl-openstack::network
    osl-openstack::compute_controller
    osl-openstack::block_storage_controller
    osl-openstack::telemetry
    osl-openstack::dashboard
  ).each do |r|
    it "includes cookbook #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
end