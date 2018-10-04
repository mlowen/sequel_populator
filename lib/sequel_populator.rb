# frozen_string_literal: true

require 'sequel_populator/runner'
require 'sequel_populator/version'

module Sequel
  module Populator
    def self.run(database, source)
      Sequel::Populator::Runner.new(database, source).run
    end
  end
end
