module WebsagesLDAP
  class Host < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'cn', :prefix => 'ou=Hosts', 
                 :classes => ['top', 'device', 'facterHost']
    belongs_to :groups, :class_name => 'WebsagesLDAP::Group', :many => 'memberUid'
  end
end
