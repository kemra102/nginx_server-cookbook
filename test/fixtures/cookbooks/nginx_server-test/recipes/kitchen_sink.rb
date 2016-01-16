include_recipe 'nginx_server::default'

nginx_server_vhost 'kitchen sink' do
  server_name 'www.example.org'
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
