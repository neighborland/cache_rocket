require "test_helper"

module CacheRocket
  class FragmentTest < MiniTest::Spec
    describe "#to_s" do
      it "equal value" do
        assert_equal "yo", Fragment.new("yo").to_s
      end
    end

    describe "#gsub!" do
      it "substitute value" do
        fragment = Fragment.new("hello there, hello.")
        assert_equal "yo there, yo.", fragment.gsub!("hello", "yo")
      end
    end

    describe "#replace" do
      it "replace cache keys from hash" do
        cr_key = Fragment.new(nil).cache_replace_key(:xx)
        fragment = Fragment.new("hey #{cr_key} hey.")
        fragment.replace({ xx: "yo" }, nil)
        assert_equal "hey yo hey.", fragment.to_s
      end

      it "replace collection with Proc" do
        def last5(object)
          object.last(5)
        end
        replace_hash = { something: ->(object) { last5(object) } }
        collection = %w(xxTiger xxSkunk)
        cr_key = Fragment.new(nil).cache_replace_key(:something)
        fragment = Fragment.new("hey #{cr_key} hey.")
        assert_equal "hey Tiger hey.hey Skunk hey.",
          fragment.replace(replace_hash, collection).to_s
      end
    end
  end
end
