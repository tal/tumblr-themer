# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tumblr-themer/version'

Gem::Specification.new do |spec|
  spec.name          = "tumblr-themer"
  spec.version       = TumblrThemer::VERSION
  spec.authors       = ["Tal Atlas"]
  spec.email         = ["me@tal.by"]
  spec.description   = %q{A tool for building tumblr themes}
  spec.summary       = %q{A tool for building tumblr themes}
  spec.homepage      = "https://github.com/tal/tumblr-themer"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "url"
  spec.add_dependency "sinatra"
  spec.add_dependency "json"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
