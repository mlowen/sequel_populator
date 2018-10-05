# frozen_string_literal: true

RSpec.describe 'Sequel::Populator.load_seed_data' do
  it 'will raise an error if the source is not a string or a hash' do
    expect do
      Sequel::Populator.load_seed_data(2)
    end.to raise_error RuntimeError

    expect do
      Sequel::Populator.load_seed_data(true)
    end.to raise_error RuntimeError

    expect do
      Sequel::Populator.load_seed_data([])
    end.to raise_error RuntimeError
  end

  it 'will return a hash if given a hash' do
    data = { 'foo' => 'bar' }

    expect(Sequel::Populator.load_seed_data(data)).to be data
  end

  it 'will throw an exception if the file has an unexpected extension' do
    expect do
      Sequel::Populator.load_seed_data './test.png'
    end.to raise_error RuntimeError
  end

  context 'JSON' do
    it 'will throw an exception if the file does not exist' do
      expect do
        Sequel::Populator.load_seed_data './non-existent.json'
      end.to raise_error RuntimeError
    end

    it 'will return the parsed contents of the file on success'
  end

  context 'YAML' do
    it 'will throw an exception if the file does not exist' do
      expect do
        Sequel::Populator.load_seed_data './non-existent.yaml'
      end.to raise_error RuntimeError
    end

    it 'will return the parsed contents of the file on success'
  end
end
