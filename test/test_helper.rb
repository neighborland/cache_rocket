if ENV["TRAVIS"]
  require "coveralls"
  Coveralls.wear!
end

require "minitest/autorun"
require "mocha/mini_test"
require "cache_rocket"

begin
  require "pry-byebug"
rescue LoadError
end
