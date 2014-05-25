require './app'

set :pannier, Pannier.rackup(self)
run Sinatra::Application
