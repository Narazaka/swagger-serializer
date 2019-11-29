require_relative "./util"
require_relative "./media_type"

module Swagger
  class Schema
    class Content
      def initialize(schema)
        @schema = schema
      end

      def [](type)
        schema = Util.try_hash(@schema, type)
        MediaType.new(schema) if schema
      end

      def self.shortcut(name, type)
        define_method(name) { self[type] }
      end

      shortcut :json, "application/json"
      shortcut :xml, "application/xml"
      shortcut :plain, "text/plain"
    end
  end
end
