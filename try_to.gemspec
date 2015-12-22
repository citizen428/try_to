# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ['Michael Kohl']
  gem.email         = ['citizen428@gmail.com']
  gem.description   = %q{Try methods without exceptions}
  gem.summary       = %q{An alternative approach to Rails' Object#try}
  gem.homepage      = 'https://github.com/citizen428/try_to'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'try_to'
  gem.require_paths = ['lib']
  gem.version       = '1.1'
  gem.license       = "MIT"

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~>2.9.0'
end
