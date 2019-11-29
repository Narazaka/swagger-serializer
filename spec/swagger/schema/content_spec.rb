RSpec.describe Swagger::Schema::Content do
  let(:schema) { { "application/json": { schema: { type: "object", properties: { id: { type: "integer" } } } } } }

  let(:instance) { described_class.new(schema) }

  describe "#[]" do
    subject { instance[type] }

    context "json" do
      let(:type) { "application/json" }

      it_is_asserted_by { subject.schema[:type] == "object" }
    end

    context "xml" do
      let(:type) { "application/xml" }

      it_is_asserted_by { subject.nil? }
    end

    context "null schema" do
      let(:schema) { nil }
      let(:type) { "application/json" }

      it_is_asserted_by { subject.nil? }
    end
  end

  describe "#json" do
    subject { instance.json }

    it_is_asserted_by { subject.schema[:type] == "object" }
  end

  describe "#xml" do
    subject { instance.xml }

    it_is_asserted_by { subject.nil? }
  end

  describe "#plain" do
    subject { instance.plain }

    it_is_asserted_by { subject.nil? }
  end
end
