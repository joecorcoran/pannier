require 'sinatra'
require 'pannier'

helpers do
  def asset_writer
    @asset_writer ||= Pannier::AssetWriter.new(settings.assets)
  end
end

get '/' do
  erb :index
end
