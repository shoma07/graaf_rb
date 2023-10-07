# frozen_string_literal: true

require_relative '../example/example'

RSpec.describe Graaf::Library do
  it do
    expect(Example.add(1, 2)).to eq 3
  end
end
