module Swagger
  module Serializer
    class Store
      class << self
        def current
          @current ||= new
        end
      end

      attr_accessor :inject_key, :injectors

      def initialize(inject_key = "title", injectors = Injectors.new)
        @inject_key = inject_key
        @injectors = injectors
      end

      def serializer_options
        { inject_key: inject_key, injectors: injectors }
      end

      class Injectors
        def [](name)
          "#{name}Serializer".safe_constantize
        end
      end
    end
  end
end
