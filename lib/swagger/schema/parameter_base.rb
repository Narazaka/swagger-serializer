require_relative "./util"
require_relative "./schema_accessor"

module Swagger
  class Schema
    class ParameterBase
      extend SchemaAccessor

      def initialize(schema)
        @schema = schema
      end

      define_schema_accessor %i[
        description
        required
        deprecated
        allowEmptyValue
        style
        explode
        allowReserved
        schema
        example
        examples
      ].freeze

      def to_json_schema
        schema
      end
    end
  end
end
