RSpec.describe Swagger::Schema::Parameter do
  let(:params) { { name: "foo", in: "path", schema: { "type" => "string" } } }

  describe ".initialize" do
    subject { described_class.new(params) }

    it_is_asserted_by { subject.name == "foo" }
    it_is_asserted_by { subject.in == "path" }
    it_is_asserted_by { subject.path? == true }
    it_is_asserted_by { subject.query? == false }
    it_is_asserted_by { subject.to_json_schema == { "type" => "string" } }
  end
end
