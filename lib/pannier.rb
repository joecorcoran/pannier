require 'rack'
require 'pannier/app'
require 'pannier/asset_writer'
require 'pannier/version'

module Pannier
  def self.build(&block)
    App.build(&block)
  end
end
