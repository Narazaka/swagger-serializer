require_relative "./util"
require_relative "./component"

module Swagger
  class Schema
    class ComponentSet
      def initialize(schema)
        @schema = schema
      end

      def [](name)
        # HogeSerializer
        name = name.name.sub(/Serializer$/, "").gsub(/::/, '-') if name.class == Class
        component = Util.try_hash(@schema, name)
        Component.new(component) if component
      end
    end
  end
end
