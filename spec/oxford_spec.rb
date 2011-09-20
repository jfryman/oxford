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
        @f.network.should be_a(Hash)
        @f.network.should_not be_empty
      end

      it 'should retrieve network facts from os x' do
        @f.network.should include('en0')
      end
    end

    context "processor" do
      it 'should return processor facts in a parsed format' do
        @f.processor.should be_a(Hash)
        @f.processor.should_not be_empty
      end

      it 'should retrieve processor facts from os x' do
        @f.processor.should include('processor0')
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
    it 'should be able to tell me all known facts about a system' do
      g = Oxford::Host.find('galactica')
      g.factFqdn.should eql('galactica.test.com')
    end

    it 'should be able to write a fact' do
      r = randomstring(10)
      g = Oxford::Host.find('galactica')
      g.factOperatingSystem = r
      lambda { g.save }.should_not raise_error
      f = Oxford::Host.find('galactica')
      f.factOperatingSystem.should eql(r)
    end

    it 'should gracefully handle an unknown fact' do
      g = Oxford::Host.find('galactica')
      lambda { g.factBlah = 'foo' }.should raise_error
    end

    context "networks" do
      it 'should be able to retrieve a list of network devices on a host in ldap' do
        pending("find out how to do joins...")
        g = Oxford::Host.find('galactica')
      end
      it 'should be able to get information about an adapter from a host in ldap'
      it 'should be able to create a new network device' 
      it 'should be able to write a new network device entry' 
      it 'should be able to delete a network device' 
      it 'should be able to tell me everything about all network devices' 
    end

    context "processor" do
      it 'should be able to list all processors on galactica' 
      it 'should be able to list all processors on odin' 
      it 'should be able to get information on processor0 from galactica' 
      it 'should be able to get information on processor1 from odin' 
      it 'should be able to create a new network device' 
      it 'should be able to write a processor entry to galactica' 
      it 'should be able to delete a processor device' 
      it 'should be able to tell me all known facts about processors' 
    end
  end
end
