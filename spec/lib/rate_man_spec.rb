require 'spec_helper'
require './lib/rate_man'
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

describe RateMan do
  context "test config setup" do
    use_vcr_cassette
    subject { RateMan }
    before :each do
      RateMan.setup do |config|
        config.api_key = API_KEY
        config.custom_search_id = CUSTOM_SEARCH_ID
      end
    end

    its(:api_key) { should_not be_nil }
    its(:api_key) { should_not eq "" }
    its(:custom_search_id) { should_not be_nil }
    its(:custom_search_id) { should_not eq "" }
    its(:google_api_url) { should_not be_nil }
    it { should_not respond_to(:query).with(1).arguments }
    it { should_not respond_to(:query).with(3).arguments }
    it { should respond_to(:query).with(2).arguments }

    it { should_not respond_to(:query_url).with(1).arguments }
    it { should_not respond_to(:query_url).with(3).arguments }
    it { should respond_to(:query_url).with(2).arguments }

    it { should respond_to(:get).with(2).arguments }
    it { should_not respond_to(:get).with(1).arguments }
    it { should respond_to(:rate).with(2).arguments }

    it "should return a hash" do
      RateMan.query("EUR","CHF").class.should eq Array
    end
    it "should be able to build the query url" do
      query = "1 EUR to CHF"
      RateMan.query_url("EUR", "CHF").should eq "#{RateMan.google_api_url}?key=#{RateMan.api_key}&cx=#{RateMan.custom_search_id}&q=#{query.gsub(/\s/,"%20")}"
    end
    it "should be able to get a rate" do
      JSON.parse(subject.get('EUR','CHF')).keys.should eq ["from_to", "from_cur", "to_cur", "rate", "inv_rate"]
    end
  end

  describe "cleanup" do
    before :each do
      RateMan.setup do |config|
        config.api_key = API_KEY
        config.custom_search_id = CUSTOM_SEARCH_ID
      end
    end

    it "should be able to clean up" do
      RateMan.cleanup
      RateMan.api_key.should be_nil
      RateMan.custom_search_id.should be_nil
    end

  end

  context "req currency rate" do
    use_vcr_cassette

    before :each do
      RateMan.cleanup
      RateMan.setup do |config|
        config.api_key = API_KEY
        config.custom_search_id = CUSTOM_SEARCH_ID
      end
    end
    it "should get an answer from google" do
      open(RateMan.query_url('EUR', 'CHF')).class.should eq Tempfile
    end
    it "should get an answer from google" do
      items = JSON.parse(RateMan.raw_response('EUR', 'CHF'))['items']
      items.first['snippet'].split('...')[1].split(' ').class.should eq Array
      result = items.first['snippet'].split('...')[1].gsub(/^\s/,'').gsub(/\s$/,'')
      result.should match /\d EUR = \d*\.\d* CHF [-\+]?\d*\.\d* \([-\+]?\d*\.\d*\%\)/
      # ["1", "EUR", "=", "1.2114", "CHF", "-0.00017", "(-0.014%)"]
    end
    it "should get a json" do
      JSON.parse(IO.read open(RateMan.query_url('EUR', 'CHF'))).class.should eq Hash
    end
    it "should have a snippet for the first item" do
      JSON.parse(IO.read open(RateMan.query_url('EUR', 'CHF')))['items'].first['snippet'].should_not be_nil
    end
  end
end
