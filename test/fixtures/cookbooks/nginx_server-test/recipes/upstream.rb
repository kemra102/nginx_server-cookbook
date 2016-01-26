include_recipe 'nginx_server::default'

nginx_server_upstream 'simple upstream' do
  upstream_name 'simple'
  servers [
    ['127.0.0.1:8080']
  ]
end

nginx_server_upstream 'load balancer' do
  upstream_name 'webservers'
  servers [
    ['192.168.0.100', 'max_fails=3', 'fail_timeout=30s'],
    ['192.168.0.101', 'max_fails=3', 'fail_timeout=30s'],
    ['192.168.0.102', 'max_fails=3', 'fail_timeout=30s']
  ]
end

nginx_server_upstream 'all options' do
  upstream_name 'appservers'
  servers [
    ['192.168.1.100:8000', 'max_fails=3', 'fail_timeout=30s'],
    ['192.168.1.101:8000', 'max_fails=3', 'fail_timeout=30s'],
    ['192.168.1.102:8000', 'max_fails=3', 'fail_timeout=30s']
  ]
  ip_hash true
  keepalive 30
  ntlm true
  least_conn true
end