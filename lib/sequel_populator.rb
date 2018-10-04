# frozen_string_literal: true

require 'sequel'

require 'json'
require 'yaml'

module Sequel
  # This class is responsible for the runner to populate the database with
  # seed/dev/test data
  class Populator
    VERSION = '0.1.0'

    def initialize(database, source)
      Sequel.extension :inflector

      @database = database
      @source = source
    end

    def run
      @database.transaction do
        seed_data.each { |table, entities| process_table(table, entities) }
      end
    end

    def self.run(database, source)
      new(database, source).run
    end

    private

    def process_table(table, entity)
      if entity.is_a? Hash
        table_name = table.tableize.to_sym
        fields = {}

        entity.reject { |field| field.start_with?('$') }
              .merge(fetch_references(entity))
              .each { |k, v| fields[k.to_sym] = v }

        create_unless_exists(table_name, fields)
      elsif entity.is_a? Array
        entity.each { |item| process_table(table, item) }
      else
        raise "Unexpected value for #{table}"
      end
    end

    def fetch_references(entity)
      references = {}

      if entity.key?('$refs')
        entity['$refs'].each do |ref, ref_fields|
          id = @database[ref.pluralize.to_sym].first!(ref_fields)[:id]
          references[ref.foreign_key.to_sym] = id
        end
      end

      references
    end

    def create_unless_exists(table, fields)
      existing = @database[table].first(fields)
      @database[table].insert(fields) if existing.nil?
    end

    def seed_data
      return @source if @source.is_a?(Hash)

      case File.extname(@source).downcase
      when '.json'
        JSON.parse File.read(@source)
      when '.yml'
        YAML.safe_load File.read(@source)
      else
        raise 'Unable to handle source'
      end
    end
  end
end
