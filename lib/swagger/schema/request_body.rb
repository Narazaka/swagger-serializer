require_relative "./util"
require_relative "./schema_accessor"
require_relative "./content"

module Swagger
  class Schema
    class RequestBody
      extend SchemaAccessor

      def initialize(schema)
        @schema = schema
      end

      define_schema_accessor :description, :required

      def content
        Content.new(Util.try_hash(@schema, :content))
      end
    end
  end
end
