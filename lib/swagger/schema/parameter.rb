require_relative "./util"
require_relative "./schema_accessor"
require_relative "./parameter_base"

module Swagger
  class Schema
    class Parameter < ParameterBase
      extend SchemaAccessor

      define_schema_accessor :name, :in

      %w[path query header cookie].each { |name| define_method(:"#{name}?") { self.in.to_s == name } }
    end
  end
end
