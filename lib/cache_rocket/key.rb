module CacheRocket
  module Key
    CACHE_REPLACE_KEY_OPEN = "<cr "

    # string key containing the partial file name or placeholder key.
    # It is a tag that should never be returned to be rendered by the
    # client, but if so, it will be hidden since CR is not a valid html tag.
    def cache_replace_key(key)
      "#{CACHE_REPLACE_KEY_OPEN}#{key}>".html_safe
    end
  end
end
