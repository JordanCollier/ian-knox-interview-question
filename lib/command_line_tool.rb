require 'CSV'

require_relative 'tweet_finder'
require_relative 'sentiment_tool'

class CommandLineTool

  def initialize(options)
    @options = options
    @tweet_finder = TweetFinder.new
    @dictionary = {}
    @errors = []
    @tweets = []
    @tweet_count = build_tweet_counter
  end

  attr_accessor :options
  attr_reader :errors, :tweets, :tweet_count
  attr_writer :tweets

  def run
    get_tweets

    if @errors.any?
      @errors.each { |error| puts error }
    else
      compute_sentiments
      discard_no_sentiment_tweets
      check_verbose
      print_results
    end
  end

  def get_tweets
    check_inputs
    unless errors.any?
      query_twitter
    end
  end

  def compute_sentiments
    build_sentiment_dictionary

    @tweets.each do |tweet|
      tool = SentimentTool.new(tweet[:text])
      tool.determine_sentiment(@dictionary)
      sentiment = tool.sentiment
      set_sentiment(tweet, sentiment) if sentiment
    end
  end

  private

  def check_inputs
    check_keyword
    check_sample_size
  end

  def build_sentiment_dictionary
    dict = {}
    CSV.foreach('./dictionary.csv') do |row|
      dict[row[0]] = row[1] if row[1] != 'neutral'
    end
    @dictionary = dict
  end

  def build_tweet_counter
    {
      positive: 0,
      negative: 0,
      neutral: 0
    }
  end

  def check_keyword
    if @options[:keyword] == ''
      @errors.push('Keyword cannot be blank')
    end
  end

  def check_sample_size
    unless /\A\d+\z/.match(@options[:sample_size])
      @errors.push('Sample size must be a positive number')
    end
  end

  def check_verbose
    if @options[:verbose]
      @tweets.each_with_index do |tweet, i|
        print_verbose(tweet, i)
      end
    end
  end

  def query_twitter
    begin
      @tweet_finder.search(@options[:keyword], @options[:sample_size])
      @tweets += @tweet_finder.results
    rescue Twitter::Error => e
      errors.push('Twitter Error: ' + e.to_s)
    end
  end

  def set_sentiment(tweet, quality)
    tweet[:sentiment] = quality
    @tweet_count[quality.to_sym] += 1
  end

  def discard_no_sentiment_tweets
    @tweets = @tweets.select { |tweet| tweet[:sentiment] }
  end

  def print_verbose(tweet, i)
    puts 'Tweet: ' + tweet[:text]
    puts 'Sentiment: ' + tweet[:sentiment]
    puts "\n"
    puts '------' unless i == @tweets.length - 1
    puts "\n"
  end

  def print_results
    puts "Keyword: #{@options[:keyword]}"
    puts "Verbosity: #{@options[:verbose] ? 'on' : 'off'}"
    puts "Sample size: #{@options[:sample_size]}"

    puts "\nAnalyzed #{@tweets.length} Tweets"
    puts "Positive: #{@tweet_count[:positive]}"
    puts "Negative: #{@tweet_count[:negative]}"
    puts "Neutral: #{@tweet_count[:neutral]}"
  end
end
