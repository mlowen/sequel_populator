# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequel_populator'

Gem::Specification.new do |spec|
  spec.name          = 'sequel_populator'
  spec.version       = Sequel::Populator::VERSION
  spec.authors       = ['Mike Lowen']
  spec.email         = ['mike@mlowen.com']

  spec.summary       = 'A dev/test data seeding tool for the Sequel ruby ORM'
  spec.homepage      = 'https://github.com/mlowen/sequel_populator'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  #  to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'TODO: Set to http://mygemserver.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against'  \
      'public gem pushes.'
  end

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

  spec.add_dependency 'sequel', '~> 5.13'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.59.2'
  spec.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.13'
end