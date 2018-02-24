require 'dotenv/load'
require 'twitter'

module TwitterWrapper
  class Wrapper
    def initialize
      @client = load_client
    end

    def follow_creators_of_tweets_containing(text, limit = 80)
      terms = load_terms(text)

      limit_per_term = limit / terms.count

      terms.each do |term|
        tweets = gather_tweets_containing(term)
        max_tweets = tweets[0..limit_per_term]
        follow_users_from(max_tweets)
      end
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

    def follow_users_from(nodes)
      users = nodes.map(&:user)

      @client.follow!(users)
    end

    def gather_tweets_containing(content)
      @client.search("#{str} -rt", lang: "en").to_a
    end

    def load_client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_TOKEN']
        config.access_token_secret = ENV['TWITTER_SECRET']
      end
    end
  end
end
