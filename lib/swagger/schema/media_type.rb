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

      def serializer(options = {}, store = true)
        use_options = store ? Swagger::Serializer::Store.current.serialize_options.merge(options) : options
        JSON::Schema::Serializer.new(schema, use_options)
      end

      def deserializer(options = {}, store = true)
        use_options = store ? Swagger::Serializer::Store.current.deserialize_options.merge(options) : options
        Deserializer.new(schema, use_options)
      end

      def validator
        Validator.new(schema)
      end
    end
  end
end
