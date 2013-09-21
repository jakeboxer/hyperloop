require 'hyperloop'

describe Hyperloop::Application do
  before :all do
    @root = 'spec/fixtures/simple/'
  end

  it 'finds the index view' do
    app = Hyperloop::Application.new(@root)
    expect(app.views).to eql(['index.html'])
  end
end
