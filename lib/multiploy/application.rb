require_relative './actions/fetch/remote'
require_relative './actions/store/file'
require_relative './actions/transfer/sshkit_file'
require_relative './actions/deploy/default'

#
module Multiploy
  #
  class Application
    def load_default_config
      # Load default config
      Configuration.path = File.join(File.expand_path(File.dirname(__FILE__)), 'config')
      Configuration.load 'fetch'
      Configuration.load 'store'
      Configuration.load 'transfer'
      Configuration.load 'deploy'
    end
    def execute
      fetcher = Multiploy::Fetch::Remote.new
      storer = Multiploy::Store::File.new
      transferer = Multiploy::Transfer::SSHKitFile.new
      deployer = Multiploy::Deploy::Default.new
    end
  end
end
