module Oxford
  require 'active_ldap'

  class Host < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'cn', :prefix => 'ou=Hosts', 
                 :classes => ['top', 'device', 'facterHost']
    belongs_to :groups, :class_name => 'WebsagesLDAP::Group', :many => 'memberUid'

    def network(search = {})
      Network.all(:prefix => "cn=#{self.commonName},ou=Hosts")
    end

    def processor(search = {})
      Processor.all(:prefix => "cn=#{self.commonName},ou=Hosts")
    end

    def add_network(network)
      n = Network.new(network)
      n.base = "cn=#{self.commonName},ou=Hosts"
      raise StandardError unless n.valid?
      n.save
    end

    def add_processor(processor)
      p = Processor.new(processor)
      p.base = "cn=#{self.commonName},ou=Hosts"
      raise StandardError unless p.valid?
      p.save
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

    def unpack(d, t = Hash.new)
      d.each do |k, v|
        t[k] = v[0]
      end
      return t
    end
  end
end
