require 'dotenv'
require 'twitter'

Dotenv.load

class TweetFinder

  def initialize
    @twitter_client = initialize_twitter_client
    @results = []
    @tweets_found = false
  end

  attr_reader :results, :tweets_found

  def search(search_param, sample_size)
    tweets = @twitter_client.search(search_param, lang: 'en', locale: 'en').take(sample_size.to_i)

    @results = tweets.map do |tweet|
      {
        text: tweet.text
      }
    end

    @tweets_found = true unless @results.empty?
  end

  private

  def initialize_twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET_KEY']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET_TOKEN']
    end
  end
end
