require 'sinatra'

require 'pannier'
require 'pannier/tags'

helpers do
  def tags
    @tags ||= Pannier::Tags.new(settings.assets)
  end
end

get '/' do
  erb :index
end
