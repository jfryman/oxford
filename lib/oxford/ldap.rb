module Oxford
  require 'active_ldap'

  class Host < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'cn', :prefix => 'ou=Hosts',
                 :classes => ['top', 'device', 'facterHost']
    #belongs_to :groups, :class_name => 'WebsagesLDAP::Group', :many => 'memberUid'

    def networks(search = {})
      Network.all(:prefix => "cn=#{self.commonName},ou=Hosts")
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

  class Network < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'cn', :prefix => "",
                 :classes => ['top', 'device', 'facterNetwork']
  end

  class Processor < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'cn', :prefix => "",
                 :classes => ['top', 'device', 'facterProcessor']
  end

  class LDAPAdapter
    require 'active_ldap'
    require 'yaml'
    def initialize
      load_config
      setup_connection
    end

    def load_config
      config = YAML.load_file("config/database.yaml")
      config['ldap'].each { |key, value| instance_variable_set "@#{key}", value }
    end

    def setup_connection
      ActiveLdap::Base.setup_connection(
        :host     => @host,
        :port     => @port,
        :base     => @base,
        :method   => @method,
        :bind_dn  => @user,
        :password => @pass
      )
    end

    def connected?
      begin
        ActiveLdap::Base.search(:base => @base, :filter => '(cn=admin)', :scope => :sub)
        return true
      rescue => e
        return false
      end
    end
  end
end
