require_relative './actions/fetch/remote'
require_relative './actions/store/file'
require_relative './actions/transfer/sshkit_file'
require_relative './actions/deploy/default'

#
module Multiploy
  #
  class Application
    def execute
      fetcher = Multiploy::Fetch::Remote.new
      storer = Multiploy::Store::File.new
      transferer = Multiploy::Transfer::SSHKitFile.new
      deployer = Multiploy::Deploy::Default.new
    end
  end
end
