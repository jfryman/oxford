task :default  => [:spec]

desc "Run those tests"
task :spec do
  task :spec do
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new do |t|
      t.ruby_opts = ["-rrubygems"]
      t.rspec_opts = ["--tty","-c","-f documentation", "-r ./spec/spec_helper.rb"]
      t.pattern = 'spec/**/*_spec.rb'
    end
  end
end
