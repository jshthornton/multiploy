require 'configuration'

module Multiploy
  class ConfigurationHelper
    attr_accessor :items

    def initialize
      @items = ['core', 'fetch', 'store', 'transfer', 'deploy']
    end

    def load_default_config
      # Load default config
      ::Configuration.path = File.join(File.expand_path(File.dirname(__FILE__)), 'config')

      @items.each do |item|
        ::Configuration.load item
      end
    end

    def load_user_config
      # Load user config
      ::Configuration.path = 'config'

      @items.each do |item|
        ::Configuration.load item
      end
    end

    def merge_config
      @items.each do |item|
        default = ::Configuration.for "default/#{item}"
        user = ::Configuration.for "user/#{item}"

        ::Configuration.for(item, default)
        ::Configuration.for(item, user)
      end
    end
  end
end