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
  it { should contain 'error_log /var/log/nginx/error.log warn;' }
  it { should contain 'worker_connections 1024;' }
  it { should contain 'log_format main \'$remote_addr - $remote_user [$time_local] "$request" \'' }
  it { should contain 'sendfile   on;' }
  it { should contain 'tcp_nopush off;' }
  it { should contain 'keepalive_timeout 65;' }
  it { should contain 'gzip off;' }
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

describe file('/etc/nginx/conf.d/my_fake_site.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  it { should contain 'listen 80;' }
  it { should contain 'root /usr/share/nginx/html;' }
  it { should contain 'index index.html;' }
  it { should contain 'server_name www.example.org;' }
end
