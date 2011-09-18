module Oxford
  require 'facter'
  require 'puppet'

  class Facts
    def get_local_facts
      Facter.to_hash
    end

    def get_network_facts
      networks = Hash.new
      facts = get_local_facts
      facts['interfaces'].split(',').each do |interface|
        networks[interface] = {
          'interface'  => interface,
          'ipaddress'  => facts["ipaddress_#{interface}"],
          'macaddress' => facts["macaddress_#{interface}"],
          'network'    => facts["network_#{interface}"],
          'netmask'    => facts["netmask_#{interface}"]
        }
      end
      networks
    end

    def get_processor_facts
      processors = Hash.new
      facts = get_local_facts
      facts.each do |key, value|
        if key =~ /^processor\d{1,100}/
          processors[key] = {
            'processorId'   => key.gsub(/^processor+/, ''),
            'processorInfo' => value
          }
        end
      end
      processors
    end
  end
end