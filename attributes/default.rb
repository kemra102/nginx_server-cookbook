# Repo related attributes.
# Should we manage the NGINX repo in Chef?
default['nginx_server']['manage_repo'] = true
# Which repo to use, available values;
#   - epel
#   - nginx-stable
#   - nginx-mainline
default['nginx_server']['repo'] = 'nginx-stable'

# Whether or not we should 'zap' /et/nginx/conf.d
default['nginx_server']['manage_confd'] = true

# Attributes for the main /etc/nginx/nginx.conf
# http://nginx.org/en/docs/ngx_core_module.html#error_log
default['nginx_server']['config']['error_log_level'] = 'warn'
# http://nginx.org/en/docs/ngx_core_module.html#worker_connections
default['nginx_server']['config']['worker_connections'] = 1024
# http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format
default['nginx_server']['config']['log_format'] =
  "\'$remote_addr - \$remote_user [\$time_local] \"\$request\" '
  '\$status \$body_bytes_sent \"\$http_referer\" '
  '\"\$http_user_agent\" \"\$http_x_forwarded_for\"'"
# http://nginx.org/en/docs/http/ngx_http_core_module.html#sendfile
default['nginx_server']['config']['sendfile'] = 'on'
# http://nginx.org/en/docs/http/ngx_http_core_module.html#tcp_nopush
default['nginx_server']['config']['tcp_nopush'] = 'off'
# http://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout
default['nginx_server']['config']['keepalive_timeout'] = 65
# http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip
default['nginx_server']['config']['gzip'] = 'off'
