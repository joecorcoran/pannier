require 'delegate'
require 'pannier/errors'

module Pannier
  module DSL

    def build(*args, &block)
      base = self.new(*args)
      delegator_klass = self.const_get('DSLDelegator')
      delegator = delegator_klass.new(base)
      begin
        delegator.instance_eval(&block)
      rescue NoMethodError => error
        raise DSLNoMethodError.new(base.class.name, error.name)
      end
      base
    end

    def dsl(&block)
      delegator_klass = Class.new(SimpleDelegator, &block)
      self.const_set('DSLDelegator', delegator_klass)
    end

  end
end
