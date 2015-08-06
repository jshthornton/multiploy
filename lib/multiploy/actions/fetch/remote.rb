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
        fetch

        fail validate_response unless valid_response?

        @response.body
      end
    end
  end
end
