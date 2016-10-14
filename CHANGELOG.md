## 2016-10-14
### Summary
Small feature release

#### Bugfixes
- Reload instead of restart when updating the main config in order to avoid interruptions to service.

#### Features
- Can now add additional parameters to the main NGINX config.

## 2016-02-09
### Small bugfix release

#### Bugfixes
- `nginx_server_vhost` now correctly takes an Array of `server_name` values.

## 2016-01-26
### Summary
Initial release.

#### Features
- Optionally manage repo to install NGINX from.
- Install NGINX.
- Manage main configuration.
- Add vhost and upstream configuration via custom resources.
- *zap* config files not managed by Chef.
- Manage the NGINX service.
