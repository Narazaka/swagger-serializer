module Swagger
  module Serializer
    class Store
      class << self
        def current
          @current ||= new
        end
      end

      attr_reader :serialize_options, :deserialize_options

      def initialize(serialize_options: nil, deserialize_options: nil)
        @serialize_options = serialize_options || {}
        @deserialize_options = deserialize_options || {}

        @serialize_options[:inject_key] ||= "title"
        @deserialize_options[:inject_key] ||= "title"

        @serialize_options[:injectors] ||= Injectors.new(cache: @serialize_options[:cache])
        @deserialize_options[:injectors] ||= Injectors.new(cache: @deserialize_options[:cache])
      end

      class Injectors
        def initialize(injectors: {}, cache: false)
          @injectors = injectors
          @cache = cache
        end

        def [](name)
          if @cache
            @injectors[name] ||= "#{name}Serializer".safe_constantize
          else
            "#{name}Serializer".safe_constantize
          end
        end
      end
    end
  end
end
