require ::File.expand_path('../config/environment',  __FILE__)
Rails.application.config.pannier = Pannier.rackup(self)
run Rails.application
