# Swagger::Serializer

[![Actions Status](https://github.com/Narazaka/swagger-serializer/workflows/Ruby/badge.svg)](https://github.com/Narazaka/swagger-serializer/actions)
[![Gem Version](https://badge.fury.io/rb/swagger-serializer.svg)](https://badge.fury.io/rb/swagger-serializer)

Swagger (OpenAPI 3) schema based serializer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'swagger-serializer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install swagger-serializer

## Usage

### Rails

Write your OpenAPI spec.

```yaml
# swagger.yml
openapi: "3.0"
info:
  title: example api
  version: 0.1.0
components:
  User: &User
    title: User
    type: object
    properties:
      id:
        type: integer
      name:
        type: string
    required: [id]
paths:
  /users:
    get:
      responses:
        200:
          content:
            application/json:
              schema:
                type: array
                items: *User
  /users/{id}:
    get:
      responses:
        200:
          content:
            application/json:
              schema: *User

```

Load it in initializer.

```ruby
# config/initializers/swagger_serializer.rb

Swagger::Schema.load_file_to_current(
  __dir__ + "/../../swagger.yml",
)

# Swagger::Schema accepts lazy load. So your swagger schema data instance may also be accepted.
#
# class SwaggerData
#   def paths
#     load_paths_now
#   end
# end
#
# Swagger::Schema.current = Swagger::Schema.new(SwaggerData.new)
```

Use it in controllers.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Swagger::Serializer::RailsController

  def render_ok(data)
    render_as_schema 200, :json, data
  end
end
```

```ruby
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    render_ok User.all
  end

  def show
    render_ok User.find(params[:id])
  end
end
```

Would you want to customize serialization?

```ruby
# app/serializers/base_serializer.rb
class BaseSerializer
  include Swagger::Serializer
end
```

```ruby
# app/serializers/user_serializer.rb
class UserSerializer < BaseSerializer
  def name
    "#{@model.name}!!!!"
  end
end
```

Now you can get `{ "id" => 42, "name" => "me!!!!" }`.

This serializer class detection uses the schema's `title` key.
If you want to use `Foo::BarSerializer`, set `Foo::Bar` to `title` key.
The key is configurable by `Swagger::Serializer::Store.current.inject_key = "my_inject_key"`.

Sometimes model needs direct serialize.

```ruby
# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  include Swagger::Serializer::Model
end
```

Now you can get serialized result by `p User.first.serialize`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Narazaka/swagger-serializer.
