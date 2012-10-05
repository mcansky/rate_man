require 'rubygems'
require 'rspec'
require 'rspec/autorun'

require 'vcr'

# code coverage
require 'simplecov'
SimpleCov.start do
  add_filter "bundler/"
  add_filter "spec/"
end

ENV["CUBS_ENV"] ||= 'test'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  c.hook_into                :webmock
  c.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |config|
  config.mock_with :rspec
    #
    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    #config.use_transactional_fixtures = false

  config.extend VCR::RSpec::Macros
end

