RSpec.describe Swagger::Schema::Header do
  let(:params) { { schema: { "type" => "string" } } }

  describe ".initialize" do
    subject { described_class.new(params) }

    it_is_asserted_by { subject.to_json_schema == { "type" => "string" } }
  end
end
