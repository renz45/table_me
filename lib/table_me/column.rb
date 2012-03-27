module TableMe
  class Column
    attr_accessor :name, :content, :sortable
    def initialize column_name, args = {}, &block
      self.name = column_name
      self.content = block
      
      if block
        self.sortable = args[:sort_on]
      else
        self.sortable = column_name
      end
    end
  end
end