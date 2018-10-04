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

  it 'will throw an exception if the seed data is not a string or a hash'

  context 'Entity creation' do
    context 'single entity' do
      it 'will insert when the entity does not already exist' do
        data = { 'item' => { 'slug' => 'foo', 'count' => 1 } }

        Sequel::Populator.run @database, data

        expect(@database[:items].count).to eq 1

      end

      it 'will not insert when the entity already exists' do
        @database[:items].insert slug: 'foo', count: 1

        expect(@database[:items].count).to eq 1

        data = { 'item' => { 'slug' => 'foo', 'count' => 1 } }
        Sequel::Populator.run @database, data

        expect(@database[:items].count).to eq 1
      end
    end

    context 'multiple entities' do
      it 'can insert multiple entities into a table' do
        data = {
          'item' => [
            { 'slug' => 'foo', 'count' => 1 },
            { 'slug' => 'bar', 'count' => 2 }
          ]
        }

        Sequel::Populator.run @database, data

        expect(@database[:items].count).to eq 2
        expect(@database[:items].first(slug: 'foo', count: 1).nil?).to be_falsey
        expect(@database[:items].first(slug: 'bar', count: 2).nil?).to be_falsey
      end

      it 'will only insert new entities if some already exist' do
        data = {
          'item' => [
            { 'slug' => 'foo', 'count' => 1 },
            { 'slug' => 'bar', 'count' => 2 }
          ]
        }

        @database[:items].insert slug: 'foo', count: 1

        expect(@database[:items].count).to eq 1

        Sequel::Populator.run @database, data

        expect(@database[:items].count).to eq 2
        expect(@database[:items].first(slug: 'foo', count: 1).nil?).to be_falsey
        expect(@database[:items].first(slug: 'bar', count: 2).nil?).to be_falsey
      end
    end

    it 'will raise an exception when the value for a table is not a hash or array'
    it 'will insert data into multiple tables'
  end

  context 'Reference data' do
    it 'will create the referenced entity if it does not exist'
    it 'will use a matching entity if it already exists'
  end

  context 'External data' do
    it 'will throw an exception if the file has an unexpect extension'

    context 'json' do
      it 'will load data from a file'
      it 'will throw an exception if the file does not exist'
      it 'will throw an exception if the content is not a hash'
    end

    context 'YAML' do
      it 'will load data from a file'
      it 'will throw an exception if the file does not exist'
      it 'will throw an exception if the content is not a hash'
    end
  end
end
