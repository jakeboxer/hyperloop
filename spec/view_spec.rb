require 'hyperloop'

describe Hyperloop::View do
  it 'renders plain html files' do
    view = Hyperloop::View.new('spec/fixtures/simple/app/views/index.html')
    expect(view.render).to match(/<h1>Simple/)
  end
end
