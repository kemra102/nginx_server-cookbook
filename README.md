# nginx_server Cookbook
[![Build Status](https://travis-ci.org/kemra102/nginx_server-cookbook.svg?branch=master)](https://travis-ci.org/kemra102/nginx_server-cookbook)

#### Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Attributes](#attributes)
4. [Usage](#usage)
    * [nginx_server_vhost](#nginx_server_vhost)
    * [nginx_server_upstream](#nginx_server_upstream)
5. [Contributing](#contributing)
6. [License & Authors](#license-and-authors)

## Overview

This module manages the installation and configuration of NGINX.

## Requirements

Requires Chef 12.5 or later as this cookbook makes use of [Custom Resources](https://www.chef.io/blog/2015/10/08/chef-client-12-5-released/).

## Attributes

### nginx_server::default
| Key                               | Type      | Description                                   | Default |
|:---------------------------------:|:---------:|:---------------------------------------------:|:-------:|
| `['nginx_server']['manage_repo']` | `Boolean` | If the cookbook should manage the NGINX repo. | `true`  |
| `['nginx_server']['repo']` | `String` | Which repo to install NGINX from. Only used when `['nginx_server']['manage_repo']` is `true`. Possible values are; `epel`, `nginx-stable` & `nginx-mainline`. | `nginx-stable`  |
| `['nginx_server']['manage_confd']` | `Boolean` | Whether or not we should *zap* `/etc/nginx/conf.d`. | `true`  |
| `['nginx_server']['error_log_level']` | `String` | [http://nginx.org/en/docs/ngx_core_module.html#error_log](http://nginx.org/en/docs/ngx_core_module.html#error_log) | `warn`  |
| `['nginx_server']['config']['worker_connections']` | `Integer` | [http://nginx.org/en/docs/ngx_core_module.html#worker_connections](http://nginx.org/en/docs/ngx_core_module.html#worker_connections) | `1024`  |
| `['nginx_server']['config']['log_format']` | `String` | [http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) | ```"\'$remote_addr - \$remote_user [\$time_local] \"\$request\" ' '\$status \$body_bytes_sent \"\$http_referer\" ' '\"\$http_user_agent\" \"\$http_x_forwarded_for\"'"``` |
| `['nginx_server']['config']['sendfile']` | `String` | [http://nginx.org/en/docs/http/ngx_http_core_module.html#sendfile](http://nginx.org/en/docs/http/ngx_http_core_module.html#sendfile) | `on`  |
| `['nginx_server']['config']['tcp_nopush']` | `String` | [http://nginx.org/en/docs/http/ngx_http_core_module.html#tcp_nopush](http://nginx.org/en/docs/http/ngx_http_core_module.html#tcp_nopush) | `off`  |
| `['nginx_server']['config']['keepalive_timeout']` | `Integer` | [http://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout](http://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout) | `65`  |
| `['nginx_server']['config']['gzip']` | `String` | [http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip) | `off`  |
| `['nginx_server']['config']['additional']` | `Hash` | Additional config to be applied to the main NGINX config. | `N/A` |

## Usage

You always need to include the main recipe:

```ruby
include_recipe 'nginx_server::default'
```

This recipe:

* Sets up the NGINX repo (**stable** repo by default).
* Installs the `nginx` package.
* Writes the main config to `/etc/nginx/nginx.conf`.
* *zaps* any files in `/etc/nginx/conf.d/` not managed by Chef.
* Enables & starts the `nginx` service.

### nginx_server_vhost

This resource defines a standard NGINX vhost.

Each `nginx_server_vhost` has the following attributes:

| Attribute     | Type                 | Description                                                                  | Default                 |
|:-------------:|:--------------------:|:----------------------------------------------------------------------------:|:-----------------------:|
| `name`        | `String` or `Symbol` | Resource name.                                                               | `N/A`                   |
| `listen`      | `Array`              | An array of hashes that describes the NGINX listen statements for the vhost. | `N/A`                   |
| `server_name` | `String` or `Array`  | Server name(s) that the vhost should respond to.                             | `N/A`                   |
| `root`        | `String`             | Web root of the vhost.                                                       | `/usr/share/nginx/html` |
| `index`       | `String`             | Index file for the website.                                                  | `index.html`            |
| `config`      | `Hash`               | Additional config options to pass to the vhost.                              | `N/A`                   |

To setup a basic vhost for example:

```ruby
nginx_server_vhost 'example.org' do
  server_name [
    'example.org',
    'www.example.org'
  ]
  root '/var/www/example.org'
  action :create
end
```

#### `listen`

The `listen` statement is an array of hashes that consists of:

* `ipaddress`
* `port`
* `options`

All parts of each hash are options and have sane defaults:

* `ipaddress` = `0.0.0.0`
* `port` = `80`
* `options` = `N/A`

For example to listen on the loopback address with SSL:

```ruby
listen [
  {
    'ipaddress': '127.0.0.1',
    'port': 443,
    'options': 'ssl'
  }
]
```

this produces a line like this:

```sh
listen 127.0.0.1:443 ssl;
```

For more examples see the cookbook's integration test cookbook.

#### `config`

The `config` is a hash of additional config for the vhost not provided by the other properties.

This supports nested config such as `location` statements as well, for example:

```ruby
config ({
    'error_page' => '404 /404.html',
    'location ~ \.php$' => {
      'try_files' => '$uri =404',
      'fastcgi_pass' => 'unix:/var/run/php5-fpm.sock',
      'fastcgi_index' => 'index.php',
      'fastcgi_param' => 'SCRIPT_FILENAME $document_root$fastcgi_script_name',
      'include' => 'fastcgi_params'
    }
  })
```

this is rendered as:

```sh
error_page 404 /404.html;
location ~ \.php$ {
  try_files $uri =404;
  fastcgi_pass unix:/var/run/php5-fpm.sock;
  fastcgi_index index.php;
  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  include fastcgi_params;
}
```

For more examples see the cookbook's integration test cookbook.

##### `fastcgi_param`

Because `config` is declared as a Ruby Hash you cannot declare multiple instances of `fastcgi_param` as each new declaration will override the previous.

In order to work around this you can specify multiple instances of `fastcgi_param` using `fastcgi_params`:

```ruby
config ({
  'location ~* \.php$' => {
    'fastcgi_pass' => 'unix:/var/run/php5-fpm.sock',
    'fastcgi_index' => 'index.php',
    'include' => 'fastcgi_params',
    'fastcgi_params' => [
      'SCRIPT_FILENAME $document_root$fastcgi_script_name',
      'SCRIPT_NAME $fastcgi_script_name',
      'SERVER_NAME $host'
    ]
  }
})
```

### nginx_server_upstream

The `nginx_server_upstream` defines an NGINX upstream to be used in tandem with a `nginx_server_vhost` that uses `proxy_pass` or similar to proxy connections to backend servers.

Each `nginx_server_upstream` has the following attributes:

| Attribute       | Type                 | Description                                                                                      | Default |
|:---------------:|:--------------------:|:------------------------------------------------------------------------------------------------:|:--------|
| `name`          | `String` or `Symbol` | Resource name.                                                                                   | `N/A`   |
| `upstream_name` | `String`             | Name of the upstream. Defaults to `name` if not set.                                             | `N/A`   |
| `servers`       | `Array`              | An Array of Arrays of backend servers that the upstream proxies to including associated options. | `N/A`   |
| `ip_hash`       | `Boolean`            | Whether or not to turn on the `ip_hash` functionality.                                           | `false` |
| `keepalive`     | `Integer`            | If set to an Integer turn on and set the `keepalive` functionality with the value supplied.      | `N/A`   |
| `least_conn`    | `Boolean`            | Whether or not to turn on the `least_conn` functionality.                                        | `false` |

To proxy through to a group of application servers for example:

```ruby
nginx_server_upstream 'appservers' do
  ip_hash true
  least_conn true
  servers [
    ['192.168.0.100:8080', 'max_fails=3', 'fail_timeout=30s'],
    ['192.168.0.101:8080', 'max_fails=3', 'fail_timeout=30s'],
    ['192.168.0.102:8080', 'max_fails=3', 'fail_timeout=30s']
  ]
  action :create
end
```

will render as:

```sh
upstream appservers {
  ip_hash;
  least_conn;

  server 192.168.0.100:8080 max_fails=3 fail_timeout=30s;
  server 192.168.0.101:8080 max_fails=3 fail_timeout=30s;
  server 192.168.0.102:8080 max_fails=3 fail_timeout=30s;
}
```

## Contributing

If you would like to contribute to this cookbook please follow these steps;

1. Fork the repository on Github.
2. Create a named feature branch (like `add_component_x`).
3. Write your change.
4. Write tests for your change (if applicable).
5. Write documentation for your change (if applicable).
6. Run the tests, ensuring they all pass.
7. Submit a Pull Request using GitHub.

## License and Authors

License: [BSD 2-clause](https://tldrlegal.com/license/bsd-2-clause-license-\(freebsd\)

Authors:

  * [Danny Roberts](https://github.com/kemra102)
  * [All Contributors](https://github.com/kemra102/yumserver-cookbook/graphs/contributors)
