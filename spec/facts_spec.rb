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

