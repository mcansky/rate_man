require File.expand_path("../lib/rate_man/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'rate_man'
  s.version     = RateMan::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Riboulet"]
  s.email       = ['riboulet@gmail.com']
  s.homepage    = "http://github.com/mcansky/rate_man"
  s.summary     = "simple gem to get currency echange rate from google"
  s.description = "gem to get currency rate exchange"

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "rate_man"

  # If you have other dependencies, add them here
  # s.add_dependency "another", "~> 1.2"
  s.add_runtime_dependency 'active_support'

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

end
