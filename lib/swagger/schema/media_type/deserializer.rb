require "json/schema/serializer"
require_relative "../util"

module Swagger
  class Schema
    class MediaType
      class Deserializer < JSON::Schema::Serializer
        alias_method :deserialize, :serialize
      end
    end
  end
end
