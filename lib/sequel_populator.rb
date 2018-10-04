# frozen_string_literal: true

require 'sequel_populator/runner'
require 'sequel_populator/version'

module Sequel
  # Module is responsible for housing the functionality to populate a database
  # with seed data, based on either a hash or file path provided.
  module Populator
    def self.run(database, source)
      Sequel::Populator::Runner.new(database, source).run
    end
  end
end
