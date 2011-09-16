#!/usr/bin/env ruby

require 'rubygems'
require 'lib/facts'
require 'lib/myldap/host'

@facts = Facts.new
@host = Host.new(%x[hostname].chomp)

# Set facts provided by Facter.
@facts.get_local_facts.each do |fact, value|
  f = fact.gsub(/_/, '')
  response = @host.__send__('set_fact', "fact#{f}", value)
end

# Set Processor Info
@facts.get_processor_facts.each do |fact, value|
  @host.__send__('write_processor_info', fact.gsub(/processor/, '').to_i, value)
end

# Set Network Info
@facts.get_network_facts.each do |interface, values|
  data = Hash.new
  values.each { |k, v| data["fact#{k}"] = v }
  @host.__send__('write_network_info', interface, data)
end

# Add Last Updated time to Schema
# TODO: Tombstoning on old values
@host.__send__('set_fact', 'factLastUpdated', Time.now.to_i)
