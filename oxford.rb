#!/usr/bin/env ruby

require 'rubygems'
require 'lib/oxford.rb'
require 'pp'

debug = false

Oxford::LDAPAdapter.new

# create or find the current host object for this system
@facts = Oxford::Facts.new
begin
  @host = Oxford::Host.find(@facts.hostname)
rescue ActiveLdap::EntryNotFound
  @host = Oxford::Host.new(@facts.hostname)
  @host.save
end

# Set facts provided by Facter.
@facts.all.each do |fact, value|
  f = fact.gsub(/_/, '')
  if @host.respond_to?("fact#{f}")
    @host.__send__("fact#{f}=", value.to_s)
  else
    puts "fact #{f} not being recorded as there is no corresponding entry in the data store" if debug
  end
end

# Set Processor Info
@facts.processors.each do |fact, value|
  @host.add_processor(fact, value)
end
#
# Set Network Info
@facts.networks.each do |interface, value|
  @host.add_network(interface, value)
end

@host.update!
