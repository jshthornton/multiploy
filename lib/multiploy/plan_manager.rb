module Multiploy
  #
  class PlanManager
    def load(filename)
      Kernel.load filename
    end

    def summon_class(namespace)
      Object.const_get namespace
    end

    def resolve_factory(klass)
      # Class method
      return klass.make if klass.respond_to? :make

      # Factory instance method
      if klass.method_defined? :make then
        factory = klass.new
        return factory.make
      end

      # Raw
      return klass.new
    end
  end
end