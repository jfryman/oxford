describe Oxford do
  describe Oxford::Facts do
    it 'should retrieve local facts from PuppetLabs facter' do
      Oxford::Facts.all.should be_a(Hash)
    end

    context "network" do
      it 'should retrieve network facts in a parsed format' do
        Oxford::Facts.network.should be_a(Hash)
        Oxford::Facts.network.should_not be_empty
      end

      it 'should retrieve network facts from os x' do
        Oxford::Facts.network.should include('en0')
      end
    end

    context "processor" do
      it 'should return processor facts in a parsed format' do
        Oxford::Facts.processor.should be_a(Hash)
        Oxford::Facts.processor.should_not be_empty
      end

      it 'should retrieve processor facts from os x' do
        Oxford::Facts.processor.should include('processor0')
      end
    end
  end

  describe Oxford::LDAPAdapter do
    it 'should connect to LDAP server from a config file'
    it 'should write facts to LDAP'
  end
end
