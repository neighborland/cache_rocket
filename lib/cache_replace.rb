require 'cache_replace/version'

module CacheReplace
  # Supports 4 options:
  #
  # 1. Single partial to replace
  #
  #   render_cached "container", replace: "inner"
  #
  # 2. Array of partials to replace
  #
  #   render_cached "container", replace: ["inner"]
  #
  # 3. Map of keys to replace with values
  #
  #   render_cached "container", replace: {special_link: special_link(object)}
  #
  # 4. Yield to a hash of keys to replace with values
  #
  #   render_cached "container" do
  #     {special_link: special_link(object)}
  #   end
  #
  def render_cached(static_partial, options={})
    replace = options.delete(:replace)
    fragment = render(static_partial, options)

    case replace
    when Hash
      replace_from_hash fragment, replace
    when NilClass
      replace_from_hash fragment, yield
    else
      replace = *replace
      replace.each do |key|
        fragment.sub! cache_replace_key(key), render(key, options)
      end
    end

    raw fragment
  end

  CACHE_REPLACE_KEY_OPEN  = '<cr '

  # string key containing the partial file name or placeholder key.
  # It is a tag that should never be returned to be rendered by the
  # client, but if so, it will be hidden since CR is not a valid html tag.
  def cache_replace_key(key)
    raw "#{CACHE_REPLACE_KEY_OPEN}#{key.to_s}>"
  end

private

  def replace_from_hash(fragment, hash)
    hash.each do |key, value|
      fragment.sub! cache_replace_key(key), value
    end
  end
end
