describe "Facts" do
  before(:all) do
    @interface = Facts.new
  end
  it 'should retrieve local facts via Facter' do
    facts = @interface.get_local_facts
    facts.length.should > 0
    facts['hostname'].should == %x[hostname].chomp
  end

  # The next two tests suck - I just wanted to see output.
  # not sure how to give consistent values - need test framework
  # likewise, this only works on Linux hosts right now. Need AIX
  it 'should give me a hash with network info' do
    networks = @interface.get_network_facts 
    networks.should be_a(Hash)
  end
  it 'should give me a hash with processor info' do
    networks = @interface.get_processor_facts
    networks.should be_a(Hash)
  end
end
