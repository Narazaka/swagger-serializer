RSpec.describe Swagger::Serializer do
  it "has a version number" do
    is_asserted_by { !Swagger::Serializer::VERSION.nil? }
  end
end
