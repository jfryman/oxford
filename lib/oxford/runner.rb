module Oxford
  class Runner
    class << self; attr_accessor :config,:debug end
    @config = File.join(File.dirname(__FILE__), '../../config/database.yaml')
    @debug = false

    def self.run!
      Oxford::LDAPAdapter.new

      # should run the fact retrievers
      @facts = Oxford::Facts.new
      @host = Oxford::Host.new(@facts.hostname)
      @host.save

      # Set facts provided by Facter.
      @facts.all.each do |fact, value|
        f = fact.gsub(/_/, '')
        if @host.respond_to?("fact#{f}")
          @host.__send__("fact#{f}=", value.to_s)
        else
          puts "fact #{f} not being recorded as there is no corresponding entry in the data store" if @debug
        end
      end

      # Set Processor Info
      @facts.processors.each do |fact, value|
        @host.add_processor(fact, value)
      end

      # Set Network Info
      @facts.networks.each do |interface, value|
        @host.add_network(interface, value)
      end

      @host.update!
    end
  end
end
