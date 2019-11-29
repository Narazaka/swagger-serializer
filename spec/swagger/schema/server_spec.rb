RSpec.describe Swagger::Schema::Server do
  let(:params) { { url: url, description: description, variables: variables } }
  let(:url) { "https://example.com/{root}/{id}" }
  let(:description) { "example!" }
  let(:variables) { { root: { default: "users" }, id: {} } }

  describe ".initialize" do
    subject { described_class.new(params) }

    it_is_asserted_by { subject.url == url }
    it_is_asserted_by { subject.description == description }
    it_is_asserted_by { subject.variables == variables }
  end

  describe "#complete_url" do
    subject { described_class.new(params).complete_url(url_variables) }

    context "full" do
      let(:url_variables) { { root: "items", id: "1" } }

      it_is_asserted_by { subject == "https://example.com/items/1" }
    end

    context "partial" do
      let(:url_variables) { { id: "2" } }

      it_is_asserted_by { subject == "https://example.com/users/2" }
    end
  end
end
