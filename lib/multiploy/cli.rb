require 'optparse'
require 'ostruct'
require_relative 'version'

module Multiploy
  #
  class CLI
    attr_accessor :command, :args

    def initialize(command = nil)
      @options = OpenStruct.new
      @parser = OptionParser.new
      @command = command
      assign_defaults
    end

    def assign_defaults
      @options.verbose = false
    end

    def run
      @parser.banner = 'Usage: bin.rb [options]'

      @parser.separator ''
      @parser.separator 'Specific options:'

      # # Queue ID
      # @parser.on('-q', '--queue-id QUEUEID',
      #           'The queue id to send a message to') do |id|
      #   @options.queue_id = id
      # end

      # # Action
      # @parser.on('-a', '--action ACTION',
      #           'The action key') do |action|
      #   @options.action = action
      # end

      # # Arguments
      # @parser.on('--arguments x,y,z', Array, '') do |arguments|
      #   @options.arguments = arguments
      # end

      @parser.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
        @options.verbose = v
      end

      @parser.separator ''
      @parser.separator 'Common options:'

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      @parser.on_tail('-h', '--help', 'Show this message') do
        puts @options
        exit
      end

      # Another typical switch to print the version.
      @parser.on_tail('--version', 'Show version') do
        puts Multiploy::Version
        exit
      end

      @parser.parse!(@args)

      @command.execute
    end
  end
end