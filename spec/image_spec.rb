require_relative 'spec_helper'

describe 'osl-openstack::image', image: true do
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
  include_context 'image_stubs'
  %w(
    osl-openstack
    firewall::openstack
    openstack-image::api
    openstack-image::registry
    openstack-image::identity_registration
    openstack-image::image_upload
  ).each do |r|
    it "includes cookbook #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
  %w(api registry).each do |f|
    describe "/etc/glance/glance-#{f}.conf" do
      let(:file) { chef_run.template("/etc/glance/glance-#{f}.conf") }

      [
        /^bind_host = 0.0.0.0$/,
        /^notifier_strategy = messagingv2$/,
        /^notification_driver = messaging$/,
        /^memcached_servers = 10.0.0.10:11211$/
      ].each do |line|
        it do
          expect(chef_run).to render_config_file(file.name)
            .with_section_content('DEFAULT', line)
        end
      end

      [
        /^memcached_servers = 10.0.0.10:11211$/,
        %r{^auth_url = http://10.0.0.10:5000/v2.0$}
      ].each do |line|
        it do
          expect(chef_run).to render_config_file(file.name)
            .with_section_content('keystone_authtoken', line)
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

      [
        %r{^connection = mysql://glance_x86:db-pass@10.0.0.10:3306/glance_x86\
\?charset=utf8$}
      ].each do |line|
        it do
          expect(chef_run).to render_config_file(file.name)
            .with_section_content('database', line)
        end
      end
    end
  end
  describe '/etc/glance/glance-api.conf' do
    let(:file) { chef_run.template('/etc/glance/glance-api.conf') }

    [
      /^registry_host = 10.0.0.10$/
    ].each do |line|
      it do
        expect(chef_run).to render_config_file(file.name)
          .with_section_content('DEFAULT', line)
      end
    end
  end
end
