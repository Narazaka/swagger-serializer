require_relative "./schema/component"
require_relative "./schema/path_item"
require_relative "./schema/server"
require_relative "./schema/schema_accessor"
require_relative "./schema/handle_servers"
require_relative "./schema/util"

module Swagger
  class Schema
    extend SchemaAccessor
    include HandleServers

    attr_reader :schema
    attr_reader :lazy_schema

    class << self
      attr_accessor :current

      def load_file(filepath)
        new(YAML.load_file(filepath)) # rubocop:disable Airbnb/UnsafeYamlMarshal
      end

      def load_file_to_current(file_path)
        @current = load_file(file_path)
      end
    end

    def initialize(schema)
      @schema = schema
    end

    define_schema_accessor :paths, :components

    def path(path)
      path_item = Util.try_hash(paths, path)
      PathItem.new(path_item) if path_item
    end

    def component(name)
      component = Util.try_hash(components, name)
      Component.new(component) if component
    end
  end
end
