module Multiploy
  #
  class PlanManager
    def load(filename)
      Kernel.load filename
    end

    def summon_class(namespace)
      Object.const_get namespace
    end
  end
end