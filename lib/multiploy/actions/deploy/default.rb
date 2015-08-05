require 'sshkit/dsl'

module Multiploy
  module Deploy
    #
    class Default
      def execute
      end
    end

    #
    class SetupApplicationDirectory
      def execute
      end
    end

    #
    class SetupReleaseDirectory
      def execute
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
      end
    end

    #
    class VersionNaming
      def name
      end
    end

    #
    class Install
      def execute
      end
    end

    #
    class Unpublish
      def execute
      end
    end

    #
    class Publish
      def execute
      end
    end
  end
end


