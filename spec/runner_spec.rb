# frozen_string_literal: true

RSpec.describe Sequel::Populator::Runner do
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

  context 'Entity creation' do
    context 'single entity' do
      it 'will insert when the entity does not already exist' do
        data = { 'item' => { 'slug' => 'foo', 'count' => 1 } }

        Sequel::Populator::Runner.new(@database).run data

        expect(@database[:items].count).to eq 1
        expect(@database[:items].first(slug: 'foo', count: 1).nil?).to be_falsey
      end

      it 'will not insert when the entity already exists' do
        @database[:items].insert slug: 'foo', count: 1

        expect(@database[:items].count).to eq 1

        data = { 'item' => { 'slug' => 'foo', 'count' => 1 } }
        Sequel::Populator::Runner.new(@database).run data

        expect(@database[:items].count).to eq 1
      end
    end

    context 'multiple entities' do
      it 'can insert multiple entities into a table' do
        data = {
          'items' => [
            { 'slug' => 'foo', 'count' => 1 },
            { 'slug' => 'bar', 'count' => 2 }
          ]
        }

        Sequel::Populator::Runner.new(@database).run data

        expect(@database[:items].count).to eq 2
        expect(@database[:items].first(slug: 'foo', count: 1).nil?).to be_falsey
        expect(@database[:items].first(slug: 'bar', count: 2).nil?).to be_falsey
      end

      it 'will only insert new entities if some already exist' do
        data = {
          'items' => [
            { 'slug' => 'foo', 'count' => 1 },
            { 'slug' => 'bar', 'count' => 2 }
          ]
        }

        @database[:items].insert slug: 'foo', count: 1

        expect(@database[:items].count).to eq 1

        Sequel::Populator::Runner.new(@database).run data

        expect(@database[:items].count).to eq 2
        expect(@database[:items].first(slug: 'foo', count: 1).nil?).to be_falsey
        expect(@database[:items].first(slug: 'bar', count: 2).nil?).to be_falsey
      end
    end

    it 'will raise an exception when the table data is not a hash or array' do
      expect do
        Sequel::Populator::Runner.new(@database).run 'item' => 1
      end.to raise_error RuntimeError

      expect do
        Sequel::Populator::Runner.new(@database).run 'item' => true
      end.to raise_error RuntimeError

      expect do
        Sequel::Populator::Runner.new(@database).run 'item' => 'foo'
      end.to raise_error RuntimeError
    end

    it 'will insert data into multiple tables'
  end

  context 'Reference data' do
    it 'will create the referenced entity if it does not exist'
    it 'will use a matching entity if it already exists'
  end
end
