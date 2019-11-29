require_relative "./util"
require_relative "./response"

module Swagger
  class Schema
    class Responses
      def initialize(schema)
        @schema = schema
      end

      def [](code)
        Response.new(Util.try_hash_with_integer(@schema, code))
      end
    end
  end
end
