require 'rack'
require 'pannier/app'
require 'pannier/asset_writer'
require 'pannier/version'

module Pannier
  def self.build(host_env = nil, &block)
    App.build(host_env, &block)
  end
end
