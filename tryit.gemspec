# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ['Sergey Gopkalo', 'Michael Kohl']
  gem.email         = ['Sergey.Gopkalo@gmail.com', 'citizen428@gmail.com']
  gem.description   = %q{Try methods without exceptions}
  gem.summary       = %q{An alternative approach to Rails Object#try}
  gem.homepage      = 'https://github.com/citizen428/tryit'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'tryit'
  gem.require_paths = ['lib']
  gem.version       = '1.0'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~>2.9.0'
end
