RSpec.describe Swagger::Schema::RequestBody do
  describe "#content" do
    subject { described_class.new(params).content }

    context "not empty" do
      let(:params) { { content: {} } }

      it_is_asserted_by { subject.is_a?(Swagger::Schema::Content) }
    end

    context "empty" do
      let(:params) { {} }

      it_is_asserted_by { subject.is_a?(Swagger::Schema::Content) }
    end
  end
end
