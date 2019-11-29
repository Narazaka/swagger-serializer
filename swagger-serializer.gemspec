lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "swagger/serializer/version"

Gem::Specification.new do |spec|
  spec.name = "swagger-serializer"
  spec.version = Swagger::Serializer::VERSION
  spec.authors = %w[Narazaka]
  spec.email = %w[info@narazaka.net]
  spec.licenses = %w[Zlib]

  spec.summary = "Swagger (OpenAPI 3) schema based Serializer"
  spec.homepage = "https://github.com/Narazaka/swagger-serializer"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/Narazaka/swagger-serializer.git"
    spec.metadata["changelog_uri"] = "https://github.com/Narazaka/swagger-serializer/blob/master/CHANGELOG.md"
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(File.expand_path("..", __FILE__)) do
      `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
    end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency "json-schema-serializer", "~> 1.2"
  spec.add_dependency "snake_camel", "~> 1.1"
  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", "~> 10.5"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "rspec-power_assert", "~> 1.1"
  spec.add_development_dependency "rubocop", "~> 0.76"
  spec.add_development_dependency "rubocop-airbnb", "~> 3"
  spec.add_development_dependency "prettier", ">= 0.16"
  spec.add_development_dependency "rubocop-config-prettier", "~> 0.1"
  spec.add_development_dependency "pry-byebug", "~> 3.7"
  spec.add_development_dependency "yard", "~> 0.9"
end
