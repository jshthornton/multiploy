require 'sshkit'

module Multiploy
  module Transfer
    #
    class SSHKitFile
      attr_accessor :hosts, :options, :local_path, :remote_path, :coordinator

      def backend_action
        local_path = @local_path
        remote_path = @remote_path

        proc do |host|
          upload! local_path, remote_path
        end
      end

      def execute
        @coordinator.each @options, backend_action
      end
    end

    #
    class SSHKitFileFactory
      def make
        instance = SSHKitFile.new
        instance.coordinator = Coordinator.new(@hosts)

        return instance
      end
    end
  end
end
