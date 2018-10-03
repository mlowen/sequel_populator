require 'json'
require 'yaml'

module Sequel::Populator
  def self.run(db, source)
    Sequel.extension :inflector

    data = _load_data_from source

    db.transaction do
      data.each do |table, entities|
        entities.each do |entity|
          table_sym = table.to_sym
          fields = entity.reject { |field| field.start_with? '$' }

          if data.key? '$refs'
            data['$refs'].each do |ref, ref_fields|
              id = db[ref.pluralize.to_sym].first!(ref_fields)[:id]
              fields[ref.foreign_key.to_sym] = id
            end
          end

          entity = db[table].first fields
          db[table].insert fields if entity.nil?
        end
      end
    end
  end

  def self._load_data_from(source)
    return source if source.is_a? Hash

    case File.extname(source).downcase
    when '.json'
      JSON.parse File.read(source)
    when '.yml'
      YAML.load File.read(source)
    else
      raise 'Unable to handle source'
    end
  end
end
