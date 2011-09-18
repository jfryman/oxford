
module Oxford
  require 'lib/myldap'
  class Host < Myldap
    def initialize(host)
      super()
      @host = host
      initalize_host_object
    end

    def fact=(fact, value)
      begin
        if @ldap.__send__(fact) != value
          @ldap.__send__("#{fact}=", value)
          @ldap.save
        end
        true 
      rescue NoMethodError  # In the event the schema doesn't exist, fail gracefully
        nil
      end
    end

    def set_all_facts(values)
      values.each do |key,value|
        if @ldap.__send__(key) != value
          @ldap.__send__("#{key}=", value)
          @ldap.save
        end
      end
    end

    def fact(fact)
      @ldap.__send__(fact)
    end

    def get_all_facts
      facts = @ldap.attributes.delete_if {|key, value| !key.match(/^fact+/)}
    end

    def delete_host
      host = WebsagesLDAP::Host.find(@host)
      host.delete
    end

    def initalize_host_object
      begin 
        @ldap = WebsagesLDAP::Host.find(@host)
      rescue 
        @ldap = WebsagesLDAP::Host.new(@host)
        @ldap.save
      end
    end

    def list_processors
      processors = Array.new
      search = ActiveLdap::Base.search(
                  :base   => "cn=#{@host},ou=Hosts," + @base, 
                  :filter => '(cn=processor*)', 
                  :scope  => :sub
               )

      search.each do |x|
        processors << x[1]['cn'][0]
      end

      processors.sort
    end

    def get_processor_info(id)
      info = Hash.new
      search = ActiveLdap::Base.search(
                  :base       => "cn=#{@host}, ou=Hosts," + @base, 
                  :filter     => "(cn=processor#{id.to_s})",
                  :scope      => :sub, 
                  :attributes => ['factProcessorId', 'factProcessorInfo']
               )
      unpack(search[0][1])
    end

    def get_all_processor_info
      processors = Hash.new
      list_processors.each do |processor|
        processors.merge(processors[processor] = get_processor_info(processor.gsub(/processor/, '')))
      end
      processors
    end

    def list_network_devices
      networks = Array.new
      search = ActiveLdap::Base.search(
                  :base   => "cn=#{@host},ou=Hosts," + @base, 
                  :filter => '(cn=network*)', 
                  :scope  => :sub
               )

      search.each do |x|
        networks << x[1]['cn'][0].gsub(/network/, '').downcase
      end
    
      networks.sort
    end

    def create_processor(id)
      device = WebsagesLDAP::Processor.new('processor' + id.to_s)
      device.base = "cn=#{@host},ou=Hosts"
      device.save
    end

    def write_processor_info(id, values)
      create_processor(id) if list_processors.include?('processor' + id.to_s) == false
      return true if values == get_processor_info(id)

      device = WebsagesLDAP::Processor.find(
          :base   => "cn=#{@host},ou=Hosts," + @base,
          :filter => "(cn=processor#{id.to_s})",
          :scope  => :one
        )
      values.each do |key, value|
        device.__send__("#{key}=", value)
      end
      device.save
    end

    def delete_processor(id)
      device = WebsagesLDAP::Processor.find('processor' + id.to_s)
      device.base = "cn=#{@host},ou=Hosts"
      device.delete
    end

    def get_network_info(interface)
      info = Hash.new
      search = ActiveLdap::Base.search(
                  :base       => "cn=#{@host}, ou=Hosts," + @base, 
                  :filter     => "(cn=network#{interface.capitalize})",
                  :scope      => :sub, 
                  :attributes => ['factInterface', 'factIpAddress',
                                  'factMacAddress', 'factNetwork']
               )
      unpack(search[0][1])
    end

    def get_all_network_info
      networks = Hash.new
      list_network_devices.each do |network|
        networks.merge(networks[network] = get_network_info(network))
      end
      networks 
    end

    def create_network_device(interface)
      device = WebsagesLDAP::Network.new('network' + interface.capitalize)
      device.base = "cn=#{@host},ou=Hosts"
      device.save
    end

    def write_network_info(interface, values)
      create_network_device(interface) if list_network_devices.include?(interface) == false
      return true if values == get_network_info(interface)   
  
      device = WebsagesLDAP::Network.find(
          :base   => "cn=#{@host},ou=Hosts," + @base,
          :filter => "(cn=network#{interface.capitalize})",
          :scope  => :one
        )
      values.each do |key, value|
        device.__send__("#{key}=", value)
      end
      device.save
    end

    def delete_network_device(interface)
      device = WebsagesLDAP::Network.find('network' + interface.capitalize)
      device.base = "cn=#{@host},ou=Hosts"
      device.delete
    end
  end
end