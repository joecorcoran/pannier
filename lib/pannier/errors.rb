module Pannier
  class MissingBehavior < ArgumentError
    def initialize(name)
      @name = name
    end

    def message
      "No behavior named #{@name.inspect} was found. Maybe you need to add one?"
    end
  end
end
