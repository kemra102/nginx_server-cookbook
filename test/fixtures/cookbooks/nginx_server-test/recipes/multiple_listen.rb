include_recipe 'nginx_server::default'

nginx_server_vhost 'multiple listen' do
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
end
