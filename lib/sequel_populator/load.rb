# frozen_string_literal: true

module Sequel
  # Module is responsible for housing the functionality to populate a database
  # with seed data, based on either a hash or file path provided.
  module Populator
    require 'json'
    require 'yaml'

    def self.load_seed_data(source)
      return source if source.is_a?(Hash)

      case File.extname(source).downcase
      when '.json'
        JSON.parse File.read(source)
      when '.yml'
        YAML.safe_load File.read(source)
      else
        raise 'Unable to handle source'
      end
    end
  end
end
