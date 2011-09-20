module Oxford
  require 'active_ldap'

  class Runner
    # should set up the adapters
    # should run the fact retrievers
    # should check the data models through the adapters
  end

  class Host < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'cn', :prefix => 'ou=Hosts', 
                 :classes => ['top', 'device', 'facterHost']
    belongs_to :groups, :class_name => 'WebsagesLDAP::Group', :many => 'memberUid'
  end

  class Network < ActiveLdap::Base
    ldap_mapping :dn_attribute => 'cn', :prefix => "", 
                 :classes => ['top', 'device', 'facterNetwork']
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

  class Facts
    require 'facter'
    require 'puppet'
    attr_reader :all

    def initialize
      @all = Facter.to_hash
    end

    def network
      networks = Hash.new
      @all['interfaces'].split(',').each do |interface|
        networks[interface] = {
          'interface'  => interface,
          'ipaddress'  => @all["ipaddress_#{interface}"],
          'macaddress' => @all["macaddress_#{interface}"],
          'network'    => @all["network_#{interface}"],
          'netmask'    => @all["netmask_#{interface}"]
        }
      end
      networks
    end

    def processor
      case @all['operatingsystem']
      when 'CentOS'
        Facts::Linux.processor(@all)
      when 'Darwin'
        Facts::OSX.processor(@all)
      end
    end

    class Linux
      def self.processor(facts)
        processors = Hash.new
        facts.each do |key, value|
          if key =~ /^processor\d{1,100}/
            processors[key] = {
              'processorId'   => key.gsub(/^processor/, ''),
              'processorInfo' => value
            }
          end
        end
        processors
      end
    end

    class OSX
      def self.processor(facts)
        {'processor0' =>
          { 'processorId' => 0,
            'processorInfo' => "#{facts['sp_cpu_type']} #{facts['sp_current_processor_speed']}"
          }
        }
      end
    end
  end
end
