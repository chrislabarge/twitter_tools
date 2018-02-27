require 'bundler/setup'
require 'sinatra'
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require_relative 'web_scraper'


Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara
end

class Liker
  def like_tweets_containing(term)
    scraper = WebScraper.new
    scraper.scrape('https://twitter.com', instructions(term))
  end

  def instructions(term)
    ->(session) {
      @page = session

      login
      like_tweets(term)
    }
  end

  def login
    @page.all('a', text: 'Log in').last.trigger('click')

    @page.fill_in 'session[username_or_email]', placeholder: 'Phone, email or username', with: ENV['TWITTER_USERNAME']
    @page.fill_in 'session[password]', placeholder: 'Password', class: 'js-password-field', with: ENV['TWITTER_PASSWORD']

    @page.all('button', text: 'Log in').last.trigger('click')

    sleep(2)
  end

  def like_tweets(term)
    @page.all('span', text: 'Like').each do |link|
      sleep(1)
      link.trigger('click')
    end
    sleep(1)

    # @page.fill_in 'search-query', with: term
    # @page.find('#search-query').native.send_keys(:return)

    # @page.find('#global-nav-search span.search-icon').trigger('click')

    # @page.find('button', class: 'nav-search').trigger('click')

    # sleep(3)


    # @page.click_link('Latest')

    # sleep(2)

    @page.save_screenshot('foo.png', full: true)
  end
end

