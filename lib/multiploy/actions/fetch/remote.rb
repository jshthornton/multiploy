require 'httparty'

module Multiploy
  module Fetch
    #
    class Remote
      def validate_response
      end

      def execute
        # response = HTTParty.get('https://github.com/techinasia/server-cookbooks/archive/master.zip')
        # validate_response(response)

        # return response
      end
    end
  end
end
