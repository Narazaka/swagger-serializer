require_relative "../util"

module Swagger
  class Schema
    class MediaType
      class Validator
        def initialize(schema)
          @schema = schema
        end

        def validate(data)
          @parameters.to_json_schema
          # validate
        end
      end
    end
  end
end
