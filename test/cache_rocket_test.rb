require "test_helper"

class CacheRocketTest < MiniTest::Spec
  class FakeRenderer
    include CacheRocket

    attr_accessor :html

    def safe_concat(value)
      @html ||= ""
      @html += value
    end
  end

  def dog_name(dog)
    dog
  end

  def reverse(dog)
    dog.reverse
  end

  before do
    @renderer = FakeRenderer.new
  end

  describe "#cache_replace_key" do
    it "return key with prefix" do
      assert_equal "<crk some/thing>", @renderer.cache_replace_key("some/thing")
    end
  end

  describe "#render_cached" do
    before do
      @renderer.stubs(:render).with("container", {})
        .returns "Fanny pack #{@renderer.cache_replace_key('inner')} viral mustache."
      @renderer.stubs(:render).with("inner", {}).returns "quinoa hoodie"
    end

    it "render with single partial" do
      assert_equal "Fanny pack quinoa hoodie viral mustache.",
                   @renderer.render_cached("container", replace: "inner")
    end

    it "pass options to inner render" do
      @renderer.expects(:render).with("container", variable: "x").returns ""
      @renderer.expects(:render).with("inner", variable: "x").returns ""
      @renderer.render_cached("container", variable: "x", replace: "inner")
    end

    it "render with array of partials" do
      @renderer.stubs(:render).with("container", {})
        .returns "#{@renderer.cache_replace_key('inner')} #{@renderer.cache_replace_key('other')} viral mustache."
      @renderer.stubs(:render).with("other", {}).returns "high life"

      assert_equal "quinoa hoodie high life viral mustache.",
        @renderer.render_cached("container", replace: %w(inner other))
    end

    it "render with map of keys" do
      assert_equal "Fanny pack keytar viral mustache.",
        @renderer.render_cached("container", replace: { inner: "keytar" })
    end

    it "render with map of keys with a nil value" do
      assert_equal "Fanny pack  viral mustache.",
        @renderer.render_cached("container", replace: { inner: nil })
    end

    it "render with hash block" do
      output = @renderer.render_cached("container") do
        { inner: "keytar" }
      end
      assert_equal "Fanny pack keytar viral mustache.", output
    end

    it "replace every instance of key in inner partial" do
      @renderer.stubs(:render).with("container", {})
        .returns "#{@renderer.cache_replace_key('inner')} #{@renderer.cache_replace_key('inner')} viral mustache."

      assert_equal "quinoa hoodie quinoa hoodie viral mustache.",
        @renderer.render_cached("container", replace: "inner")
    end

    it "replace every instance of the keys with hash values" do
      @renderer.stubs(:render).with("container", {})
        .returns "I like #{@renderer.cache_replace_key('beer')}, #{@renderer.cache_replace_key('beer')} and #{@renderer.cache_replace_key('food')}."

      assert_equal "I like stout, stout and chips.",
        @renderer.render_cached("container", replace: { food: "chips", beer: "stout" })
    end

    it "replace collection with Proc in replace key" do
      @renderer.stubs(:render).with("partial", {})
        .returns "Hi #{@renderer.cache_replace_key(:dog)}."
      dogs = %w(Snoop Boo)

      assert_equal "Hi Snoop.Hi Boo.",
        @renderer.render_cached("partial", collection: dogs, replace: { dog: ->(dog) { dog_name(dog) } })
    end

    it "replace collection using hash block with Proc" do
      @renderer.stubs(:render).with("partial", {})
        .returns "Hi #{@renderer.cache_replace_key(:dog)}."
      dogs = %w(Snoop Boo)

      rendered = @renderer.render_cached("partial", collection: dogs) do
        { dog: ->(dog) { dog_name(dog) } }
      end

      assert_equal "Hi Snoop.Hi Boo.", rendered
    end

    it "replace collection with multiple procs" do
      @renderer.stubs(:render).with("partial", {})
        .returns "#{@renderer.cache_replace_key(:reverse)} #{@renderer.cache_replace_key(:dog)}."
      dogs = %w(Snoop Boo)

      rendered = @renderer.render_cached("partial", collection: dogs) do
        { dog: ->(dog) { dog_name(dog) }, reverse: ->(dog) { reverse(dog) } }
      end

      assert_equal "poonS Snoop.ooB Boo.", rendered
    end

    it "raise ArgumentError with invalid syntax" do
      @renderer.stubs(:render).with("container").returns("")
      assert_raises(ArgumentError) do
        @renderer.render_cached("container")
      end
    end
  end

  describe "#cache_replace" do
    it "raise if missing replace option" do
      assert_raises(ArgumentError) do
        @renderer.cache_replace("x")
      end
    end

    it "replaces key in content" do
      @renderer.stubs :cache_fragment_name
      @renderer.stubs fragment_for: "Hello <crk xyz>."
      assert_nil @renderer.cache_replace("abc", replace: { xyz: "there" }) {}
      assert_equal "Hello there.", @renderer.html
    end

    it "replaces keys in content" do
      @renderer.stubs :cache_fragment_name
      @renderer.stubs fragment_for: "Hello <crk xx>. <crk yy>."
      assert_nil @renderer.cache_replace([0], replace: { xx: "1", yy: "2" }) {}
      assert_equal "Hello 1. 2.", @renderer.html
    end
  end
end
