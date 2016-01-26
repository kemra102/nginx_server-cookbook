name 'nginx_server'
maintainer 'Danny Roberts'
maintainer_email 'danny@thefallenphoenix.net'
license 'BSD-2-Clause'
description 'Installs/Configures nginx.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

depends 'yum-epel', '>= 0.3.6'
depends 'yum-nginx'
depends 'zap', '>= 0.6.0'
