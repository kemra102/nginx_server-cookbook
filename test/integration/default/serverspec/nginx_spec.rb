require 'serverspec'

set :backend, :exec

describe file('/etc/yum.repos.d/nginx-stable.repo') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

describe package('nginx') do
  it { should be_installed }
end

describe file('/etc/nginx/nginx.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

describe file('/etc/nginx/conf.d/default.conf') do
  it { should_not exist }
end

describe file('/etc/nginx/conf.d/example_ssl.conf') do
  it { should_not exist }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end
