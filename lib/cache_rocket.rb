require 'active_support/core_ext/string'
require 'cache_rocket/key'
require 'cache_rocket/fragment'
require 'cache_rocket/version'

module CacheRocket
  include Key

  ERROR_MISSING_KEY_OR_BLOCK = "You must either pass a `replace` key or a block to render_cached."
  
  # Supports 5 options:
  #
  # 1. Single partial to replace. 
  #    "inner" is the key name and "_inner.*" is the partial file name.
  #
  #   render_cached "container", replace: "inner"
  #
  # 2. Array of partials to replace
  #
  #   render_cached "container", replace: ["inner"]
  #
  # 3. Map of keys to replace with values
  #
  #   render_cached "container", replace: {key_name: a_helper_method(object)}
  #
  # 4. Yield to a hash of keys to replace with values
  #
  #   render_cached "container" do
  #     {key_name: a_helper_method(object)}
  #   end
  #
  # 5. Render a collection with Procs for replace values.
  #
  #   render_cached "partial", collection: objects, replace: { key_name: ->(object){a_method(object)} }
  #
  def render_cached(partial, options={})
    replace = options.delete(:replace)
    collection = options.delete(:collection)

    fragment = Fragment.new(render(partial, options))

    case replace
    when Hash
      if collection
        fragment.replace_collection collection, replace
      else
        fragment.replace_from_hash replace
      end
    when NilClass
      raise ArgumentError.new(ERROR_MISSING_KEY_OR_BLOCK) unless block_given?
      fragment.replace_from_hash yield
    else
      replace = *replace
      replace.each do |key|
        fragment.gsub! cache_replace_key(key), render(key, options)
      end
    end

    fragment.to_s.html_safe
  end

end
