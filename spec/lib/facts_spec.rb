require 'lib/facts'

describe "Facts" do
  it 'should retrieve local facts via Facter' do
    interface = Facts.new
    facts = interface.get_local_facts
    facts.length.should > 0
    facts['fqdn'].should == %x[hostname].chomp
  end
end
