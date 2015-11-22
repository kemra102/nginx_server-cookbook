default['nginx_server']['manage_repo'] = true
default['nginx_server']['repo'] = 'nginx-stable'
default['nginx_server']['config_cookbook'] = 'nginx_server'
default['nginx_server']['manage_confd'] = true

default['nginx_server']['config']['error_log_level'] = 'warn'
default['nginx_server']['config']['worker_connections'] = 1024
default['nginx_server']['config']['log_format'] =
  "\'$remote_addr - \$remote_user [\$time_local] \"\$request\" '
  '\$status \$body_bytes_sent \"\$http_referer\" '
  '\"\$http_user_agent\" \"\$http_x_forwarded_for\"'"
default['nginx_server']['config']['sendfile'] = 'on'
default['nginx_server']['config']['tcp_nopush'] = 'off'
default['nginx_server']['config']['keepalive_timeout'] = 65
default['nginx_server']['config']['gzip'] = 'off'
