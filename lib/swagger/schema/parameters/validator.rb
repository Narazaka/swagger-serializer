require_relative "../util"

module Swagger
  class Schema
    class Parameters < Array
      class Validator
        def initialize(parameters)
          @parameters = parameters
        end

        def validate(data)
          @parameters.to_json_schema
          # validate
        end
      end
    end
  end
end
