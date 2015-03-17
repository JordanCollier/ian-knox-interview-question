class SentimentTool

  def initialize(text)
    @text = text
    @quality_count = build_counter
    @sentiment = 'neutral'
  end

  attr_accessor :text

  attr_reader :sentiment, :dictionary

  def determine_sentiment(dictionary)
    count_qualities(dictionary)
    if @quality_count[:positive] > @quality_count[:negative]
      @sentiment = 'positive'
    elsif @quality_count[:negative] > @quality_count[:positive]
      @sentiment = 'negative'
    elsif @quality_count[:positive] == 0 && @quality_count[:negative] == 0
      @sentiment = false
    end

  end

  private

  def build_counter
    {positive: 0, negative: 0}
  end

  def count_qualities(dictionary)
    words = @text.split(' ')
    words.each do |word|
      if dictionary.has_key?(word)
        compute_quality(dictionary[word])
      end
    end
  end

  def compute_quality(word)
    if word == 'positive'
      @quality_count[:positive] += 1
    else
      @quality_count[:negative] += 1
    end
  end
end
