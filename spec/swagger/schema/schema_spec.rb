RSpec.describe Swagger::Schema do
  let(:schema) { { components: { FooSpec: { type: :string } } } }

  let(:instance) { described_class.new(schema) }

  describe ".initialize" do
    subject { instance }

    it_is_asserted_by { subject.is_a? described_class }
  end

  describe "#component" do
    subject { instance.component(name) }

    context "string" do
      let(:name) { "FooSpec" }

      it_is_asserted_by { subject.schema == instance.components[:FooSpec] }
    end

    context "class" do
      class FooSpecSerializer; end

      let(:name) { FooSpecSerializer }

      it_is_asserted_by { subject.schema == instance.components[:FooSpec] }
    end
  end
end
