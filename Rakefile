require 'erb'
require 'bundler/gem_tasks'

task :default  => [:spec]

Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end

def remove_task(task_name)
  Rake.application.remove_task(task_name)
end

def records
# create the ldif for a server
  template = ERB.new(File.read('spec/fixtures/ldap.yaml'))
  namespace = OpenStruct.new(:hostname => 'galactica')
  YAML.load( template.result(namespace.send(:binding)) )
end


remove_task :release
desc "release package to the proper place"
task :release do
  server="repo.us.chs.net"
  destination="/opt/repo/chs/gems/"
  source=File.join(File.dirname(__FILE__),'pkg','oxford*')
  Dir.glob(source).each do |file|
    %x[/usr/bin/scp #{file} #{server}:#{destination}]
    if $?.exitstatus == 0
    	puts "#{file} released successfully"
    end
  end
end

task :environment do
  if File.exists?('/opt/puppet/bin/ruby')
    ENV['PATH'] = "/opt/puppet/bin/ruby:#{ENV['PATH']}"
  end
end

desc "Run those tests"
task :spec => [:environment] do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new do |t|
    t.ruby_opts = ["-rrubygems"]
    t.rspec_opts = ["--tty","-c","-f documentation", "-r ./spec/spec_helper.rb"]
    t.pattern = 'spec/**/*_spec.rb'
  end
end

namespace :ldap do
  require 'yaml'
  require 'ldap'

  task :populate do
    puts 'populating ldap with records...'

    conn = LDAP::Conn.new(host="localhost",port=3890)
    conn.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
    conn.simple_bind(dn='cn=admin,dc=test,dc=com',password='test') do |c|
      records.each do |r|
        puts 'record added...'
        mydn=r['dn'].first
        r.delete('dn')
        c.add(mydn,r)
      end
    end
  end

  task :clean do
    puts "cleaning out ldap"
    conn = LDAP::Conn.new(host="localhost",port=3890)
    conn.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
    conn.simple_bind(dn='cn=admin,dc=test,dc=com',password='test') do |c|
      c.search('cn=galactica,ou=Hosts,dc=test,dc=com',LDAP::LDAP_SCOPE_ONELEVEL,'(cn=*)') { |entry|
        c.delete(entry.dn)
      }
      c.search('dc=test,dc=com',LDAP::LDAP_SCOPE_SUBTREE,'(cn=galactica)') { |entry|
        c.delete(entry.dn)
      }
    end
  end
end


