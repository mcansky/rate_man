require 'rspec/core/rake_task'
#
desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/lib/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end
