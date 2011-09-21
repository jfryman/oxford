module Oxford
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
