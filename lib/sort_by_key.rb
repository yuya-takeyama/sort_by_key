require 'sort_by_key/version'

module SortByKey
  def self.sort_by_key(hash, symbolize_keys: false, recursive: false, &block)
    keys = symbolize_keys ? hash.keys.map(&:to_sym) : hash.keys
    keys.sort(&block).reduce({}) do |acc, k|
      v = hash[k]
      if recursive && v.is_a?(Hash)
        acc[k] = self.sort_by_key(v, symbolize_keys: symbolize_keys, recursive: recursive, &block)
      elsif recursive && v.is_a?(Enumerable)
        acc[k] = v.map { |e| self.sort_by_key(e, symbolize_keys: symbolize_keys, recursive: recursive, &block) }
      else
        acc[k] = v
      end
      acc
    end
  end

  def sort_by_key(symbolize_keys: false, recursive: false, &block)
    ::SortByKey.sort_by_key(self, symbolize_keys: symbolize_keys, recursive: recursive, &block)
  end
end
