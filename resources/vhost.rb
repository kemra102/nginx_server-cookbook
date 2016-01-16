property :name, [String, Symbol], required: true, name_property: true
property :listen, Array, required: false
property :server_name, [String, Array], required: false
property :root, String, required: true, default: '/usr/share/nginx/html'
property :index, String, required: true, default: 'index.html'
property :config, Hash, required: false

default_action :create

def real_server_name
  server_name || name
end

def real_listen # rubocop:disable Metrics/MethodLength
  real_listen = []
  return real_listen if listen.nil?
  listen.each do |line|
    ipaddress = line['ipaddress'] || '*'
    port = line['port'] || 80
    if line['options'].is_a?(Array)
      options = line['options'].join(' ')
    else
      options = line['options'] || ''
    end
    real_listen << "listen #{ipaddress}:#{port} #{options};"
  end
  real_listen
end

def path
  "/etc/nginx/conf.d/#{name.tr(' ', '_')}.conf"
end

action :create do
  global_nginx = resources('service[nginx]')

  template path do
    cookbook 'nginx_server'
    source 'vhost.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      listen: real_listen,
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

  file path do
    action :delete
    notifies :reload, global_nginx, :delayed
  end
end
