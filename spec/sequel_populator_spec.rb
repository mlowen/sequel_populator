# frozen_string_literal: true

RSpec.describe Sequel::Populator do
  # Hooks
  before(:each) do
    @database = Sequel.sqlite
    @database.create_table :items do
      primary_key :id

      String :slug
      Integer :count
    end
  end

  after(:each) do
    @database.disconnect
  end

  # Version
  it 'has a version number' do
    expect(Sequel::Populator::VERSION).not_to be nil
  end

  it 'will load data from a Hash'
  it 'will load data from a YAML file'
  it 'will load data from a JSON file'
end
