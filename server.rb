require 'dotenv/load'
require 'sinatra'
require 'json'
require_relative 'lib/twitter_wrapper'

get '/' do
  'Running'
end

post '/tweets/new' do
  begin
    content = receive_content(request)
    body tweet(content)
    status 200
  rescue StandardError => e
    status tweet_error_status(content)
    body e.to_s + "\n"
  end
end

def receive_content(request)
  payload = receive_payload(request)
  token = get_token(payload)

  authenticate(token)
  get_content(payload)
end

def receive_payload(request)
  request_to_json(request)
rescue StandardError => e
  raise 'JSON format is invalid: ' + e.to_s
end

def request_to_json(request)
  request.body.rewind

  request_content = request.body.read

  JSON.parse request_content
end

def get_content(hash)
  hash["content"] || raise('Provide "content" key with value to tweet')
end

def get_token(hash)
  hash["token"] || raise('Provide "token" key with value to authenticate')
end

def authenticate(token)
  return unless token != ENV['WEBHOOK_TOKEN']

  status 403
  raise "Invalid Credientials\n"
end

def tweet(content)
  wrapper = TwitterWrapper::Wrapper.new
  wrapper.tweet(content)
end

def tweet_error_status(content)
  if response.status == 200
    content.nil? ? 400 : 500
  else
    response.status
  end
end
