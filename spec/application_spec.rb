require File.expand_path('../spec_helper', __FILE__)

describe Hyperloop::Application do
  describe 'with a flat views directory' do
    before :each do
      @app     = Hyperloop::Application.new('spec/fixtures/simple/')
      @request = Rack::MockRequest.new(@app)
    end

    it 'responds successfully to a request for root' do
      response = @request.get('/')

      expect(response).to be_ok
      expect(text_in(response.body, 'h1')).to eql('Simple')
    end

    it 'responds successfully to a request for a different page' do
      response = @request.get('/about')

      expect(response).to be_ok
      expect(text_in(response.body, 'h1')).to eql('About')
    end

    it 'responds successfully to a request with a trailing slash' do
      response = @request.get('/about/')

      expect(response).to be_ok
      expect(text_in(response.body, 'h1')).to eql('About')
    end

    it '404s on a request for a nonexistent page' do
      response = @request.get('/nonexistent')

      expect(response).to be_not_found
    end
  end

  describe 'with subdirectories' do
    before :each do
      @app     = Hyperloop::Application.new('spec/fixtures/subdirectories/')
      @request = Rack::MockRequest.new(@app)
    end

    it 'responds successfully to a request for the subdirectory root' do
      response = @request.get('/subdir1')

      expect(response).to be_ok
      expect(text_in(response.body, 'h1')).to eql('Subdirectory Index')
    end

    it 'responds successfully to a request for a different page in the subdirectory' do
      response = @request.get('/subdir1/kanye')

      expect(response).to be_ok
      expect(text_in(response.body, 'h1')).to eql('Hurry up with my damn croissant')
    end
  end

  describe 'with ERB' do
    before :each do
      @app     = Hyperloop::Application.new('spec/fixtures/erb/')
      @request = Rack::MockRequest.new(@app)
    end

    it 'renders embedded Ruby in the root page' do
      response = @request.get('/')

      expect(response).to be_ok
      expect(text_in(response.body, 'h1')).to eql('WE ARE USING ERB')
    end
  end

  describe 'with a layout' do
    before :each do
      @app     = Hyperloop::Application.new('spec/fixtures/layouts/')
      @request = Rack::MockRequest.new(@app)
    end

    it 'renders the root view within the layout' do
      response = @request.get('/')

      expect(response).to be_ok
      expect(text_in(response.body, 'h1')).to eql('Layout Header')
      expect(text_in(response.body, 'h2')).to eql('This is the root page!')
    end

    it 'renders subdirectory views within the layout' do
      response = @request.get('/subdir')

      expect(response).to be_ok
      expect(text_in(response.body, 'h1')).to eql('Layout Header')
      expect(text_in(response.body, 'h2')).to eql('This is a page in a subdirectory!')
    end
  end

  describe 'with assets' do
    before :each do
      @app     = Hyperloop::Application.new('spec/fixtures/assets/')
      @request = Rack::MockRequest.new(@app)
    end

    it 'responds successfully to a request for root' do
      response = @request.get('/')

      expect(response).to be_ok
      expect(text_in(response.body, 'h1')).to eql('This app has so many assets')
    end

    it 'responds successfully to a request for the css app bundle' do
      response = @request.get('/assets/app.css')

      expect(response).to be_ok
      expect(response.body).to match(/display: block;/)
    end

    it 'responds successfully to a request for the javascript app bundle' do
      response = @request.get('/assets/app.js')

      expect(response).to be_ok
      expect(response.body).to match(/alert\("such javascript wow"\);/)
    end

    it '404s on a request for a nonexistent asset' do
      response = @request.get('/assets/nonexistent.js')
      expect(response).to be_not_found
    end
  end
end
