require 'lib/sc/group'
module WebsagesLDAP
  class Set < ActiveLdap::Base
    ldap_mapping :classes => ['top', 'groupOfUniqueNames'], :prefix => 'ou=Sets'
    has_many :members, :class_name => 'WebsagesLDAP::User', :wrap => 'memberUid'
    has_many :primary_members, :class_name => 'WebsagesLDAP::User', :foreign_key => 'gidNumber', :primary_key => 'gidNumber'
  end
end
