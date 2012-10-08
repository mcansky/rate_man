require 'rspec/core/rake_task'
#
desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/lib/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end

desc "Build gem"
task :build_gem do
  `gem build rate_man.gemspec`
end

desc "Push gem"
task :push_gem do
  `gem push #{Dir.glob('*.gem').last}`
end
