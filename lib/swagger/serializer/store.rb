module Swagger
  module Serializer
    class Store
      class << self
        def current
          @current ||= new
        end
      end

      attr_reader :serializers
      attr_accessor :inject_key

      def initialize(serializers = {}, inject_key = "title")
        @serializers = serializers
        @inject_key = inject_key
      end

      def serializer_options
        { inject_key: inject_key, injectors: @serializers }
      end

      def <<(klass)
        @serializers[klass.name.sub(/Serializer$/, "")] = klass
      end
    end
  end
end
