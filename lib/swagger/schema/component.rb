require "json/schema/serializer"

module Swagger
  class Schema
    class Component
      attr_reader :schema

      def initialize(schema)
        @schema = schema
      end

      def serializer(options = {})
        JSON::Schema::Serializer.new(@schema, options)
      end
    end
  end
end
