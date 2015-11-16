#
# Cookbook Name:: nginx_server
# Recipe:: default
#
# Copyright 2015, Sky Betting & Gaming
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'nginx_server::_repo' if node['nginx_server']['manage_repo']

package 'nginx'

template '/etc/nginx/nginx.conf' do
  cookbook node['nginx_server']['config_cookbook']
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  verify 'nginx -t -c /etc/nginx/nginx.conf'
  notifies :restart, 'service[nginx]', :delayed
end

#zap_directory '/etc/nginx/conf.d' if node['nginx_server']['manage_confd']

service 'nginx' do
  action [:enable, :start]
  supports restart: true, reload: true, status: true
end
