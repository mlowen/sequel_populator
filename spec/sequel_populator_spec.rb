# frozen_string_literal: true

RSpec.describe Sequel::Populator do
  # Pre & Post hooks
  before(:each) do
    @database = Sequel.sqlite
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
      it 'will insert when the entity does not already exist'
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
