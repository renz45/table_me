require 'cgi'
module TableMe
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