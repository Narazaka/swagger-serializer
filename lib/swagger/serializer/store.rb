module Swagger
  module Serializer
    class Store
      class << self
        def current
          @current ||= new
        end
      end

      attr_accessor :inject_key

      def initialize(inject_key = "title")
        @inject_key = inject_key
      end

      def serializer_options
        { inject_key: inject_key, injectors: Injectors.new }
      end

      class Injectors
        def [](name)
          "#{name}Serializer".constantize
        end
      end
    end
  end
end
