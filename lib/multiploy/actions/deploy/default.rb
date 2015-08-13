require 'sshkit'
require 'date'
require 'memoist'

module Multiploy
  module Deploy
    #
    class ActionFactory
      def makeSetup(options)
        application_directory = SetupDirectory.new
        application_directory.coordinator = options.coordinator
        application_directory.options = options.options
        application_directory.path = options.application_directory_path

        releases_directory = SetupDirectory.new
        releases_directory.path = "#{options.application_directory_path}/#{options.releases_directory_name}"

        setup = Multiploy::Organizer.new
        setup.steps.push(application_directory, release_directory)

        setup
      end

      def makeInstall(options)
        release_directory = SetupDirectory.new
        release_directory.path = "#{options.application_directory_path}/#{options.releases_directory_name}/namer.name"

        move_to_destination = MoveToDestination.new
        move_to_destination.src_path = options.src_path
        move_to_destination.dest_path = "#{options.application_directory_path}/#{options.releases_directory_name}/namer.name"

        delete_source = DeleteSource.new
        delete_source.path = options.src_path

        installer = Multiploy::Organizer.new
        installer.steps.push(
          release_directory,
          move_to_destination,
          delete_source
        )

        installer
      end

      def makeDeploy(options)
        namer = NamingFactory.new.make(options.naming_mechanism)
        options.namer = namer

        # Setup
        setup = makeSetup(options)

        # Install
        installer = makeInstall(options)

        # Unplublish
        unpublisher = Unpublish.new

        # Publish
        publisher = Publish.new

        deploy = Multiploy::Organizer.new
        deploy.steps.push(
          setup,
          installer,
          unpublisher,
          publisher
        )
        deploy
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
    class NamingAbstract
      extend Memoist

      def name
      end

      memoize :name
    end

    #
    class DateTimeNaming < NamingAbstract
      def name
        datetime = DateTime.now
        datetime.strftime('%Y%m%d%H%M%S')
      end
    end

    #
    class UUIDNaming < NamingAbstract
      def name
        SecureRandom.uuid
      end
    end

    #
    class NamingFactory
      def make(type)
        case type
        when 'datetime'
          DateTimeNaming.new
        when 'uuid'
          UUIDNaming.new
        else
          fail 'Unknown naming mechanism'
        end
      end
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
