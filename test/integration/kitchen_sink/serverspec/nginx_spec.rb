require 'serverspec'

set :backend, :exec

describe port(80) do
  it { should be_listening }
end

describe port(81) do
  it { should be_listening }
end

describe port(82) do
  it { should be_listening }
end

describe port(83) do
  it { should be_listening }
end

describe port(443) do
  it { should be_listening }
end

describe file('/etc/nginx/conf.d/kitchen_sink.conf') do
  it { should contain 'listen *:80 ;' }
  it { should contain 'listen 0.0.0.0:81 spdy;' }
  it { should contain 'listen *:82 spdy;' }
  it { should contain 'listen 0.0.0.0:83 spdy;' }
  it { should contain 'listen *:443 ssl spdy;' }
  it { should contain 'error_page 404 /404.html;' }
  it { should contain 'location ~ \.php$ {' }
  it { should contain 'try_files $uri =404;' }
  it { should contain 'fastcgi_pass unix:/var/run/php5-fpm.sock;' }
  it { should contain 'fastcgi_index index.php;' }
  it { should contain 'fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' } # rubocop:disable Metrics/LineLength
  it { should contain 'include fastcgi_params;' }
end
