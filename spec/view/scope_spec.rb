describe Hyperloop::View::Scope do
  before :each do
    view_registry = Hyperloop::View::Registry.new("spec/fixtures/partials/")
    @request      = mock_request
    @scope        = Hyperloop::View::Scope.new(@request, view_registry)
  end

  describe "#request" do
    it "is the request that the scope will be used in response to" do
      expect(@scope.request).to eql(@request)
    end
  end

  describe "#render" do
    it "renders the specified partial" do
      html = @scope.render("subdir/partial")

      expect(text_in(html, "p")).to eql("This is coming from a partial.")
    end
  end
end
