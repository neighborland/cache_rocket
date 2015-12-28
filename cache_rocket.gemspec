require "./lib/cache_rocket/version"

Gem::Specification.new do |spec|
  spec.name          = "cache_rocket"
  spec.version       = CacheRocket::VERSION
  spec.authors       = ["Tee Parham"]
  spec.email         = ["tee@neighborland.com"]
  spec.description   = "Rails rendering extension for server-side html caching"
  spec.summary       = "Rails rendering extension for server-side html caching"
  spec.homepage      = "https://github.com/neighborland/cache_rocket"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = `git ls-files -- {test}/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency "actionpack", ">= 3.2"

  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "mocha", "~> 1.1"
end
