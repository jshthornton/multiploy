module Multiploy
  #
  class Organizer
    attr_accessor :steps

    def initialize
      @steps = []
    end

    def execute
      @steps.each { |step| step.execute }
    end
  end
end
