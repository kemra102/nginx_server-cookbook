property :name, [String, Symbol], required: true, name_property: true
property :listen, [Fixnum, Array], required: true, default: 80
property :server_name, [String, Array], required: false
property :root, String, required: true, default: '/usr/share/nginx/html'
property :index, String, required: true, default: 'index.html'
property :config, Hash, required: false

def real_server_name
  server_name || name
end

def path
  "/etc/nginx/conf.d/#{name.tr(' ', '_')}.conf"
end

action :create do
  global_nginx = resources('service[nginx]')

  #template "/etc/nginx/conf.d/#{name.tr(' ', '_')}.conf" do
  template path do
    cookbook 'nginx_server'
    source 'server_block.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      listen: listen,
      server_name: real_server_name,
      root: root,
      index: index,
      config: config
    )
    notifies :reload, global_nginx, :delayed
  end
end

action :delete do
  global_nginx = resources('service[nginx]')

  template path do
    action :delete
    notifies :reload, global_nginx, :delayed
  end
end
