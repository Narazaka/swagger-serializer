require_relative "./util"
require_relative "./path_item"
require_relative "./schema_accessor"
require_relative "./parameters"
require_relative "./request_body"
require_relative "./responses"

module Swagger
  class Schema
    class Operation
      extend SchemaAccessor

      def initialize(schema, path_item = nil)
        @schema = schema
        @path_item = path_item
      end

      define_schema_accessor %i[tags summary description externalDocs operationId deprecated callbacks security]

      def parameters
        Parameters.new((@path_item&.parameters || []) + (Util.try_hash(@schema, :parameters) || []))
      end

      def requestBody
        RequestBody.new(Util.try_hash(@schema, :requestBody))
      end

      alias_method :request_body, :requestBody

      def responses
        Responses.new(Util.try_hash(@schema, :responses))
      end
    end
  end
end
