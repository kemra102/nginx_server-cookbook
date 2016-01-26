require 'serverspec'

set :backend, :exec

describe file('/etc/yum.repos.d/nginx-mainline.repo') do
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

describe file('/etc/nginx/conf.d/minimal_config.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  it { should contain 'root /usr/share/nginx/html;' }
  it { should contain 'index index.html;' }
  it { should contain 'server_name www.example.org;' }
end

describe file('/etc/nginx/conf.d/kitchen_sink.conf') do
  it { should contain 'listen 0.0.0.0:81 spdy;' }
  it { should contain 'listen *:82 spdy;' }
  it { should contain 'listen 0.0.0.0:83 spdy;' }
  it { should contain 'listen *:443 ssl spdy;' }
  it { should contain 'error_page 404 /404.html;' }
  it { should contain 'location ~ \.php$ {' }
  it { should contain 'try_files $uri =404;' }
  it { should contain 'fastcgi_pass unix:/var/run/php5-fpm.sock;' }
  it { should contain 'fastcgi_index index.php;' }
  it { should contain 'fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' }
  it { should contain 'include fastcgi_params;' }
end

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
  it { should contain 'least_conn;' }
end

describe port(80) do
  it { should be_listening }
end

describe port(81) do
  it { should be_listening }
end

describe port(82) do
  it { should be_listening }
end

describe port(83) do
  it { should be_listening }
end

describe port(443) do
  it { should be_listening }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end
