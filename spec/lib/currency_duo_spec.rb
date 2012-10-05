require 'spec_helper'
require './lib/currency_duo'
require 'json'
require 'open-uri'
require 'yaml'

if File.exist?('dev_config.yml')
  config = YAML.load(File.open 'dev_config.yml')
  API_KEY = config['api_key']
  CUSTOM_SEARCH_ID = config['custom_search_id']
else
  API_KEY = "toto_api"
  CUSTOM_SEARCH_ID = "toto_custom"
end

describe RateMan::CurrencyDuo do
  subject { RateMan::CurrencyDuo.new("EUR", "CHF" ) }
  before :each do
    RateMan.setup do |config|
      config.api_key = API_KEY
      config.custom_search_id = CUSTOM_SEARCH_ID
    end
  end

  context "initialize" do
    its(:from) { should eq "EUR" }
    its(:to) { should eq "CHF" }
    it { should_not respond_to(:query).with(1).argument }
    it { should respond_to(:raw) }
    it { should respond_to(:rate) }
  end

  context "find rate" do
    use_vcr_cassette

    it "should throw an error if now query to google has been made" do
      expect { subject.hash }.to raise_error ArgumentError
    end

    it "should be able to query" do
      subject.query
      subject.raw.should_not be_nil
    end

    it "should return a rate hash" do
      subject.query
      expect { subject.hash }.not_to raise_error ArgumentError
      subject.hash.class.should eq Hash
    end
    it "should return a json containing several keys" do
      subject.query
      JSON.parse(subject.json).keys.should eq ["from_to", "from_cur", "to_cur", "rate", "inv_rate"]
    end
  end
end

