module Oxford
  class LDAPAdapter
  end

  class Facts
    require 'facter'
    require 'puppet'

    def self.all
      Facter.to_hash
    end

    def self.network
      networks = Hash.new
      facts = self.all
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

    def self.processor
      facts = self.all
      case facts['operatingsystem']
      when 'CentOS'
        Facts::Linux.processor
      when 'Darwin'
        Facts::OSX.processor
      end
    end

    class Linux
      def self.processor
        processors = Hash.new
        Facts.all.each do |key, value|
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
      def self.processor
        facts = Facts.all
        {'processor0' =>
          { 'processorId' => 0,
            'processorInfo' => "#{facts['sp_cpu_type']} #{facts['sp_current_processor_speed']}"
          }
        }
      end
    end
  end
end
