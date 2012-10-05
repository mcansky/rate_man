# Rate man

a little gem to get currency exchange rates from google.

Yep it's using Travis : [![Build Status](https://travis-ci.org/mcansky/rate_man.png)](https://travis-ci.org/mcansky/rate_man)

## How to use

    require 'rubygems'
    require 'rate_man'

    RateMan.setup do |config|
      config.api_key = API_KEY
      config.custom_search_id = CUSTOM_SEARCH_ID
    end

    RateMan.get('EUR', 'CHF')


