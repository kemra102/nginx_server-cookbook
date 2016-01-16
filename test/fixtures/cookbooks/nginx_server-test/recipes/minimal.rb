include_recipe 'nginx_server::default'

nginx_server_vhost 'minimal config' do
  server_name 'www.example.org'
end
