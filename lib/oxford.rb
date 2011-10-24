module Oxford
  require 'active_ldap'
  require 'yaml'
  require File.join(File.dirname(__FILE__),"oxford/facts.rb")
  require File.join(File.dirname(__FILE__),"oxford/ldap.rb")
  require File.join(File.dirname(__FILE__),"oxford/host.rb")
  require File.join(File.dirname(__FILE__),"oxford/processor.rb")
  require File.join(File.dirname(__FILE__),"oxford/network.rb")
  require File.join(File.dirname(__FILE__),"oxford/runner.rb")
end
