__Note: Please don't fork this repo to work on solutions.__

# Socialytics: The Next Big Thing

I'm excited to annouce the launch of Socialytics, a cutting-edge social media analytics firm. Our primary mission is to analyze Twitter data to assess consumer sentiment.

On behalf of our clients, we will search for tweets containing carefully chosen keywords and categorize them as "negative sentiment" or "positive sentiment". For instance, after the State of the Union address, the Whitehouse PR team will ask us to search Twitter for the keyword "Obama" and provide a breakdown of percentage positive vs. percentage negative.

Before we can embark on the entrepreneurial path, and even before we can debate which variety of rare Brazilian cherry should grace the interiors of our private jets, we need to develop Socialytics' core intellectual property: a Ruby[*](#other-languages) library which searches Twitter and summarizes sentiment.

# Part 1. The Requirements

For now, we will access the Ruby library from the command line. The beginnings of the library can be found in `sentiment.rb`. Here is an example usage.

```
ruby sentiment.rb --keyword 'Justin Bieber'

Keyword: Justin Bieber
Verbosity: off
Sample size: 20

Analyzed 0 Tweets
Positive: 0
Negative: 0
Neutral: 0
```

Sweet, it does nothing! Our customers will be disappointed unless you can bail us out by filling in the implementation.

### Supporting More Options

In addition to the `--keyword` option, we need to support two other options: `--verbose` and `--sample-size`.

##### The `--sample-size` Option
Our experts postulate that increasing the sample size will increase the accuracy of Socialytics' analysis. However, larger sample sizes imply more computation, which results in a bigger [AWS](http://en.wikipedia.org/wiki/Amazon_Web_Services) bill.

We've decided that customers won't get access to more accurate results unless they're willing to pay top dollar, so we need the ability to tune the sample size on a per customer basis.

By default the sample size is 20.

##### The `--verbose` Option
Occasionally, the Socialytics sales team will require insight into exactly how tweets are categorized: positive, negative or neutral. The `--verbose` flag should print the tweet and categorization to STDOUT. For example:

```
ruby sentiment.rb --keyword 'Justin Bieber' --verbose

Keyword: Justin Bieber
Verbosity: off
Sample size: 20

Tweet: @omfgcmbxo @skaijackson  I don't like Justin Bieber.
Sentiment: negative
------
Tweet: justin bieber is cute
Sentiment: positive

Analyzed 2 Tweets
Positive: 1
Negative: 1
Neutral: 0
```

# Part 2. Getting Started

### Accessing Twitter

You'll need a Twitter account to access Twitter's APIs.  Visit the Twitter [application management dashboard](https://apps.twitter.com/) to register a new Twitter app. Once your application is registered, you'll find access keys under the "Keys and Access Tokens" tab.

Check out the [Search API documentation](https://dev.twitter.com/rest/public/search) for details on searching for tweets by keyword.

##### Tips
- Why do the hard work when it's already been done? The [twitter gem](https://github.com/sferik/twitter) makes querying the API a breeze.
- As tempting as it might be to give us access to your Twitter feed via Twitter API credentials, __please don't do it__. Ensure that you don't commit sensitive API keys. One possible solution is to use [dotenv](https://github.com/bkeepers/dotenv#sinatra-or-plain-ol-ruby) to store keys safely in environment variables.

### Categorizing Tweets

Assessing the sentiment of a tweet can be a daunting challenge requiring sophisticated [NLP](http://en.wikipedia.org/wiki/Natural_language_processing). But let's keep it simple -- like really, really simple.

In the project directory, you'll find `dictionary.csv`, a lexicon containing 7000-ish categorized English words. Using the lexicon, our categorization algorithm is as follows:

- If a tweet contains more positive words than negative words, it is categorized as 'positive'.
- If a tweet contains more negative words than positive words, it is categorized as 'negative'.
- If a tweet contains an equal number of negative words and positive words, it is categorized as 'neutral'.
- If a tweet does not contain any words we can classify as positive or negative, discard it.

#### Tips
- Ruby has a handy [CSV library](http://ruby-doc.org/stdlib-1.9.2/libdoc/csv/rdoc/CSV.html) for parsing CSV files.

# Rules
Feel free break up the implementation into as many files or directories as you'd like. You may add whatever testing frameworks or development tools you prefer (though if you make any bold choices, you might want to explain them).

<a name="other-languages"></a>*A word about alternative languages:* Ruby is our favorite language, but you are welcome to toss out `sentiment.rb` and write the whole thing in JavaScript or Clojure or Haskell or whatever. Choose the language in which you're most effective.

# Some things to bear in mind

Here are some thoughts that might inform your architectural decisions.
- We're not always going to consume the result via STDOUT. Eventually, we might want to talk the to the Socialytics Ruby library from other Ruby code (e.g. a Rails app).
- Someday, we might need the flexibility to incorporate other social media sources.
- How are errors handled?
  - What happens when sample_size is 'zebras'?
  - Or when keywords aren't supplied?
  - Or when Twitter is down?
- Our dictionary is English, so we might want to ignore non-English tweets.

# Submission Guidelines

Submissions require two things:

1. Your implementation
2. Your reflections


### Your implementation
When you're finished, send us a gzip of the project via email (or upload it somewhere we can access it). Please don't open a pull-request or fork the project on github lest others see your work and copy you. You put in the effort, you deserve the credit!

### Your reflections
Before gzipping the project, please add some thoughtful words to `reflections.md`.

Tell us about your approach. What choices did you make and why? What, if anything, was difficult? What would you improve if you had more time? What design or architecture principles did you leverage? What recent book or blog post did you read that gave you the inspiration to try something new? What are the upsides of your choices? What are the downsides?

Give us some insight into your process.


__Good Luck!__
