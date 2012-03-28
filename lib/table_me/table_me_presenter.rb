require_relative 'url_parser'
module TableMe

  # table_me(collection, options)
  # The collection can be two things, first an ActiveRecord::Relation, which 
  # is the result of some sort of active record query ex:

  # table_me( User.where(subscribed: true) )
  # Keep in mind that doing User.all just returns an array of objects, not the a relation.

  # In order to do the equivalent of the .all just pass in the ActiveRecord class:

  # table_me( User )
  # Possible options available for this method are:

  # name - Label for the the table
  # per_page - The amount of items per page of the table
  class TableMePresenter
    attr_accessor :params, :name
    attr_reader :data, :options

    # class << self
    #   # These class variables may need to be cleared and data handled differently
    #   def data
    #     @@data
    #   end

    #   def options
    #     @@options
    #   end
    # end

    # @@data = {}
    # @@options = {}
    
    def initialize model, options = {}, params = {}
      @options = ActiveSupport::HashWithIndifferentAccess.new(options)

      set_defaults_for model
      parse_params_for params
      get_data_for model
    end

    # parse the params into an options hash that we can use
    def parse_params_for params
      options.merge! URLParser.parse_params_for(params, self.name)
    end

    # set defaults for options
    def set_defaults_for model
      options[:page] = 1
      options[:per_page] ||= 10
      options[:name] ||= model.to_s.downcase
      options[:order] ||= 'created_at ASC'
      self.name = options[:name]
    end

    # make the model queries to pull back the data based on pagination and search results if given
    def get_data_for model
      model = apply_search_to(model)

      @data = model.limit(options[:per_page]).offset(start_item).order(options[:order])

      options[:total_count] = model.count
      options[:page_total] = (options[:total_count] / options[:per_page].to_f).ceil
    end

    # Apply the search query to the appropriate table columns. This is sort of ugly at the moment
    # and not as reliable as it could be. It needs to be refactored to account for different column
    # types and use appropriate search methods. Ex. LIKE doesn't work for integers
    # TODO refactor this to be more reliable for all column types
    def apply_search_to model
      if options[:search]
        if options[:new_search]
          options[:page] = 1
          options.delete(:new_search)
        end

        column_hash = model.columns_hash || model.class.columns_hash

        if column_hash[options[:search][:column].to_s].sql_type.include?('char')
          model.where(model.arel_table[options[:search][:column]].matches("%#{options[:search][:query]}%"))
        else
          model.where(options[:search][:column].to_sym => options[:search][:query])
        end
      else
        model
      end
    end

    # beginning item for the offset relation call
    def start_item
      (options[:page].to_i - 1) * options[:per_page].to_i
    end

    def name= value
      self.options[:name] = @name = value
    end
  end
end