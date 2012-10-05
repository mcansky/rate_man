# Rate man

a little gem to get currency exchange rates from google.

    require 'rubygems'
    require 'rate_man'

    RateMan.setup do |config|
      config.api_key = API_KEY
      config.custom_search_id = CUSTOM_SEARCH_ID
    end

    RateMan::CurrencyDuo.new('EUR', 'CHF').query.json


