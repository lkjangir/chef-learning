require 'spec_helper'

describe port(80) do
  it { should be_listening }
  it { should be_listening.with(tcp) }
end

describe port(8080) do
  it { should be_listening }
  it { should be_listening.with(tcp) }
end



