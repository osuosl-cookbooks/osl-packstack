require 'serverspec'

set :backend, :exec

describe yumrepo('RDO-icehouse') do
  it { should exist }
  it { should be_enabled }
end

describe file('/root/openrc') do
  its(:content) do
    should match(%r{
export OS_USERNAME=admin
export OS_PASSWORD=admin
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://127.0.0.1:5000/v2.0
export OS_REGION_NAME=RegionOne})
  end
end