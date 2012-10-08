require 'json'
require 'open-uri'
require 'active_support/core_ext/module/attribute_accessors'
require "currency_duo"

module RateMan

  @@_ran_once = false
  @@google_api_url = "https://www.googleapis.com/customsearch/v1"

  mattr_accessor :api_key, :google_api_url, :custom_search_id

  def self.proper_line(snippet)
    snippet.split('...').select { |l| RateMan.match(l.gsub(/^\s/,'').gsub(/\s$/,'')) }.first
  end

  def self.match(string)
    string =~ /\d EUR = \d*\.\d* CHF [-\+]?\d*\.\d* \([-\+]?\d*\.\d*\%\)/
  end

  def self.query_url(from_cur, to_cur)
    "#{@@google_api_url}?key=#{self.api_key}&cx=#{@@custom_search_id}&q=1%20#{from_cur}%20to%20#{to_cur}"
  end

  def self.setup
    yield self if @@_ran_once == false
    @@_ran_once = true
  end

  def self.cleanup
    @@_ran_once = false
    self.api_key = nil
    self.custom_search_id = nil
  end

  def self.raw_response(from_cur, to_cur)
    IO.read open(self.query_url(from_cur, to_cur))
  end

  def self.query(from_cur, to_cur)
    RateMan.proper_line(JSON.parse(RateMan.raw_response(from_cur, to_cur))['items'].first['snippet']).split(' ')
  end

  def self.get(from_cur, to_cur)
    RateMan::CurrencyDuo.new('EUR', 'CHF').query.json
  end

  class << self
    alias_method :rate, :get
  end

end
