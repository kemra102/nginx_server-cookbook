unless node.platform_family == 'rhel' || node.platform_family == 'debian'
  Chef::Application.fatal!("Unsupported Linux distribution - #{node.platform}", 1)
end

case node['nginx_server']['repo']
when 'epel' && node.platform_family?('rhel')
  include_recipe 'yum-epel::default'
when 'nginx-stable'
  if node.platform_family?('rhel')
    include_recipe 'yum-nginx::default'
  else
    include_recipe 'apt-nginx::default'
  end
when 'nginx-mainline'
  if node.platform_family?('rhel')
    node.default['yum-nginx']['repos']['nginx-stable']['managed'] = false
    node.default['yum-nginx']['repos']['nginx-mainline']['managed'] = true
    include_recipe 'yum-nginx::default'
  else
    node.default['apt-nginx']['repos']['nginx-stable']['managed'] = false
    node.default['apt-nginx']['repos']['nginx-mainline']['managed'] = true
    include_recipe 'apt-nginx::default'
  end
else
  Chef::Application.fatal!("#{node['nginx_server']['repo']} is not an allowed
    value for node['nginx_server']['repo'].", 1)
end
