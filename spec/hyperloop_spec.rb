require 'hyperloop'

describe Hyperloop::Response do
  it 'has a body' do
    response = Hyperloop::Response.new('irrelevant')
    expect(response.body).not_to be_empty
  end
end
