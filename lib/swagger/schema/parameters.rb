require "json/schema/serializer"
require_relative "./util"
require_relative "./parameter"
require_relative "./parameters/deserializer"
require_relative "./parameters/validator"

module Swagger
  class Schema
    class Parameters < Array
      def [](index)
        parameter = super(index)
        Parameter.new(parameter) if parameter
      end

      def by_name(name)
        name_str = name.to_s
        parameter = find { |param| Util.try_hash(param, :name).to_s == name_str }
        Parameter.new(parameter) if parameter
      end

      def query
        select_by("query")
      end

      def header
        select_by("header")
      end

      def path
        select_by("path")
      end

      def cookie
        select_by("cookie")
      end

      def select_by(in_place)
        in_place_str = in_place.to_s
        Parameters.new(select { |param| Util.try_hash(param, :in).to_s == in_place_str })
      end

      def to_json_schema
        properties = {}
        required = []
        each do |param|
          parameter = Parameter.new(param)
          name = parameter.name.to_s
          properties[name] = parameter.to_json_schema
          required << name if parameter.required || parameter.path?
          if Util.try_hash(properties[name], :type).to_s == "string" && !parameter.allowEmptyValue &&
               Util.try_hash(properties[name], :minLength).nil?
            properties[name]["minLength"] = 1
          end
        end
        schema = { "type" => "object", "properties" => properties }
        schema["required"] = required unless required.empty?
        schema
      end

      def serializer(options = {})
        JSON::Schema::Serializer.new(to_json_schema, options)
      end

      def deserializer
        Deserializer.new(self)
      end

      def validator
        Validator.new(self)
      end
    end
  end
end
