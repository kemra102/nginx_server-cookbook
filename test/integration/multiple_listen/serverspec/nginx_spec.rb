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

describe file('/etc/nginx/conf.d/multiple_listen.conf') do
  it { should contain 'listen *:80 ;' }
  it { should contain 'listen 0.0.0.0:81 spdy;' }
  it { should contain 'listen *:82 spdy;' }
  it { should contain 'listen 0.0.0.0:83 spdy;' }
  it { should contain 'listen *:443 ssl spdy;' }
end
