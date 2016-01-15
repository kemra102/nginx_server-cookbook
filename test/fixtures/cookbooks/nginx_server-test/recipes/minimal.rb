include_recipe 'nginx_server::default'

nginx_server_block 'minimal config' do
  server_name 'www.example.org'
end
