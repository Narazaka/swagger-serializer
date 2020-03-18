require "json/schema/serializer"

module Swagger
  class Schema
    class Component
      attr_reader :schema

      def initialize(schema)
        @schema = schema
      end

      def serializer(options = {}, store = true)
        use_options = store ? Swagger::Serializer::Store.current.serialize_options.merge(options) : options
        JSON::Schema::Serializer.new(@schema, use_options)
      end
    end
  end
end
