require_relative "./util"
require_relative "./schema_accessor"
require_relative "./content"
require_relative "./headers"

module Swagger
  class Schema
    class Response
      extend SchemaAccessor

      def initialize(schema)
        @schema = schema
      end

      define_schema_accessor :description, :required

      def headers
        Headers.new(Util.try_hash(@schema, :headers) || [])
      end

      def content
        Content.new(Util.try_hash(@schema, :content))
      end

      def links
        # TODO
        Util.try_hash(@schema, :links)
      end
    end
  end
end
