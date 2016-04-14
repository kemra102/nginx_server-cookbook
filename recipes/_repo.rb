case node['nginx_server']['repo']
when 'epel'
  include_recipe 'yum-epel::default'
when 'nginx-stable'
  include_recipe 'yum-nginx::default'
when 'nginx-mainline'
  node.default['yum-nginx']['repos']['nginx-stable']['managed'] = false
  node.default['yum-nginx']['repos']['nginx-mainline']['managed'] = true
  include_recipe 'yum-nginx::default'
else
  Chef::Application.fatal!("#{node['nginx_server']['repo']} is not an allowed
    value for node['nginx_server']['repo'].", 1)
end
