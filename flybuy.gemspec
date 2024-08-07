# frozen_string_literal: true

require_relative 'lib/flybuy/version'

Gem::Specification.new do |spec|
  spec.name          = 'flybuy'
  spec.version       = Flybuy::VERSION
  spec.authors       = ['Keith Yoder']
  spec.email         = ['keith@radiusnetworks.com']

  spec.summary       = 'Gem to access the Flybuy Pickup API.'
  spec.description   = 'Longer Description.'
  spec.homepage      = 'https://github.com/keithyoder/ruby-flybuy-api'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/keithyoder/ruby-flybuy-api'
  spec.metadata['changelog_uri'] = 'https://github.com/keithyoder/ruby-flybuy-api/README.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'activemodel'
  spec.add_dependency 'biz'
end
