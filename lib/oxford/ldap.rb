module Oxford
  class LDAPAdapter
    def initialize
      load_config
      setup_connection
    end

    def load_config
      config = YAML.load_file(Oxford::Runner.config)
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
