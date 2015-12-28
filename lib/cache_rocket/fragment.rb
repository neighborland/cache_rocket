module CacheRocket
  class Fragment
    include Key

    attr_accessor :value

    def initialize(value)
      self.value = value
    end

    def to_s
      value
    end

    def gsub!(key, value)
      self.value.gsub! key, value
    end

    def replace(hash, collection)
      if collection
        replace_collection collection, hash
      else
        replace_from_hash hash
      end
    end

    private

    def replace_from_hash(hash)
      hash.each do |key, value|
        gsub! cache_replace_key(key), value.to_s
      end
    end

    def replace_collection(collection, replace_hash)
      html = ""

      collection.each do |item|
        html << replace_item_hash(item, replace_hash)
      end

      self.value = html
    end

    def replace_item_hash(item, hash)
      item_fragment = value.dup

      hash.each do |key, proc|
        item_fragment.gsub! cache_replace_key(key), proc.call(item)
      end

      item_fragment
    end
  end
end
