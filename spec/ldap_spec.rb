describe Oxford::LDAPAdapter do
  it 'should connect to LDAP server from a config file' do
    @ldap = Oxford::LDAPAdapter.new
    @ldap.connected?.should == true
  end

  it 'should connect to LDAP over ssl' do
    Oxford::Runner.config = File.join(File.dirname(__FILE__),'/fixtures/ssl.yaml')
    @ldap = Oxford::LDAPAdapter.new
    @ldap.connected?.should == true
  end

  it 'should connec to LDAP over plain' do
    Oxford::Runner.config = File.join(File.dirname(__FILE__),'/fixtures/nossl.yaml')
    @ldap = Oxford::LDAPAdapter.new
    @ldap.connected?.should == true
  end
end
