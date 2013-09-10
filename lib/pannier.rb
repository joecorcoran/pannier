require 'rack'
require 'fileutils'
require 'pathname'

require 'pannier/api'
require 'pannier/asset'
require 'pannier/asset_writer'
require 'pannier/concatenator'
require 'pannier/dsl'
require 'pannier/errors'
require 'pannier/file_handler'
require 'pannier/package'
require 'pannier/report'
require 'pannier/template'
require 'pannier/version'

require 'pannier/app'

module Pannier
  def self.build(&block)
    App.build(&block)
  end
end
