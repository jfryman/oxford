module WebsagesLDAP
  class User < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'uid', :prefix => 'ou=People', 
                 :classes => ['top', 'account', 'posixAccount']
    belongs_to :groups, :class_name => 'CHSLDAP::Group', :many => 'memberUid'
  end
end
