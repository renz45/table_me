
# parses a url variable 'table_me'/params[:table_me] with the format of:
# <table name>|<table page>|<table order>|<table search(optional)>
# into a table object ment for this current table
module TableMe
  class URLParser
    def self.parse_params_for params, name
      @@name = name
      if params[:table_me]
        current_table_object = {}

        # split string into table specific strings
        # return the table string to map if it isn't named for the current table
        # we need to do this in order to preserve the options of other tables
        table_string_list = params[:table_me].split(',').map do |table_string|
          table_object = parse_table_params_for(table_string)

          next table_string unless table_object[:name] == self.name
          current_table_object = table_object
          nil
        end

        current_table_object[:other_tables] = table_string_list.compact.join(',')
        current_table_object
      else
       {other_tables: ''}
      end
    end

    private

    def self.name
      @@name
    end

    # parse the table specific string into a table hash
    def self.parse_table_params_for table_string
      table_params = table_string.split('|')
      table_object = {page: table_params[1]}
      table_object[:name], table_object[:order] = table_params[0], table_params[2]
      table_object[:search] = parse_search_params_from(table_params[3])
      table_object
    end

    # parse the search part of the string into a seperate search hash
    def self.parse_search_params_from search_string
      if search_string
        search_params = search_string.split(' ')
        {column: search_params[0], query: search_params[1]}
      end
    end
  end
end