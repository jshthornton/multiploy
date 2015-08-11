require 'sshkit'
require 'date'

module Multiploy
  module Deploy
    #
    class Default
      def execute
        # Setup
        setup.execute

        # Naming
        release_name = release_namer.name

        # Install
        installer.execute

        # Unpublish
        unpublisher.execute

        # Publish
        publisher.execute
      end
    end

    #
    class DefaultFactory
      def make
        default = Default.new

        # Setup
        setup = default.setup = Multiploy::Organizer.new
        application_directory = SetupDirectory.new
        # application_directory.path

        releases_directory = SetupDirectory.new
        # releases_directory.path

        setup.steps.push(application_directory, release_directory)

        default.release_namer = DateTimeNaming.new

        # Install
        installer = default.installer = Multiploy::Organizer.new
        release_directory = SetupDirectory.new
        move_to_destination = MoveToDestination.new
        delete_source = DeleteSource.new

        installer.steps.push(
          release_directory,
          move_to_destination,
          delete_source
        )

        # Unplublish
        default.unpublisher = Unpublish.new

        # Publish
        default.publisher = Publish.new

        default
      end
    end

    #
    class SetupDirectory
      attr_accessor :coordinator, :options, :path

      def backend_action
        path = @path

        proc do |_host|
          execute! :mkdir, '-p', path
        end
      end

      def execute
        @coordinator.each @options, backend_action
      end
    end

    #
    class DateTimeNaming
      def name
        datetime = DateTime.now
        datetime.strftime('%Y%m%d%H%M%S')
      end
    end

    #
    class UUIDNaming
      def name
        SecureRandom.uuid
      end
    end

    #
    class CustomNaming
      attr_accessor :name
    end

    #
    class MoveToDestination
      attr_accessor :coordinator, :options, :src_path, :dest_path

      def backend_action
        src_path = @src_path
        dest_path = @dest_path

        proc do |_host|
          execute! :tar, '-zxvf', src_path, '-C', dest_path, '--strip'
        end
      end

      def execute
        @coordinator.each @options, backend_action
      end
    end

    #
    class DeleteSource
      attr_accessor :coordinator, :options, :path

      def backend_action
        path = @path

        proc do |_host|
          execute! :rm, path
        end
      end

      def execute
        @coordinator.each @options, backend_action
      end
    end

    #
    class Unpublish
      attr_accessor :coordinator, :options, :path

      def backend_action
        path = @path

        proc do |_host|
          execute! :unlink, path
        end
      end

      def execute
        @coordinator.each @options, backend_action
      end
    end

    #
    class Publish
      attr_accessor :coordinator, :options, :file_path, :symlink_path

      def backend_action
        file_path = @file_path
        symlink_path = @symlink_path

        proc do |_host|
          execute! :ln, '-s', file_path, symlink_path
        end
      end

      def execute
        @coordinator.each @options, backend_action
      end
    end
  end
end
