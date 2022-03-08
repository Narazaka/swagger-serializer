require_relative "./util"
require_relative "./component_set"

module Swagger
  class Schema
    class Components
      def initialize(schema)
        @schema = schema
      end

      def [](name)
        component_set = Util.try_hash(@schema, name)
        ComponentSet.new(component_set) if component_set
      end

      def schemas
        self[:schemas]
      end
    end
  end
end
