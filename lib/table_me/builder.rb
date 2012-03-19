require_relative 'column'
module TableMe
  class Builder

    def initialize
      @columns = []
      @names = []
    end

    def column name, &block
      @columns << TableMe::Column.new(name, &block)
      @names << name
      nil #return nil so we don't get html output from the block (this is dumb, I'll fix this later)
    end

    def columns
      @columns
    end

    def names
      @names
    end
  end
end