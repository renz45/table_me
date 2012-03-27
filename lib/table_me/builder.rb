require_relative 'column'
require_relative 'filter'
module TableMe
  # This class is responsible for building the various elements of the 
  # table through a blog passed into the table_for_presenter

  class Builder
    attr_accessor :options
    attr_reader :columns, :names, :filters
    def initialize table_options
      self.options = table_options
      @columns = []
      @names = []
    end

    # Define a column
    def column name,options = {}, &block
      @columns << TableMe::Column.new(name,options, &block)
      @names << name
    end

    #define a filter
    def filter name
      TableMe::Filter.new(options, name)
    end

    def filters
      TableMe::Filter.filters_for options[:name]
    end

    def clear_filter
      # TODO this seems a bit hacky to me, Will want to rework this at some point
      filters.last.display_clear
    end
  end
end