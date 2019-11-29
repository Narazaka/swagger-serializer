RSpec.describe Swagger::Schema::Component do
  let(:schema) { { type: :object, properties: { id: { type: :integer }, name: { type: :string } }, required: %i[id] } }

  let(:instance) { described_class.new(schema) }

  describe ".initialize" do
    subject { instance }

    it_is_asserted_by { subject.is_a? described_class }
  end

  describe "#serializer" do
    subject { instance.serializer }

    context "full data" do
      let(:data) { { id: 42, name: "foo" } }

      it_is_asserted_by { subject.serialize(data) == { "id" => 42, "name" => "foo" } }
    end
  end
end
