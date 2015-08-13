require_relative 'configuration_helper'
require_relative 'plan_manager'
require 'configuration'

#
module Multiploy
  #
  class Application

    def initialize
      @configuration_helper = ConfigurationHelper.new
      @plan_manager = PlanManager.new
    end

    def execute
      @configuration_helper.load_default_config
      @configuration_helper.load_user_config
      @configuration_helper.merge_config

      core_config = Configuration.for 'core'
      @plan_manager.load core_config.plan.file_path
      plan_klass = @plan_manager.summon_class core_config.plan.class_lookup
      @plan = @plan_manager.resolve_factory plan_klass

      @plan.execute
    end
  end
end
