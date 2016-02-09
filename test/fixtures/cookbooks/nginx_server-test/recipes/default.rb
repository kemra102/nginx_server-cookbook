include_recipe 'nginx_server::default'

nginx_server_vhost 'minimal config' do
  server_name 'www.example.org'
end

nginx_server_vhost 'kitchen sink' do
  server_name [
    'www.example.org',
    'example.org'
  ]
  listen [
    {
    },
    {
      'ipaddress' => '0.0.0.0',
      'port' => 81,
      'options' => 'spdy'
    },
    {
      'port' => 82,
      'options' => 'spdy'
    },
    {
      'ipaddress' => '0.0.0.0',
      'port' => 83,
      'options' => 'spdy'
    },
    {
      'port' => 443,
      'options' => [
        'ssl',
        'spdy'
      ]
    }
  ]
  config ({
    'error_page' => '404 /404.html',
    'location ~ \.php$' => {
      'try_files' => '$uri =404',
      'fastcgi_pass' => 'unix:/var/run/php5-fpm.sock',
      'fastcgi_index' => 'index.php',
      'fastcgi_param' => 'SCRIPT_FILENAME $document_root$fastcgi_script_name',
      'include' => 'fastcgi_params'
    }
  })
end

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
  least_conn true
end
