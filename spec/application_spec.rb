require 'hyperloop'

describe Hyperloop::Application do
  describe 'with a flat views directory' do
    before :each do
      @app     = Hyperloop::Application.new('spec/fixtures/simple/')
      @request = Rack::MockRequest.new(@app)
    end

    it 'responds successfully to a request for root' do
      response = @request.get('/')

      expect(response).to be_ok
      expect(response.body).to match(/<h1>Simple/)
    end

    it 'responds successfully to a request for a different page' do
      response = @request.get('/about')

      expect(response).to be_ok
      expect(response.body).to match(/<h1>About/)
    end

    it '404s on a request for a nonexistent page' do
      response = @request.get('/nonexistent')

      expect(response).to be_not_found
    end
  end
end
