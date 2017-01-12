name 'nginx_server'
maintainer 'Danny Roberts'
maintainer_email 'danny@thefallenphoenix.net'
license 'BSD-2-Clause'
description 'Installs/Configures nginx.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.2.0'

%w(centos oracle redhat scientific).each do |os|
  supports os, '>= 6.0'
end

source_url 'https://github.com/kemra102/nginx_server-cookbook' if
  respond_to?(:source_url)
issues_url 'https://github.com/kemra102/nginx_server-cookbook/issues' if
  respond_to?(:issues_url)

depends 'yum-epel', '>= 0.3.6'
depends 'yum-nginx'
depends 'zap', '>= 0.6.0'
depends 'apt-nginx'
