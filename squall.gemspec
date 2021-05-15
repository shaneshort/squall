# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "squall/support/version"

Gem::Specification.new do |s|
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.name        = "squall"
  s.version     = Squall::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Justin Mazzi", "Shane Short"]
  s.email       = ["jmazzi@site5.com", "shanes@webinabox.net.au"]
  s.homepage    = ""
  s.summary     = %q{A Ruby library for working with the OnApp REST API}
  s.description = %q{A Ruby library for working with the OnApp REST API}
  s.license     = 'MIT'

  s.rubyforge_project = "squall"

  s.add_runtime_dependency 'faraday', '~> 1.3.0'
  s.add_runtime_dependency 'faraday_middleware', '~> 1.0.0'
  s.add_runtime_dependency 'json', '~> 2.1'
  s.add_runtime_dependency('jruby-openssl', '~> 0.7.3') if RUBY_PLATFORM == 'java'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'rake'

  # JRuby
  if RUBY_PLATFORM == 'java'
    s.add_runtime_dependency 'jruby-openssl', '~> 0.7.3'
  else
    s.add_development_dependency 'rake-tomdoc', '~> 0.0.2'
  end

  s.files       += %w[Gemfile LICENSE Rakefile README.md]
  s.files       += Dir['{lib,spec}/**/*']
  s.test_files   = Dir['spec/**/*']
end
