require_relative "./util"
require_relative "./schema_accessor"

module Swagger
  class Schema
    class Server
      extend SchemaAccessor

      def initialize(schema)
        @schema = schema
      end

      define_schema_accessor :url, :description, :variables

      def complete_url(url_variables = {})
        use_url = url
        (variables || {}).each do |name, options|
          variable = Util.try_hash(url_variables, name) || Util.try_hash(options, :default)
          use_url.gsub!("{#{name}}", variable.to_s)
        end
        use_url
      end
    end
  end
end
