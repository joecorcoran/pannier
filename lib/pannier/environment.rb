module Pannier
  class Environment

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def is?(expression)
      expression = Regexp.new(expression)
      @name =~ expression
    end

  end
end
