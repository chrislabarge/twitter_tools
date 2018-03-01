require 'dotenv/load'
require 'sinatra'
require 'base64'
require 'json'
require_relative 'lib/twitter_wrapper'

get '/' do
  'something'
end

post '/tweets/new' do
  return unless (content = incoming_content(request))

  begin
    # puts 'now hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
    wrapper = TwitterWrapper::Wrapper.new
    response = wrapper.tweet(content)
    status 200
    body response
  rescue Exception => e
    status 500
    body e.to_s + "\n"
  end
end

def incoming_content(request)
  request.body.rewind

  request_content = request.body.read
  payload = JSON.parse request_content
  token = get_token(payload)

  return unless authenticate(token)

  get_content(payload)
  #I shouldnt be rescuing the exception, I should be rescuing the StandardError
rescue Exception => e
  status 400
  body e.to_s + "\n"
  nil
end

def get_content(hash)
  hash["content"] || raise('Provide "content" key with value to tweet')
  sdfsdf
end

def get_token(hash)
  hash["token"] || raise('Provide "token" key with value to authenticate')
end

def authenticate(token)
  return true if token == ENV['WEBHOOK_TOKEN']

  status 403
  body "Invalid Credientials\n"
  false
end
