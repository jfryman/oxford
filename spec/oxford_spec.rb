describe Oxford do
  def randomstring(length)
    o = [('a'..'z'), ('A'..'Z')].map{|i| i.to_a}.flatten
    return (0..length).map { o[rand(o.length)] }.join
  end

  describe Oxford::Facts do
    before(:all) do
      @f = Oxford::Facts.new
    end

    it 'should retrieve local facts from PuppetLabs facter' do
      @f.all.should be_a(Hash)
    end

    context "network" do
      it 'should retrieve network facts in a parsed format' do
        @f.networks.should be_a(Hash)
        @f.networks.should_not be_empty
      end

      it 'should retrieve network facts from os x' do
        @f.networks.should include('en0')
      end
    end

    context "processor" do
      it 'should return processor facts in a parsed format' do
        @f.processors.should be_a(Hash)
        @f.processors.should_not be_empty
      end

      it 'should retrieve processor facts from os x' do
        @f.processors.should include('processor0')
      end
    end
  end

  describe Oxford::LDAPAdapter do
    before(:all) do
      @ldap = Oxford::LDAPAdapter.new
    end
    it 'should connect to LDAP server from a config file' do
      @ldap.connected?.should == true
    end
  end

  describe Oxford::Host do

    before(:all) do
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
        pending("need to merge the arguments somehow")
        n = @g.networks(:cn => 'networkLo0')
        n.should_not be_nil
        p n
        n.should     be_a(Oxford::Network)
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

      it 'should be able to tell me everything about all network devices' do
        pending("don't know how to test for *everything*")
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

      it 'should be able to tell me all known facts about processors' do
        pending("don't know how to test for *everything*")
      end
    end
  end

  describe Oxford::Runner do
    it 'should get the facts from the system using the available fact engines'
    it 'should load the configs and initiate adapters'
    it 'should validate the current facts through the adapters'
    it 'should write the updated facts to the adapters'
  end
end
