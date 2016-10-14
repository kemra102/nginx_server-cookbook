#
# Cookbook Name:: nginx_server
# Recipe:: default
#
# Copyright 2016, Danny Roberts
#
# BSD-2-Clause
#
include_recipe 'nginx_server::_repo' if node['nginx_server']['manage_repo']

package 'nginx'

template '/etc/nginx/nginx.conf' do
  cookbook 'nginx_server'
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  verify 'nginx -t -c /etc/nginx/nginx.conf'
  notifies :reload, 'service[nginx]', :delayed
end

if node['nginx_server']['manage_confd'] # ~FC023
  zap_directory '/etc/nginx/conf.d' do
    klass [Chef::Resource::File, Chef::Resource::Template,
           Chef::Resource::Link, Chef::Resource::NginxServerVhost,
           Chef::Resource::NginxServerUpstream]
  end
end

service 'nginx' do
  action [:enable, :start]
  supports restart: true, reload: true, status: true
end
