require 'active_ldap'
require 'yaml'

class Myldap 
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
