module Oxford
  class Network < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'cn', :prefix => "",
                 :classes => ['top', 'device', 'facterNetwork']
  end
end
