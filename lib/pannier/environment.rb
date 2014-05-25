module Pannier
  class Environment < Struct.new(:name)

    def matches?(expression)
      expression = Regexp.new(expression)
      name =~ expression
    end

  end
end
