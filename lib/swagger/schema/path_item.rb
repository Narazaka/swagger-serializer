require_relative "./util"
require_relative "./operation"
require_relative "./schema_accessor"
require_relative "./parameters"
require_relative "./handle_servers"

module Swagger
  class Schema
    class PathItem
      extend SchemaAccessor
      include HandleServers

      METHODS = %i[get put post delete options head patch trace].freeze

      def initialize(schema)
        @schema = schema
      end

      define_schema_accessor :summary, :description

      def parameters
        Parameters.new(Util.try_hash(@schema, :parameters) || [])
      end

      METHODS.each do |method|
        define_method(method) do
          operation = Util.try_hash(@schema, method)
          Operation.new(operation, self) if operation
        end
      end
    end
  end
end
