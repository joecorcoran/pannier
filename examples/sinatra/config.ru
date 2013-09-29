require './app'

assets = Pannier.build_from('./Pannierfile', ENV['RACK_ENV'])
assets.process!

map assets.root do
  run assets
end

set :assets, assets
run Sinatra::Application
