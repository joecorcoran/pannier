require 'multi_json'

require 'pannier/app'
require 'pannier/version'

module Pannier
  def self.build(env_name = 'development', &block)
    App.build(env_name, &block)
  end

  def self.load(path, env_name)
    config = File.read(path)
    block = eval("proc { #{config} }", TOPLEVEL_BINDING, path, 0)
    App.build(env_name, &block)
  end
end
