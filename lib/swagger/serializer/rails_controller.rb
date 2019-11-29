module Swagger::Serializer::RailsController
  private

  def render_as_schema(code, format, data)
    route = swagger_schema_route_from_request
    operation = Swagger::Schema.current.path(route[:path]).send(route[:method])
    response_obj = operation.responses[code]
    serializer = response_obj.content.send(format).serializer(Swagger::Serializer::Store.current.serializer_options)
    render format => serializer.serialize(data)
  end

  def swagger_schema_route_from_request
    Rails.application.routes.router.recognize(request) do |route|
      path = route.path.spec.to_s.sub("(.:format)", "").gsub(/:(\w+)/, "{\\1}")
      return { path: path, method: request.method.underscore }
    end
  end
end
