require 'logger'

module Pannier
  class Logger < ::Logger

    def initialize(*args)
      super
      @formatter = ->(_, _, _, message) do
        message + "\n"
      end
    end

  end
end
