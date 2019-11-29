RSpec.describe Swagger::Schema::Headers do
  let(:params) { { "X-Face": { schema: { "type" => "integer" } } } }

  let(:json_schema) { { "type" => "object", "properties" => { "X-Face" => { "type" => "integer" } } } }

  let(:instance) { described_class.new(params) }

  describe "#[]" do
    subject { instance }

    it_is_asserted_by { subject["X-Face"].schema["type"] == "integer" }

    it_is_asserted_by { subject["X-Foo"].nil? }
  end

  describe "#to_json_schema" do
    subject { instance.to_json_schema }

    it_is_asserted_by { subject == json_schema }
  end
end
