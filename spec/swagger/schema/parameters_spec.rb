RSpec.describe Swagger::Schema::Parameters do
  let(:params) do
    [
      { name: "page", in: "query", schema: { "type" => "integer" } },
      { name: "id", in: "path", schema: { "type" => "integer" } },
      { name: "search", in: "query", schema: { "type" => "string" } },
    ]
  end

  let(:json_schema) do
    {
      "type" => "object",
      "properties" => {
        "page" => { "type" => "integer" },
        "id" => { "type" => "integer" },
        "search" => { "type" => "string", "minLength" => 1 },
      },
      "required" => %w[id],
    }
  end

  let(:json_schema_no_required) do
    {
      "type" => "object",
      "properties" => { "page" => { "type" => "integer" }, "search" => { "type" => "string", "minLength" => 1 } },
    }
  end

  let(:instance) { described_class.new(params) }

  describe ".initialize" do
    subject { instance }

    it_is_asserted_by { subject.size == 3 }
  end

  describe "#query, #path" do
    subject { instance }

    it_is_asserted_by { subject.query.size == 2 }
    it_is_asserted_by { subject.path.size == 1 }
  end

  describe "#[]" do
    subject { instance }

    it_is_asserted_by { subject[1].name == "id" }

    it_is_asserted_by { subject[100].nil? }
  end

  describe "#by_name" do
    subject { instance }

    it_is_asserted_by { subject.by_name("id").name == "id" }

    it_is_asserted_by { subject.by_name(:id).name == "id" }
  end

  describe "#to_json_schema" do
    subject { instance }

    it_is_asserted_by { subject.to_json_schema == json_schema }

    context "no required" do
      it_is_asserted_by { subject.query.to_json_schema == json_schema_no_required }
    end
  end
end
