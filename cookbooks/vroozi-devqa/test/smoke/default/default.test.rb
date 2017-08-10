describe package('git') do
  it { should be_installed }
end

describe port(80) do
  it { should be_listening }
end

describe port(8080) do
  it { should be_listening }
end

Service "nginx"
  should be enabled
  should be running



