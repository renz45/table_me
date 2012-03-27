require 'cgi'
module TableMe

  # This class builds the url needed for the tables based on the table options.
  # Some options are filtered out to make the url as short as possible. 
  class UrlBuilder
    class << self

      def url_for options, additional_options = {}
        table_options = options.merge additional_options

        url = []
        filter_options(table_options).each do |option|
          url <<  {"tm_#{option[:name]}".to_sym => option }.to_param
        end
          "?#{url.join('&')}"
      end

      # Filter out all options except name page search and order
      # We need to dup the objects so we don't alter the options
      # object through out the table_me module
      def filter_options options
        other_tables = options[:other_tables].dup || []
        temp_options = options.dup
        temp_options.keep_if do |k,v|
          ['name','page','search','order'].include? k.to_s
        end
        other_tables << temp_options
      end

    end
  end
end