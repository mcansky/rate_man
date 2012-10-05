Gem::Specification.new do |s|
  s.name        = 'rate_man'
  s.version     = '0.0.4'
  s.date        = '2012-05-10'
  s.summary     = "simple gem to get currency exchance rates from google"
  s.description = "simple gem to get currency exchance rates from google"
  s.authors     = ["Thomas Riboulet"]
  s.email       = 'riboulet@gmail.com'
  s.files       = ["lib/rate_man.rb", "lib/currency_duo.rb"]
  s.homepage    =
    'http://github.com/mcansky/rate_man'
  s.add_runtime_dependency 'active_support'
end
