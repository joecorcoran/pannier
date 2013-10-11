module Pannier
  class MissingBehavior < ArgumentError
    def initialize(msg)
      @msg = msg
    end

    def message
      "No behavior #{@msg.inspect} was found. Maybe you need to add one?"
    end
  end
end
