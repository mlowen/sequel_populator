# frozen_string_literal: true

RSpec.describe Sequel::Populator do
  it 'will raise an error if the source is not a string or a hash' do
    expect { Sequel::Populator.load_seed_data(2) }.to raise_error RuntimeError
    expect { Sequel::Populator.load_seed_data(true) }.to raise_error RuntimeError
    expect { Sequel::Populator.load_seed_data([]) }.to raise_error RuntimeError
  end

  it 'will return a hash if given a hash' do
    data = { 'foo' => 'bar' }

    expect(Sequel::Populator.load_seed_data(data)).to be data
  end

  it 'will throw an exception if the file has an unexpected extension'
  it 'will throw an exception if the JSON file does not exist'
  it 'will throw an exception if the YAML file does not exist'
end
