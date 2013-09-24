module Pannier
  class MissingBehavior < ArgumentError
    def initialize(name)
      @name = name
    end

    def message
      "No behavior #{@name.inspect} was found. Maybe you need to add one?"
    end
  end

  class DSLNoMethodError < NoMethodError
    def initialize(*args)
      @klass_name, @method_name = *args
    end

    def message
      "#{@klass_name} has no method \"#{@method_name}\". Please check your configuration."
    end
  end
end
