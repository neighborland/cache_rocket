# frozen_string_literal: true

if ENV["TRAVIS"]
  require "coveralls"
  Coveralls.wear!
end

require "minitest/autorun"
require "mocha/minitest"
require "cache_rocket"

begin
  require "pry-byebug"
rescue LoadError
end
