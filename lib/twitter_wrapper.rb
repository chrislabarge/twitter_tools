require 'twitter'

module TwitterWrapper
  class Wrapper
    def initialize
      @client = load_client
    end

    def tweet(text)
      tweet = @client.update(text)
      log_successful(tweet)
    end

    def retweet(term)
      tweet = find_tweet_to_retweet(term)

      @client.retweet(tweet)

      successful_retweet(tweet)
    end

    def find_tweet_to_retweet(term)
      tweets = @client.home_timeline
      tweet = tweets.find { |tweet| contains_keyword?(tweet, term) }
      tweet || raise(retweet_error(term))
    end

    def process_tweets_containing(text, method = nil, limit = 80)
      @original_count = resource_count(method)
      terms = load_terms(text)

      limit_per_term = limit / terms.count

      terms.each do |term|
        tweets = gather_tweets_containing(term)
        max_tweets = tweets[0..limit_per_term]

        send(method, max_tweets)
      end

      log_success(terms, method)
    end

    def load_terms(text)
      terms = []
      terms << text if text.is_a?(String)
      terms = text if text.is_a?(Array)
      terms
    end

    def test
      @client
    end

    def contains_keyword?(tweet, term)
      tweet.text.downcase.include?(term)
    end

    def gather_tweets_containing(content)
      @client.search("#{content} -rt", lang: 'en').to_a
    end

    def load_client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_TOKEN']
        config.access_token_secret = ENV['TWITTER_SECRET']
      end
    end

    def follow(tweets)
      follow_users_of(tweets)
    end

    def favorite(tweets)
      @client.favorite(tweets)
    end

    def follow_users_of(tweets)
      users = tweets.map(&:user)

      @client.follow(users)
    end

    def resource_count(method, options = {})
      case method
      when :follow
        @client.friend_ids.count
      when :favorite
        0
      end
    end

    def log_success(terms, method)
      count = resource_count(method) - @original_count
      puts 'Success!!'
      puts successful_log_msgs(count, terms)[method]
    end

    def log_successful(resource)
      msg = "Succcessfully created tweet: #{resource.id}"
      puts msg
      msg
    end

    def successful_retweet(tweet)
      msg = "Succcessfully retweeted: #{tweet.id}"
      puts msg
      msg
    end

    def successful_log_msgs(count, terms)
      {
        follow: "Started following #{count} new users who's recent tweets included one of the following search terms #{terms}",
        favorite: "Favorited #{count} new tweets that included one of the following terms #{terms}"
      }
    end

    def retweet_error(term)
      "Unable to find any recent tweets containing term: #{term}"
    end
  end
end
