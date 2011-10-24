describe Oxford do
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

  describe Oxford::Runner do
    it 'should get the facts from the system using the available fact engines'
    it 'should load the configs and initiate adapters'
    it 'should validate the current facts through the adapters'
    it 'should write the updated facts to the adapters'
  end
end
