ENV['RACK_ENV'] = 'test'

require_relative '../server'
require 'rspec'
require 'rack/test'

describe 'Application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'root path (/)' do
    it 'displays "OK" status message receiving a get request' do
      get '/'

      expect(last_response).to be_ok
      expect(last_response.body).to eq('Running')
    end
  end

  context 'new tweet path (/tweets/new)' do
    let(:auth_token) { 'some encrpyted token' }
    let(:json_headers) { { "Content-Type" => "application/json","Accept" => "application/json" } }
    let(:wrapper) { double(:api) }

    before(:each) do
      allow(ENV).to receive(:[]).with('WEBHOOK_TOKEN') { auth_token }
      allow(TwitterWrapper::Wrapper).to receive(:new) { wrapper }
    end

    it 'returns a 400 status & JSON message when receiving invalid JSON request' do
      post '/tweets/new'

      expect(last_response).not_to be_ok
      expect(last_response.status).to eq 400
      expect(last_response.body).to include('JSON format is invalid: ')
    end

    it 'returns a 400 status & authenticate message when receiving invalid authentication request' do
      content = {}.to_json

      post '/tweets/new', content, json_headers

      expect(last_response).not_to be_ok
      expect(last_response.status).to eq 400
      expect(last_response.body).to include('Provide "token" key with value to authenticate')
    end

    it 'returns a 400 status & tweet message when receiving invalid tweet content request' do
      content = { token: auth_token }.to_json

      post '/tweets/new', content, json_headers

      expect(last_response).not_to be_ok
      expect(last_response.status).to eq 400
      expect(last_response.body).to include('Provide "content" key with value to tweet')
    end

    it 'returns a 403 status & authenticate message when receiving an invalid token' do
      content = { token: 'invalid' }.to_json

      post '/tweets/new', content, json_headers

      expect(last_response).not_to be_ok
      expect(last_response.status).to eq 403
      expect(last_response.body).to include('Invalid Credientials')
    end

    it 'returns a 200 status & tweet response when receiving a correct request' do
      tweet = "This is a tweet"
      content = { token: auth_token, content: tweet }.to_json
      successful_msg = 'Hooray'

      allow(wrapper).to receive(:tweet).with(tweet) { successful_msg }

      post '/tweets/new', content, json_headers

      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
      expect(last_response.body).to include(successful_msg)
    end

    it 'returns a 500 status & api response when receiving an api error' do
      tweet = "This is a tweet"
      content = { token: auth_token, content: tweet }.to_json
      unsuccessful_msg = 'not good :('

      allow(wrapper).to receive(:tweet).with(tweet).and_raise(unsuccessful_msg)

      post '/tweets/new', content, json_headers

      expect(last_response).not_to be_ok
      expect(last_response.status).to eq 500
      expect(last_response.body).to include(unsuccessful_msg)
    end
  end
end
