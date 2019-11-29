module Swagger
  module Serializer
    class Store
      class << self
        def current
          @current ||= new
        end
      end

      attr_accessor :inject_key, :injectors, :cache

      def initialize(inject_key: "title", injectors: nil, cache: false)
        @inject_key = inject_key
        @injectors = injectors || Injectors.new(cache: cache)
        @cache = cache
      end

      def serializer_options
        if cache
          @serializer_options ||= { inject_key: inject_key, injectors: injectors }
        else
          { inject_key: inject_key, injectors: injectors }
        end
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
