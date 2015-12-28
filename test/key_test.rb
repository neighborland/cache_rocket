require "test_helper"

module CacheRocket
  class KeyTest < MiniTest::Spec
    describe "#cache_replace_key" do
      it "return key with prefix" do
        class KeyFake
          include Key
        end

        key = KeyFake.new
        assert_equal CacheRocket::Key::CACHE_REPLACE_KEY_OPEN + "some/thing>", key.cache_replace_key("some/thing")
      end
    end
  end
end
