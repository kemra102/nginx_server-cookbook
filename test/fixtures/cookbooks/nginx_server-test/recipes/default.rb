include_recipe 'nginx_server::default'

nginx_server_block 'my fake site' do
  server_name 'www.example.org'
end
