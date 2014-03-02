require 'delegate'
require 'pannier/errors'

module Pannier
  module DSL

    def build(*args, &block)
      base = self.new(*args)
      delegator_klass = self.const_get('DSLDelegator')
      delegator = delegator_klass.new(base)
      delegator.instance_eval(&block)
      base
    end

    def dsl(&block)
      begin
        delegator_klass = self.const_get('DSLDelegator')
        delegator_klass.class_eval(&block)
      rescue NameError
        delegator_klass = Class.new(SimpleDelegator, &block)
        self.const_set('DSLDelegator', delegator_klass)
      end
    end

  end
end
