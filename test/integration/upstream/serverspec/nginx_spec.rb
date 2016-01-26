require 'serverspec'

set :backend, :exec

describe file('/etc/nginx/conf.d/simple_upstream.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  it { should contain 'upstream simple {' }
  it { should contain 'server 127.0.0.1:8080 ;' }
end

describe file('/etc/nginx/conf.d/load_balancer.conf') do
  it { should contain 'upstream webservers {' }
  it { should contain 'server 192.168.0.100 max_fails=3 fail_timeout=30s;' }
  it { should contain 'server 192.168.0.101 max_fails=3 fail_timeout=30s;' }
  it { should contain 'server 192.168.0.102 max_fails=3 fail_timeout=30s;' }
end

describe file('/etc/nginx/conf.d/all_options.conf') do
  it { should contain 'upstream appservers {' }
  it { should contain 'server 192.168.1.100:8000 max_fails=3 fail_timeout=30s;' }
  it { should contain 'server 192.168.1.101:8000 max_fails=3 fail_timeout=30s;' }
  it { should contain 'server 192.168.1.102:8000 max_fails=3 fail_timeout=30s;' }
  it { should contain 'ip_hash;' }
  it { should contain 'keepalive 30;' }
  it { should contain 'ntlm;' }
  it { should contain 'least_conn;' }
end
