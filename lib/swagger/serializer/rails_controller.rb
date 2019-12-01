module Swagger::Serializer::RailsController
  private

  # render

  def render_as_schema(code, format, data)
    render format => render_serializer(code, format).serialize(data)
  end

  def render_serializer(code, format)
    response_obj = swagger_operation.responses[code]
    response_obj.content.send(format).serializer(Swagger::Serializer::Store.current.serializer_options)
  end

  def swagger_operation
    return @swagger_operation if @swagger_operation

    route = swagger_schema_route_from_request
    @swagger_operation = Swagger::Schema.current.path(route[:path]).send(route[:method])
  end

  def swagger_schema_route_from_request
    return @swagger_schema_route_from_request if @swagger_schema_route_from_request

    Rails.application.routes.router.recognize(request) do |route|
      path = route.path.spec.to_s.sub("(.:format)", "").gsub(/:(\w+)/, "{\\1}")
      @swagger_schema_route_from_request = { path: path, method: request.request_method.underscore }
      return @swagger_schema_route_from_request
    end
  end

  # params

  def parameter_params
    @parameter_params ||= parameter_deserializer.data(params.permit!.to_h).deserialize.with_indifferent_access
  end

  def parameter_deserializer
    @parameter_deserializer ||=
      swagger_operation.parameters.deserializer(Swagger::Serializer::Store.current.serializer_options)
  end

  def body_params
    @body_params ||= body_deserializer ? body_deserializer.deserialize(params.permit!.to_h).with_indifferent_access : {}
  end

  def body_deserializer
    @body_deserializer ||=
      if request.content_type
        swagger_operation.request_body.content[request.content_type].deserializer(
          Swagger::Serializer::Store.current.serializer_options,
        )
      end
  end

  def schema_params
    @schema_params ||= parameter_params.merge(body_params)
  end
end
