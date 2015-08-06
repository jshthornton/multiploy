require 'httparty'

module Multiploy
  module Fetch
    #
    class Remote
      attr_accessor :url, :http_options, :response

      def valid_response?
        validate_response == true ? true : false
      end

      def validate_response
        return 'Non-200 response' unless @response.code == 200
        true
      end

      def fetch
        @response = HTTParty.get(@url, @http_options)
      end

      def execute
        # response = HTTParty.get('https://github.com/techinasia/server-cookbooks/archive/master.zip')
        # validate_response(response)

        # return response
      end
    end
  end
end
