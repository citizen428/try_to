
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'try_to/version'

Gem::Specification.new do |spec|
  spec.name          = 'try_to'
  spec.version       = TryTo::VERSION
  spec.authors       = ['Michael Kohl']
  spec.email         = ['citizen428@gmail.com']

  spec.summary       = "An alternative approach to Rails' Object#try"
  spec.description   = 'Try methods without exceptions'
  spec.homepage      = 'https://github.com/citizen428/try_to'
  spec.license       = 'MIT'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/citizen428/try_to/issues',
    'source_code_uri' => 'https://github.com/citizen428/try_to'
  }

  spec.files = `git ls-files -z *.md LICENSE.txt lib`.split("\0")
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 2.2.33'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '>= 12.3.3'
end
