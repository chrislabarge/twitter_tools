require 'dotenv/load'
require 'sinatra'
require 'base64'
require 'json'
require_relative 'lib/twitter_wrapper'

get '/' do
  'something'
end

post '/tweets/new' do
  request.body.rewind

  request_content = request.body.read
  payload = JSON.parse request_content
  content = payload["content"]

  puts "parsed: #{payload.inspect}"

  wrapper = TwitterWrapper::Wrapper.new
  # response = wrapper.tweet(content)

  status 200
  # body response
end
