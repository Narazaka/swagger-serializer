module Swagger
  module Serializer
    class Store
      class << self
        def current
          @current ||= new
        end
      end

      attr_reader :options

      def initialize(options = nil)
        @options = options || {}
        @options[:inject_key] ||= "title"
        @options[:injectors] ||= Injectors.new(cache: @options[:cache])
      end

      def serializer_options
        @options
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
