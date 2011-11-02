describe Oxford::Host do

  before(:all) do
    Oxford::LDAPAdapter.new
    @g = Oxford::Host.find('galactica')
  end
  
  context "host" do
    it 'should be able to tell me all known facts about a system' do
      @g.factFqdn.should eql('galactica.test.com')
    end

    it 'should be able to write a fact' do
      r = randomstring(10)
      @g.factOperatingSystem = r
      lambda { @g.save }.should_not raise_error
      f = Oxford::Host.find('galactica')
      f.factOperatingSystem.should eql(r)
    end

    it 'should gracefully handle an unknown fact' do
      lambda { @g.factBlah = 'foo' }.should raise_error
    end

    it 'should be able to create a new host' do
      r = randomstring(10)
      a = Oxford::Host.new(r)
      a.save
      b = Oxford::Host.find(r)
      b.should eql(a)
      a.delete
    end
  end

  context "networks" do
    it 'should be able to retrieve a list of network devices on a host in ldap' do
      @g.networks.should_not   be_nil
      @g.networks.should       be_an(Array)
      @g.networks.first.should be_an(Oxford::Network)
      @g.networks.should       have(2).items
    end

    it 'should be able to get information about an adapter from a host in ldap' do
      n = @g.networks('NetworkLo0')
      n.should have(1).item
      n.first.should  be_a(Oxford::Network)
    end

    it 'should be able to create a new network device' do
      r = "test_interface"
      v = { 'Interface'  => 'eth1',
            'IpAddress'  => '192.168.2.100',
            'MacAddress' => '22:22:22:22:22:22',
            'Network'    => '255.255.255.0',
      }
      before = @g.networks
      @g.add_network(r,v)
      after = @g.networks
      (after - before).should have(1).item
    end

    it 'should be able to delete a network device' do
      before = @g.networks
      @g.networks.each do |n|
        n.delete if n.cn == 'test_interface'
      end
      after = @g.networks
      (before - after).should have(1).item
    end
  end

  context "processor" do
    it 'should be able to list all processors on a host in ldap' do
      @g.processors.should_not be_nil
      @g.processors.should     be_an(Array)
      @g.processors.first.should be_an(Oxford::Processor)
    end

    it 'should be able to write a processor entry to a host in ldap' do
      r = "processor" + (0...2).collect { rand(9) }.to_s
      v = { "processorId" => "0", "processorInfo" => "some test stuff" }
      before = @g.processors
      @g.add_processor(r,v)
      after  = @g.processors
      (after - before).should have(1).item
    end

    it 'should be able to delete a processor device' do
      before = @g.processors
      @g.processors.first.delete
      after = @g.processors
      (before - after).should have(1).item
    end
  end
end
