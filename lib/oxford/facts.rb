module Oxford
  class Facts
    require 'facter'
    attr_reader :all

    def method_missing(m, *args, &block)
      if @all.has_key?(m.to_s)
        @all[m.to_s]
      else
        raise NoMethodError
      end
    end

    def initialize
      @all = Facter.to_hash
    end

    def networks
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

    def processors
      case @all['operatingsystem']
      when 'CentOS', 'RedHat'
        Facts::Linux.processors(@all)
      when 'Darwin'
        Facts::OSX.processors(@all)
      end
    end

    class Linux
      def self.processors(facts)
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
      def self.processors(facts)
        {'processor0' =>
          { 'processorId' => "0",
            'processorInfo' => "#{facts['sp_cpu_type']} #{facts['sp_current_processor_speed']}"
          }
        }
      end
    end
  end
end
