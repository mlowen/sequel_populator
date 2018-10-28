# frozen_string_literal: true

module Sequel
  # Module is responsible for housing the functionality to populate a database
  # with seed data, based on either a hash or file path provided.
  module Populator
    require 'sequel'

    # This class is responsible for populating the database.
    class Runner
      def initialize(database)
        Sequel.extension :inflector

        @database = database
      end

      def run(data)
        @database.transaction do
          data.each { |table, entities| populate_table(table, entities) }
        end
      end

      private

      def populate_table(table, entity)
        if entity.is_a? Hash
          fetch_or_create(table, entity)
        elsif entity.is_a? Array
          entity.each { |item| populate_table(table, item) }
        else
          raise "Unexpected value for #{table}"
        end
      end

      def populate_references(entity)
        references = {}
        key = :$refs if entity.key?(:$refs)
        key = '$refs' if entity.key?('$refs')

        unless key.nil?
          entity[key].each do |ref, fields|
            references[ref.foreign_key.to_sym] = fetch_or_create(ref, fields)
          end
        end

        references
      end

      def fetch_or_create(table, entity)
        fields = populate_references(entity)
        table_name = table.tableize.to_sym

        entity.each do |k, v|
          fields[k.to_sym] = v unless k.to_s.start_with?('$')
        end

        existing = @database[table_name].first(fields)
        existing.nil? ? @database[table_name].insert(fields) : existing[:id]
      end
    end
  end
end
