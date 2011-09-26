# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
#require "facter-ldap/version"

Gem::Specification.new do |s|
  s.name        = "oxford"
  s.version     = '0.0.4'
  s.authors     = ["James Fryman", "Aziz Shamim"]
  s.email       = ["james@frymanet.com","azizshamim@gmail.com"]
  s.summary     = %q{}
  s.description = %q{}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "puppet", '>= 2.6.4'
  # need to check versions
  s.add_dependency "facter", ">= 1.5.8"
  s.add_dependency "activeldap", ">= 3.1.0"
  s.add_dependency "ruby-ldap", ">= 0.9.11"
  s.add_development_dependency "rspec", '~> 2.6.0'
  s.add_development_dependency "rake", '>= 0.8.7'
end
