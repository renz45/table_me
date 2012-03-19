module TableMe
  class Column
    attr_accessor :name, :content
    def initialize column_name, &block
      self.name = column_name
      self.content = block
    end
  end
end