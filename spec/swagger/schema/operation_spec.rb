RSpec.describe Swagger::Schema::Operation do
  let(:params) { { operationId: "a" } }

  describe ".initialize" do
    subject { described_class.new(params) }

    it_is_asserted_by { subject.operation_id == subject.operationId }
  end
end
