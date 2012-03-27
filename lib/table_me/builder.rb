require_relative 'column'
require_relative 'filter'
module TableMe
  class Builder
    attr_accessor :options
    attr_reader :columns, :names, :filters
    def initialize table_options
      self.options = table_options
      @columns = []
      @names = []
    end

    def column name,options = {}, &block
      @columns << TableMe::Column.new(name,options, &block)
      @names << name
    end

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