require 'dotenv/load'
require 'sinatra'
require 'base64'
require 'json'

get '/' do
  'something'
end

post '/account/activity' do
  puts request.body.rewind.inspect
  puts request.body.read.inspect
  status 200
end

get '/account/activity' do
  crc_token = params['crc_token']
  response = []

  response['response_token'] = "sha256=#{generate_crc_resonse(ENV['TWITTER_CONSUMER_SECRET'], crc_token)}"
  body response.to_json
  status 200
end

def generate_crc_resonse(consumer_secret, crc_token)
  hash = OpenSSL::HMAC.digest('sha256', consumer_secret, crc_token)
  Base64.encode64(hash).strip!
end

