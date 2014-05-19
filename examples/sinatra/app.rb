require 'sinatra'
require 'pannier/mounted'

helpers do
  def asset_tags
    @asset_tags ||= Pannier::Tags.new(settings.assets)
  end
end

get '/' do
  erb :index
end
