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

### Rails with swagger-dsl

use "[swagger-dsl](https://github.com/Narazaka/swagger-dsl)"!

Load it in initializer.

```ruby
# config/initializers/swagger_serializer.rb

if Rails.application.config.eager_load
  Swagger::DSL.current.config.lazy_define_paths = true
  Rails.application.config.after_initialize do
    Rails.application.reload_routes!
    Swagger::DSL.current.define_paths!
    Swagger::Schema.current = Swagger::Schema.new(Swagger::DSL.current.resolved)
  end
else
  Swagger::Schema.current = Swagger::Schema.new(Swagger::DSL.current)
  Swagger::Serializer::Store.current.serialize_options[:resolver] = Swagger::DSL.current.resolver
  Swagger::Serializer::Store.current.deserialize_options[:resolver] = Swagger::DSL.current.resolver
end
```

Use it in controllers.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Swagger::Serializer::RailsController
  extend Swagger::DSL::RailsController

  def render_ok(data, context = nil)
    render_as_schema 200, :json, data, context
  end

  def render_bad(data, context = nil)
    render_as_schema 400, :json, data, context
  end
end
```

```ruby
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  swagger :index do
    render 200 do
      array! { cref! UserSerializer }
    end
  end
  def index
    render_ok User.all
  end

  swagger :show do
    params do
      path :id, schema: :integer
    end

    render 200 do
      cref! UserSerializer
    end
  end
  def show
    render_ok User.find(schema_params[:id])
  end

  swagger :create do
    body format: [:form, :json] do
      user :object do
        name :string
      end
    end
    
    render 200 do
      cref! UserSerializer
    end
    render 400 do
      additionalProperties! do
        array! { string! }
      end
    end
  end
  def create
    @user = User.new(schema_params[:user])

    if @user.save
      render_ok @user
    else
      render_bad @user.errors
    end
  end

  swagger :update do
    params do
      path :id, schema: :string
    end

    body format: [:form, :json] do
      user :object do
        name :string
      end
    end
    
    render 200 do
      cref! UserSerializer
    end
    render 400 do
      additionalProperties! do
        array! { string! }
      end
    end
  end
  def update
    @user = User.find(schema_params[:id])

    if @user.update(schema_params[:user])
      render_ok @user
    else
      render_bad @user.errors
    end
  end

  swagger :destroy do
    params do
      path :id, schema: :string
    end
  end
  def destroy
    @user.destroy!
    head :no_content
  end
end
```

Would you want to customize serialization?

```ruby
# app/serializers/base_serializer.rb
class BaseSerializer
  include Swagger::Serializer
  extend Swagger::DSL::Serializer
end
```

```ruby
# app/serializers/user_serializer.rb
class UserSerializer < BaseSerializer
  swagger do
    id :integer
    name :string, optional: true
  end

  def name
    "#{@model.name}!!!!"
  end
end
```

Now you can get `{ "id" => 42, "name" => "me!!!!" }`.

This serializer class detection uses the schema's `title` key.
If you want to use `Foo::BarSerializer`, set `Foo::Bar` to `title` key.

The key is configurable by

```ruby
# in config/initializers/swagger_serializer.rb
Swagger::Serializer::Store.current.serialize_options[:inject_key] = "my_inject_key"
Swagger::Serializer::Store.current.deserialize_options[:inject_key] = "my_inject_key"
Swagger::DSL.current.config.inject_key = "my_inject_key"
```

Sometimes model needs direct serialize.

```ruby
# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  include Swagger::Serializer::Model
end
```

Now you can get serialized result by `p User.first.serialize`.

### Rails with raw schema

Write your OpenAPI spec.

```yaml
# swagger.yml
openapi: 3.0.0
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
```

Use it in controllers.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Swagger::Serializer::RailsController

  def render_ok(data, context = nil)
    render_as_schema 200, :json, data, context
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

Sometimes model needs direct serialize.

```ruby
# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  include Swagger::Serializer::Model
end
```

Now you can get serialized result by `p User.first.serialize`.

### @context

Collection serialization sometimes needs context data for avoiding N+1 access or some other reason.

`render_as_schema`'s 4th parameter is the context that will be passed to serializers `@context`.

```ruby
# app/serializers/item_serializer.rb
class ItemSerializer < BaseSerializer
  swagger do
    id :integer
    rate :integer
  end

  def rate
    @context[:rates][id]
  end
end

# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  swagger :index do
    render 200 do
      array! do
        cref! ItemSerializer
      end
    end
  end

  def index
    items = Item.all
    rates = ItemRate.calc_item_rates(items)
    render_ok items, { rates: rates }
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Narazaka/swagger-serializer.
