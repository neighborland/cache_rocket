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

  spec.files         = Dir["lib/**/*.rb", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_dependency "actionpack", ">= 4.0"

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "mocha", "~> 1.4"
end
