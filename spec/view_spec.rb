require File.expand_path('../spec_helper', __FILE__)

describe Hyperloop::View do
  before :each do
    @html_view = Hyperloop::View.new('spec/fixtures/simple/app/views/about.html')
    @erb_view  = Hyperloop::View.new('spec/fixtures/erb/app/views/about.html.erb')
  end

  describe '#format' do
    it 'is :html for HTML files' do
      expect(@html_view.format).to eql(:html)
    end

    it 'is :erb for ERB files' do
      expect(@erb_view.format).to eql(:erb)
    end
  end

  describe '#name' do
    it 'strips the extension from plain HTML files' do
      expect(@html_view.name).to eql('about')
    end

    it 'strips the extension from ERB files' do
      expect(@erb_view.name).to eql('about')
    end
  end

  describe '#render' do
    it 'renders plain HTML files' do
      expect(@html_view.render).to match(/<h1>About/)
    end

    it 'renders ERB files' do
      expect(@erb_view.render).to match(/<h1>I was born on December 21/)
    end
  end
end
