# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cache_rocket/version'

Gem::Specification.new do |spec|
  spec.name          = "cache_rocket"
  spec.version       = CacheRocket::VERSION
  spec.authors       = ["Tee Parham"]
  spec.email         = ["tee@neighborland.com"]
  spec.description   = %q{Rails rendering extension for server-side html caching}
  spec.summary       = %q{Rails rendering extension for server-side html caching}
  spec.homepage      = "https://github.com/teeparham/cache_rocket"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = `git ls-files -- {test}/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_dependency "actionpack", ">= 3.2"

  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "test-unit", ">= 2.5"
  spec.add_development_dependency "mocha", ">= 0.13"
  spec.add_development_dependency "shoulda-context"
  spec.add_development_dependency "pry", ">= 0.9"
end
