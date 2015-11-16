name 'nginx_server'
maintainer 'Sky Betting & Gaming'
maintainer_email 'international-devops@skybettingandgaming.com'
license 'All rights reserved'
description 'Installs/Configures nginx.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

depends 'yum-epel', '>= 0.3.6'
depends 'yum-nginx'
depends 'zap', '>= 0.1.0'
