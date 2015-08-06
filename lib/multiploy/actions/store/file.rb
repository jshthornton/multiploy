module Multiploy
  module Store
    #
    class File
      attr_accessor :data, :output_path

      def execute
        ::File.open(@output_path, 'wb') do |f|
          f.write(@data)
        end
      end
    end
  end
end
