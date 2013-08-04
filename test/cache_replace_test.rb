require 'test_helper'

class CacheReplaceTest < Test::Unit::TestCase
  class FakeRenderer
    include CacheReplace

    # mock ActionView::Helpers::OutputSafetyHelper
    def raw(value)
      value
    end
  end

  setup do
    @renderer = FakeRenderer.new
  end

  context "#cache_replace_key" do
    should "return key with prefix" do
      assert_equal CacheReplace::CACHE_REPLACE_KEY_OPEN + "some/thing>", @renderer.cache_replace_key("some/thing")
    end
  end

  context "#render_cached" do
    setup do
      @renderer.stubs(:render).with("container", {}).returns "Fanny pack #{@renderer.cache_replace_key('inner')} viral mustache."
      @renderer.stubs(:render).with("inner", {}).returns "quinoa hoodie"
    end

    should "render with single partial" do
      assert_equal "Fanny pack quinoa hoodie viral mustache.", @renderer.render_cached("container", replace: "inner")
    end

    should "pass options to inner render" do
      @renderer.expects(:render).with("container", variable: "x").returns ""
      @renderer.expects(:render).with("inner", variable: "x").returns ""
      @renderer.render_cached("container", variable: "x", replace: "inner")
    end

    should "render with array of partials" do
      @renderer.stubs(:render).with("container", {}).
        returns "#{@renderer.cache_replace_key('inner')} #{@renderer.cache_replace_key('other')} viral mustache."
      @renderer.stubs(:render).with("other", {}).returns "high life"
      assert_equal "quinoa hoodie high life viral mustache.", @renderer.render_cached("container", replace: ["inner", "other"])
    end

    should "render with map of keys" do
      assert_equal "Fanny pack keytar viral mustache.", @renderer.render_cached("container", replace: {inner: "keytar"})
    end
    
    should "render with map of keys with a nil value" do
      assert_equal "Fanny pack  viral mustache.", @renderer.render_cached("container", replace: {inner: nil})
    end    

    should "render with hash block" do
      output = @renderer.render_cached("container") do
        {inner: "keytar"}
      end
      assert_equal "Fanny pack keytar viral mustache.", output
    end

    should "replace every instance of key in inner partial" do
      @renderer.stubs(:render).with("container", {}).
        returns "#{@renderer.cache_replace_key('inner')} #{@renderer.cache_replace_key('inner')} viral mustache."
      assert_equal "quinoa hoodie quinoa hoodie viral mustache.", @renderer.render_cached("container", replace: "inner")
    end

    should "replace every instance of the keys with hash values" do
      @renderer.stubs(:render).with("container", {}).
        returns "I like #{@renderer.cache_replace_key('beer')}, #{@renderer.cache_replace_key('beer')} and #{@renderer.cache_replace_key('food')}."
      assert_equal "I like stout, stout and chips.", @renderer.render_cached("container", replace: {food: "chips", beer: 'stout'})
    end
  end
end
