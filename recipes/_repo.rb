case node['nginx_server']['repo']
when 'epel'
  include_recipe 'yum-epel::default'
when 'nginx'
  include_recipe 'yum-nginx::default'
else
  fail("#{node['nginx_server']['repo']} is not an allowed value for
    node['nginx_server']['repo'].")
end
