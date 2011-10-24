module Oxford
  class Host < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'cn', :prefix => 'ou=Hosts',
                 :classes => ['top', 'device', 'facterHost']
    #belongs_to :groups, :class_name => 'WebsagesLDAP::Group', :many => 'memberUid'
    #
    def self.find(host)
      begin
        super(host)
      rescue ActiveLdap::EntryNotFound
        return []
      end
    end

    def networks(name='*')
      Network.all(:prefix => "cn=#{self.commonName},ou=Hosts", :filter => "(cn=#{name})")
    end

    def processors(search = {})
      Processor.all(:prefix => "cn=#{self.commonName},ou=Hosts")
    end

    def add_network(name, value)
      begin
        a = Network.find(name, :prefix => "cn=#{self.commonName},ou=Hosts")
      rescue
        a = Network.new(name)
        a.base = "cn=#{self.commonName},ou=Hosts"
      end
      value.each { |fact, value| a.__send__("fact#{fact}=", value.to_s) }
      raise StandardError unless a.valid?
      a.save
    end

    def add_processor(name, value)
      begin
        a = Processor.find(name, :prefix => "cn=#{self.commonName},ou=Hosts")
      rescue
        a = Processor.new(name)
        a.base = "cn=#{self.commonName},ou=Hosts"
      end
      value.each { |fact, value| a.__send__("fact#{fact}=", value.to_s) }
      raise StandardError unless a.valid?
      a.save
    end

    def update!
      time = Time.now.to_i
      self.factLastUpdated = time.to_s
      self.save
    end
  end
end
