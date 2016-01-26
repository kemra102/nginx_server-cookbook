property :name, [String, Symbol], required: true, name_property: true
property :upstream_name, String, required: false
property :servers, Array, required: true
property :ip_hash, [FalseClass, TrueClass], required: false, default: false
property :keepalive, Integer, required: false
property :least_conn, [FalseClass, TrueClass], required: false, default: false

default_action :create

def real_upstream_name
  upstream_name || name
end

def path
  "/etc/nginx/conf.d/#{name.tr(' ', '_')}.conf"
end

action :create do
  global_nginx = resources('service[nginx]')

  template path do
    cookbook 'nginx_server'
    source 'upstream.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      upstream_name: real_upstream_name,
      servers: servers,
      ip_hash: ip_hash,
      keepalive: keepalive,
      least_conn: least_conn
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
