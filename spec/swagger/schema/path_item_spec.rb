RSpec.describe Swagger::Schema::PathItem do
  let(:params) { { get: {} } }

  describe ".initialize" do
    subject { described_class.new(params) }

    it_is_asserted_by { subject.get.is_a? Swagger::Schema::Operation }
    it_is_asserted_by { subject.post.nil? }
    it_is_asserted_by { subject.parameters.empty? }
  end
end
