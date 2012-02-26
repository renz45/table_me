module TableMe
  #sample url variable table_me
  #table_me=course|1|created_at,user|2|username
  class TableMePresenter
    attr_accessor :params, :name, :options
    attr_reader :data

    class << self
      def data
        @@data
      end

      def options
        @@options
      end
    end
    
    def initialize model, options = {}, params = {}
      self.options = options

     
      set_defaults_for model
      parse_params_for params
      get_data_for model

      @@options = options
    end

    # parse the url params for each table
    def parse_params_for params
      if params[:table_me]
        current_table_object = {}
        # split string into table specific strings
        table_string_list = params[:table_me].split(',').map do |table_string|
          table_object = parse_table_params_for(table_string)

          next table_string unless table_object[:name] == self.name
          current_table_object = table_object
          nil
        end

        options[:other_tables] = table_string_list.compact.join(',')

        options.merge! current_table_object

      end
    end

    # parse the table specific string into a table hash
    def parse_table_params_for table_string
      table_params = table_string.split('|')
      table_object = {page: table_params[1]}
      table_object[:name], table_object[:order] =table_params[0], table_params[2]
      table_object[:search] = parse_search_params_from(table_params[3])
      table_object
    end

    # parse the search part of the string into a seperate search hash
    def parse_search_params_from search_string
      if search_string
        search_params = search_string.split(' ')
        {column: search_params[0], query: search_params[1]}
      else
        nil
      end
    end

    def set_defaults_for model
      options[:per_page] ||= 10
      options[:name] ||= model.to_s.downcase
      self.name = options[:name]
    end

    def get_data_for model
      @@data = @data = model.limit(options[:per_page])
    end

    def name= value
      self.options[:name] = @name = value
    end
  end
end