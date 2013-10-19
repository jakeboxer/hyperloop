describe Hyperloop::View::Scope do
  before :each do
    @request = Rack::MockRequest.new(mock_app)
    @scope   = Hyperloop::View::Scope.new(@request)
  end

  describe "#request" do
    it "is the request that the scope will be used in response to" do
      expect(@scope.request).to eql(@request)
    end
  end
end
