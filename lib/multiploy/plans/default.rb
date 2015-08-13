require_relative '../actions/fetch/remote'
require_relative '../actions/store/file'
require_relative '../actions/transfer/sshkit_file'
require_relative '../actions/deploy/default'
require 'configuration'
require 'ostruct'

module Multiploy
  module Plans
    #
    class Default
      attr_accessor :fetcher, :storer, :transferer, :deployer

      def execute
        @storer.data = @fetcher.execute
        @storer.execute
        @transferer.execute
        @deployer.execute
      end
    end

    class DefaultFactory
      def make
        fetch_config = Configuration.for 'fetch'
        fetcher = Multiploy::Fetch::Remote.new
        fetcher.url = fetch_config.url
        fetcher.http_options = fetch_config.http_options

        store_config = Configuration.for 'store'
        storer = Multiploy::Store::File.new
        storer.output_path = store_config.output_path

        transfer_config = Configuration.for 'transfer'
        transferer = Multiploy::Transfer::SSHKitFile.new

        transferer.local_path =
          if transfer_config.respond_to? :local_path then
            transfer_config.local_path
          else
            store_config.output_path
          end
        transferer.remote_path = transfer_config.remote_path

        deploy_config = Configuration.for 'deploy'
        actionFactory = Multiploy::Deploy::ActionFactory.new
        deployer = actionFactory.makeDeploy(OpenStruct.new(
          naming_mechanism: deploy_config.naming_mechanism
        ))

        plan = Default.new
        plan.fetcher = fetcher
        plan.storer = storer
        plan.deployer = deployer

        plan
      end
    end
  end
end