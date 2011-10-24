describe Oxford::Runner do
  before(:all) do
    @f = Oxford::Facts.new
    Oxford::LDAPAdapter.new
  end

  after(:all) do
    g = Oxford::Host.find(@f.hostname)
    g.networks.each { |n| n.delete }
    g.processors.each { |p| p.delete }
    g.delete
  end

  it 'should start with no hosts' do
    g = Oxford::Host.find(@f.hostname)
    g.count.should eql(0)
  end

  it 'should write the facts to the adapters' do
    Oxford::Runner.run!
    g = Oxford::Host.find(@f.hostname)
    g.should be_an(Oxford::Host)
  end

  it 'should take a config file' do
    Oxford::Runner.config = File.join(File.dirname(__FILE__),'/fixtures/ssl.yaml')
    lambda { Oxford::Runner.run! }.should_not raise_error
  end
end
