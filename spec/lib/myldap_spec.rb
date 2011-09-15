describe 'LDAP' do
  it 'should connect to LDAP server' do
    ldap = Myldap.new
    ldap.connected?.should == true
  end
end
