require 'hyperloop'

describe Hyperloop::View do
  describe '#name' do
    it 'strips the extension from plain HTML files' do
      view = Hyperloop::View.new('spec/fixtures/simple/app/views/about.html')
      expect(view.name).to eql('about')
    end

    it 'strips the extension from ERB files' do
      view = Hyperloop::View.new('spec/fixtures/erb/app/views/about.html.erb')
      expect(view.name).to eql('about')
    end
  end

  describe '#render' do
    it 'renders plain HTML files' do
      view = Hyperloop::View.new('spec/fixtures/simple/app/views/index.html')
      expect(view.render).to match(/<h1>Simple/)
    end

    it 'renders ERB files' do
      view = Hyperloop::View.new('spec/fixtures/erb/app/views/index.html.erb')
      expect(view.render).to match(/<h1>WE ARE USING ERB/)
    end
  end
end
