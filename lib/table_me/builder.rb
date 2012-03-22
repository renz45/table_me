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

    def column name, &block
      @columns << TableMe::Column.new(name, &block)
      @names << name
      nil #return nil so we don't get html output from the block (this is dumb, I'll fix this later)
    end

    def filter name
      TableMe::Filter.new(options, name)
    end

    def filters
      TableMe::Filter.filters_for options[:name]
    end

  end
end