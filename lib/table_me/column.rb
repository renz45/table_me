module TableMe
  # This class is the column object that gets created 
  # everytime a column is used in the table_for_presenter block
  # It's basically a value object which keeps track of the data 
  # for each individual column.
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