begin
  require 'bundler/gem_tasks'
  # require 'yaml'
  require 'rspec/core/rake_task'
  require 'rake-tomdoc' unless RUBY_PLATFORM == 'java'
rescue LoadError
  abort "Please run `bundle install` first"
end

# load 'vcr/tasks/vcr.rake'

RSpec::Core::RakeTask.new :spec
Bundler::GemHelper.install_tasks

task :default => [:spec]
