# frozen_string_literal: true

require "test_helper"

module CacheRocket
  class KeyTest < Minitest::Spec
    describe "#cache_replace_key" do
      it "return key with prefix" do
        class KeyFake
          include Key
        end

        key = KeyFake.new
        assert_equal "<crk some/thing>", key.cache_replace_key("some/thing")
      end
    end
  end
end
