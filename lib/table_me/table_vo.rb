# I was going to use this instead of a hash which is passed around, but it started getting too complex
# for a generic value object, so I might do something else later, not worth it at this time.
module TableMe
  class TableVO
    def self.vo_attr_accessor *args
      @@set_methods = *args
      attr_accessor *args
    end

    vo_attr_accessor :page, :page_total, :search, 
                  :order, :name, :per_page, 
                  :total_count, :other_tables

    def initialize params = {}
      self.merge! params
    end

    def []= key, value
      self.method("#{key}=").call(value)
    end

    def [] key
      self.method(key).call
    end

    def merge! object
      object.each do |k,v|
        self.method("#{k}=").call(v) unless v.nil?
      end
      self
    end

    def each
      @@set_methods.each do |method|
        yield(method,self.method(method).call)
      end
    end

    def to_hash
      hash = {}
      @@set_methods.each do |method|
        hash[method] = method(method).call
      end
      hash
    end

  end
end