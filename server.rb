require 'dotenv/load'
require 'sinatra'
require 'base64'
require 'json'

get '/' do
  'something'
end

post '/tweets/new' do
  request.body.rewind
  # puts request.inspect
  # puts request.body.read.inspect
  content =  request.body.read

  @request_payload = JSON.parse content

  puts "parsed: #{@request_payload}"

  status 200
end
