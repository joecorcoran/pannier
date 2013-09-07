module Pannier
  class Concatenator

    def call(content_array)
      content_array.join("\n")
    end

  end
end
