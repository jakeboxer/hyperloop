require 'hyperloop'

describe Hyperloop::Application do
  before :each do
    @root = 'spec/fixtures/simple/'
    @app  = Hyperloop::Application.new(@root)
  end

  it 'finds the index view' do
    expect(@app.views).to match_array(%w(index.html about.html))
  end

  it 'responds successfully to a request for root' do
    request = Rack::MockRequest.new(@app)
    response = request.get('/')

    expect(response).to be_ok
    expect(response.body).to match(/<h1>Simple/)
  end

  it 'responds successfully to a request for a different page' do
    request = Rack::MockRequest.new(@app)
    response = request.get('/about')

    expect(response).to be_ok
    expect(response.body).to match(/<h1>About/)
  end
end
