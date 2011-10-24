module Oxford
  class Processor < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'cn', :prefix => "",
                 :classes => ['top', 'device', 'facterProcessor']
  end
end
