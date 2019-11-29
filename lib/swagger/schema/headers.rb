require_relative "./util"
require_relative "./header"

module Swagger
  class Schema
    class Headers
      def initialize(schema)
        @schema = schema
      end

      def [](name)
        header = Util.try_hash(@schema, name)
        Header.new(header) if header
      end

      def to_json_schema
        return { "type" => "object" } unless @schema

        properties = {}
        required = []
        @schema.each do |_name, param|
          name = _name.to_s
          header = Header.new(param)
          properties[name] = header.to_json_schema
          required << name if header.required
          if Util.try_hash(properties[name], :type).to_s == "string" && !parameter.allowEmptyValue &&
               Util.try_hash(properties[name], :minLength).nil?
            properties[name]["minLength"] = 1
          end
        end
        schema = { "type" => "object", "properties" => properties }
        schema["required"] = required unless required.empty?
        schema
      end
    end
  end
end
