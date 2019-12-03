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

        injectors = Injectors.new(cache: @options[:cache])
        @serialize_options[:injectors] ||= injectors
        @deserialize_options[:injectors] ||= injectors
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
