# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'

SimpleCov.start do
  minimum_coverage 90

  add_filter '/spec/'
end

require 'sequel_populator'

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
