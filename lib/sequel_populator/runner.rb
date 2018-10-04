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
          fields = {}
          entity.each { |k, v| fields[k.to_sym] = v unless k.start_with?('$') }

          create_unless_exists(table.tableize.to_sym,
                               fields.merge(populate_references(entity)))
        elsif entity.is_a? Array
          entity.each { |item| populate_table(table, item) }
        else
          raise "Unexpected value for #{table}"
        end
      end

      def populate_references(entity)
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
    end
  end
end
