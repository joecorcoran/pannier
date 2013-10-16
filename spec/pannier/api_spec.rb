require 'rack/test'
require 'spec_helper'
require 'pannier/api'

describe Pannier::API::Handler do
  include Rack::Test::Methods

  let(:asset_app) { mock('Pannier::App') }
  let(:app)       { Pannier::API::Handler.new(asset_app) }

  it 'responds with 200 when request is for full packages report' do
    asset_app.stubs(:packages => [])
    get '/packages'
    expect(last_response.status).to eq 200
  end

  it 'responds with 200 when request is for single package' do
    package = mock('Pannier::Package', :name => :foo, :assets => [])
    asset_app.stubs(:packages => [package])
    get '/packages/foo'
    expect(last_response.status).to eq 200
  end

  it 'responds with 404 when package cannot be found' do
    asset_app.stubs(:packages => [])
    get '/packages/bar'
    expect(last_response.status).to eq 404
  end

  it 'responds with 500 when request is not API-related' do
    get '/foo'
    expect(last_response.status).to eq 500
  end

end
