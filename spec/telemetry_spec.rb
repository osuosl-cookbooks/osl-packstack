require_relative 'spec_helper'
require 'chef/application'

describe 'osl-openstack::telemetry', telemetry: true do
  let(:runner) do
    ChefSpec::SoloRunner.new(REDHAT_OPTS) do |node|
      # Work around for base::ifconfig:47
      node.automatic['virtualization']['system']
    end
  end
  let(:node) { runner.node }
  cached(:chef_run) { runner.converge(described_recipe) }
  include_context 'common_stubs'
  include_context 'identity_stubs'
  include_context 'telemetry_stubs'
  %w(
    osl-openstack
    openstack-telemetry::api
    openstack-telemetry::agent-central
    openstack-telemetry::agent-notification
    openstack-telemetry::collector
    openstack-telemetry::identity_registration
  ).each do |r|
    it "includes cookbook #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
  describe '/etc/ceilometer/ceilometer.conf' do
    let(:file) { chef_run.template('/etc/ceilometer/ceilometer.conf') }
    [
      /^notifier_strategy = messagingv2$/,
      /^notification_driver = messaging$/
    ].each do |line|
      it do
        expect(chef_run).to render_config_file(file.name)
          .with_section_content('DEFAULT', line)
      end
    end
    it do
      expect(chef_run).to render_config_file(file.name)
        .with_section_content(
          'keystone_authtoken',
          %r{^auth_url = http://10.0.0.10:5000/v2.0$}
        )
    end
    it do
      expect(chef_run).to render_config_file(file.name)
        .with_section_content(
          'api',
          /^host = 0.0.0.0$/
        )
    end
    it do
      expect(chef_run).to render_config_file(file.name)
        .with_section_content(
          'dispatcher_gnocchi',
          %r{^url = http://10.0.0.10:8041$}
        )
    end
    it do
      expect(chef_run).to render_config_file(file.name)
        .with_section_content(
          'database',
          %r{^connection = mysql://ceilometer_x86:ceilometer-dbpass@10.0.0.10:\
3306/ceilometer_x86\?charset=utf8}
        )
    end
    memcached_servers = /^memcached_servers = 10.0.0.10:11211$/
    %w(DEFAULT keystone_authtoken).each do |s|
      it do
        expect(chef_run).to render_config_file(file.name)
          .with_section_content(s, memcached_servers)
      end
    end

    [
      /^rabbit_host = 10.0.0.10$/,
      /^rabbit_userid = guest$/,
      /^rabbit_password = mq-pass$/
    ].each do |line|
      it do
        expect(chef_run).to render_config_file(file.name)
          .with_section_content('oslo_messaging_rabbit', line)
      end
    end
  end
end
