module Pannier
  class Concatenator < Struct.new(:result_path, :file_name)

    def concat!(contents)
      FileUtils.mkdir_p(result_path)
      File.open(File.join(result_path, file_name), 'w+') do |file|
        file << contents.join("\n")
      end
    end

  end
end
