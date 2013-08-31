require 'test_helper'

module CacheRocket
  class FragmentTest < Test::Unit::TestCase
    context "#to_s" do
      should "equal value" do
        assert_equal "yo", Fragment.new("yo").to_s
      end
    end

    context "#gsub!" do
      should "substitute value" do
        fragment = Fragment.new("hello there, hello.")
        assert_equal "yo there, yo.", fragment.gsub!("hello", "yo")
      end
    end

    context "#replace" do
      should "replace cache keys from hash" do
        cr_key = Fragment.new(nil).cache_replace_key(:xx)
        fragment = Fragment.new("hey #{cr_key} hey.")
        fragment.replace({xx: "yo"}, nil)
        assert_equal "hey yo hey.", fragment.value
      end

      should "replace collection with Proc" do
        def last5(object)
          object.last(5)
        end
        replace_hash = { something: ->(object){ last5(object)} }
        collection = %w[xxTiger xxSkunk]
        cr_key = Fragment.new(nil).cache_replace_key(:something)
        fragment = Fragment.new("hey #{cr_key} hey.")
        assert_equal "hey Tiger hey.hey Skunk hey.",
          fragment.replace(replace_hash, collection)
      end
    end

  end
end