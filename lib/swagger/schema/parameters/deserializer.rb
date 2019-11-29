require "json/schema/serializer"
require_relative "../util"

module Swagger
  class Schema
    class Parameters < Array
      class Deserializer
        def initialize(parameters)
          @parameters = parameters
        end

        def data(data)
          DataDeserializer.new(@parameters, @data)
        end

        class DataDeserializer
          def initialize(parameters, data)
            @parameters = parameters
            @data = data
          end

          def [](name)
            parameter = @parameters.by_name(name)
            value = Util.try_hash(data, name)
            return nil if value.nil? && !parameter.required && !parameter.path?

            JSON::Schema::Serializer.new(parameter.to_json_schema).serialize(value)
          end
        end
      end
    end
  end
end
