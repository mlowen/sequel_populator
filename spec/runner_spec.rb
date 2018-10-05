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

    @database.create_table :other_items do
      primary_key :id

      String :slug
      Integer :count
    end

    @database.create_table :sub_items do
      primary_key :id

      String :slug
      Integer :count
      foreign_key :item_id, :items
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
        expect(@database[:items].first(slug: 'foo', count: 1)).to_not be_nil
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
        expect(@database[:items].first(slug: 'foo', count: 1)).to_not be_nil
        expect(@database[:items].first(slug: 'bar', count: 2)).to_not be_nil
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
        expect(@database[:items].first(slug: 'foo', count: 1)).to_not be_nil
        expect(@database[:items].first(slug: 'bar', count: 2)).to_not be_nil
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

    it 'will insert data into multiple tables' do
      data = {
        'items' => [{ 'slug' => 'foo', 'count' => 1 }],
        'other_items' => [{ 'slug' => 'bar', 'count' => 2 }]
      }

      Sequel::Populator::Runner.new(@database).run data

      expect(@database[:items].first(slug: 'foo', count: 1)).to_not be_nil
      expect(@database[:other_items].first(slug: 'bar', count: 2)).to_not be_nil
    end
  end

  context 'Reference data' do
    it 'will create the referenced entity if it does not exist' do
      data = {
        'sub_items' => [
          {
            'slug' => 'foo',
            'count' => 1,
            '$refs': {
              'item' => { 'slug' => 'bar', 'count' => 2 }
            }
          }
        ]
      }

      Sequel::Populator::Runner.new(@database).run data

      item = @database[:items].first(slug: 'bar', count: 2)
      sub_item = @database[:sub_items].first(slug: 'foo', count: 1,
                                             item_id: item[:id])

      expect(item).to_not be_nil
      expect(sub_item).to_not be_nil
    end

    it 'will use a matching entity if it already exists' do
      # Inserting two items so that the id isn't 1
      @database[:items].insert slug: 'foo', count: 1
      ref_id = @database[:items].insert slug: 'bar', count: 2

      data = {
        'sub_items' => [
          {
            'slug' => 'tar',
            'count' => 3,
            '$refs': {
              'item' => { 'slug' => 'bar', 'count' => 2 }
            }
          }
        ]
      }

      Sequel::Populator::Runner.new(@database).run data

      item = @database[:sub_items].first slug: 'tar', count: 3, item_id: ref_id
      expect(item).to_not be_nil
    end
  end
end
