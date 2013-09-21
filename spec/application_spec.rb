require 'hyperloop'

describe Hyperloop::Application do
  before :each do
    @root = 'spec/fixtures/simple/'
    @app  = Hyperloop::Application.new(@root)
  end

  it 'finds the index view' do
    expect(@app.views).to eql(['index.html'])
  end

  it 'responds successfully to a request for root' do
    request = Rack::MockRequest.new(@app)
    response = request.get('/')

    expect(response).to be_ok
    expect(response.body).to match(/<html>/)
  end
end
