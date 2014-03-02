require './app'

set :assets, Pannier.rackup(self)
run Sinatra::Application
