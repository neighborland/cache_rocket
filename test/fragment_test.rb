require 'test_helper'

module CacheRocket
  class FragmentTest < Test::Unit::TestCase
    context "#to_s" do
      should "equal value" do
        assert_equal "yo", Fragment.new("yo").to_s
      end
    end

    context "#gsub!" do
      should "gsub value" do
        fragment = Fragment.new("hello there, hello.")
        assert_equal "yo there, yo.", fragment.gsub!("hello", "yo")
      end
    end

    context "#replace_from_hash" do
      should "replace cache keys" do
        cr_key = Fragment.new(nil).cache_replace_key(:xx)
        fragment = Fragment.new("hey #{cr_key} hey.")
        fragment.replace_from_hash(xx: "yo")
        assert_equal "hey yo hey.", fragment.value
      end
    end

    context "#replace_collection" do
      should "replace with Proc" do
        def last5(object)
          object.last(5)
        end
        replace_hash = { something: ->(obj){ last5(obj)} }
        collection = %w[xxTiger xxSkunk]
        cr_key = Fragment.new(nil).cache_replace_key(:something)
        fragment = Fragment.new("hey #{cr_key} hey.")
        assert_equal "hey Tiger hey.hey Skunk hey.",
          fragment.replace_collection(collection, replace_hash)
      end
    end

  end
end