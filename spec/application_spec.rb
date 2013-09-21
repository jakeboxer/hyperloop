require 'hyperloop'

describe Hyperloop::Application do
  before :each do
    @root = 'spec/fixtures/simple/'
    @app  = Hyperloop::Application.new(@root)
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

  it '404s on a request for a nonexistent page' do
    request = Rack::MockRequest.new(@app)
    response = request.get('/nonexistent')

    expect(response).to be_not_found
  end
end
