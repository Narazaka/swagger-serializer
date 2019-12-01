require "json/schema/serializer"
require_relative "./schema_accessor"
require_relative "./media_type/deserializer"
require_relative "./media_type/validator"

module Swagger
  class Schema
    class MediaType
      extend SchemaAccessor

      def initialize(schema)
        @schema = schema
      end

      define_schema_accessor :schema, :example, :examples, :encoding

      def serializer(options = {})
        JSON::Schema::Serializer.new(schema, options)
      end

      def deserializer(options = {})
        Deserializer.new(schema, options)
      end

      def validator
        Validator.new(schema)
      end
    end
  end
end
