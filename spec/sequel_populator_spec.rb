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

  context 'Entity creation' do
    context 'single entity' do
      it 'will insert when the entity does not already exist' do
        data = { 'items' => [ { 'slug' => 'foo', 'count' => 1 } ] }

        Sequel::Populator.run @database, data

        expect(@database[:items].count).to eq 1

        row = @database[:items].first

        expect(row[:slug]).to eq 'foo'
        expect(row[:count]).to eq 1
      end

      it 'will not insert when the entity already exists'
    end

    context 'multiple entities' do
      it 'can insert multiple entities into a table'
      it 'will only insert new entities if some already exist'
    end

    it 'will insert data into multiple tables'
  end

  context 'Reference data' do
    it 'will create the referenced entity if it does not exist'
    it 'will use a matching entity if it already exists'
  end

  context 'External data' do
    it 'will load data from a JSON file'
    it 'will load data from a YAML file'
  end
end
