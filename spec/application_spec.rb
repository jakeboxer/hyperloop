require 'hyperloop'

describe Hyperloop::Application do
  before :each do
    @root = 'spec/fixtures/simple/'
    @app  = Hyperloop::Application.new(@root)
  end

  it 'finds the index view' do
    expect(@app.views).to eql(['index.html'])
  end
end
