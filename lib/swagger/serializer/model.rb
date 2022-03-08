module Swagger::Serializer::Model
  def serialize(name = self.class.name)
    serializer =
      Swagger::Schema.current.components.schemas[name].serializer(Swagger::Serializer::Store.current.serialize_options)
    serializer.serialize(self)
  end
end
