module Pannier
  class Environment

    def initialize(name)
      @name = name
      @development_mode = (name == 'development')
    end

    def development_mode
      mode = @development_mode
      mode = mode.call if mode.respond_to?(:call)
      mode
    end
    alias_method :development_mode?, :development_mode

    def development_mode=(mode)
      @development_mode = mode
    end

    def is?(expression)
      expression = Regexp.new(expression)
      @name =~ expression
    end

  end
end
