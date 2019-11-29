module Swagger::Serializer::Model
  def serialize(name = self.class.name)
    serializer =
      Swagger::Schema.current.component(name).serializer(Swagger::Serializer::Store.current.serializer_options)
    serializer.serialize(self)
  end
end
