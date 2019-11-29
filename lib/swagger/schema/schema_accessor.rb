require_relative "./util"
require "snake_camel/methods"

module Swagger
  class Schema
    module SchemaAccessor
      private

      def define_schema_accessor(*camel_names)
        camel_names.flatten.each do |name|
          define_method(name) { Util.try_hash(@schema, name) }

          alias_case name
        end
      end

      def alias_case(camel)
        snake = SnakeCamel::Methods.snakecase(camel.to_s)
        alias_method snake, camel unless snake == camel
      end
    end
  end
end
