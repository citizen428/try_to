require 'rspec/core/rake_task'
require 'fileutils'
GEMSPEC = 'tryit.gemspec'

task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = '--format documentation'
end

def gemspec
  @gemspec ||= eval(File.read(GEMSPEC), binding, GEMSPEC)
end

namespace :gem do
  desc "Build the gem"
  task :build => :generate_gemspec do
    sh "gem build #{GEMSPEC}"
    FileUtils.mkdir_p 'pkg'
    FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", 'pkg'
  end

  desc "Install the gem locally (without docs)"
  task :install => :build do
    sh %{gem install pkg/#{gemspec.name}-#{gemspec.version} --no-rdoc --no-ri}
  end

  desc "Generate the gemspec"
  task :generate_gemspec do
    puts gemspec.to_ruby
  end

  desc "Validate the gemspec"
  task :validate_gemspec do
    gemspec.validate
  end
end
