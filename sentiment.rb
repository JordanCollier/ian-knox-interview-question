require 'optparse'

DEFAULT_SAMPLE_SIZE = 20

options = {
  sample_size: DEFAULT_SAMPLE_SIZE
}

OptionParser.new do |opts|
  opts.banner = "Usage: ruby sentiment.rb [options]"

  opts.on("-k", "--keyword KEYWORD", "Keyword for Twitter search") do |keyword|
    options[:keyword] = keyword
  end

  opts.on("-s", "--sample-size SIZE", "The number of tweets to sample") do |size|
    options[:sample_size] = size.to_i
  end

  opts.on("-v", "--verbose", "Run verbosely") do |verbose|
    options[:verbose] = verbose
  end
end.parse!

puts "Keyword: #{options[:keyword]}"
puts "Verbosity: #{options[:verbose] ? 'on' : 'off'}"
puts "Sample size: #{options[:sample_size]}"

puts "\nAnalyzed 0 Tweets"
puts "Positive: 0"
puts "Negative: 0"
puts "Neutral: 0"
