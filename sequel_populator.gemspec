# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequel_populator/version'

Gem::Specification.new do |spec|
  spec.name          = 'sequel_populator'
  spec.version       = Sequel::Populator::VERSION
  spec.authors       = ['Mike Lowen']
  spec.email         = ['mike@mlowen.com']

  spec.summary       = 'A dev/test data seeding tool for the Sequel ruby ORM'
  spec.homepage      = 'https://github.com/mlowen/sequel_populator'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'sequel', '~> 5.19'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.59.2'
  spec.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.13'
end
