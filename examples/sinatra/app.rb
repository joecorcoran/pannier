require 'sinatra'
require 'pannier/mounted'

helpers do
  def asset_tags
    @asset_tags ||= Pannier::Tags.new(settings.pannier)
  end
end

get '/' do
  erb :index
end
