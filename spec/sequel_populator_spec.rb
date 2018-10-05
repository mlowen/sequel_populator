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

  it 'will load data from a Hash' do
    data = { 'items' => [{ 'slug' => 'foo', 'count' => 1 }] }
    Sequel::Populator.run(@database, data)

    expect(@database[:items].first(slug: 'foo', count: 1)).to_not be_nil
  end

  it 'will load data from a YAML file' do
    fixture = File.expand_path('fixtures/data.json', __dir__)
    Sequel::Populator.run(@database, fixture)

    expect(@database[:items].first(slug: 'foo', count: 1)).to_not be_nil
  end

  it 'will load data from a JSON file' do
    fixture = File.expand_path('fixtures/data.yml', __dir__)
    Sequel::Populator.run(@database, fixture)

    expect(@database[:items].first(slug: 'bar', count: 2)).to_not be_nil
  end
end
