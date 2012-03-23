require 'cgi'
module TableMe
  class UrlBuilder
    class << self

      def url_vars_for options, additional_options = {}
        options.merge! additional_options
        this_table_url_vars = [options[:name],
                               options[:page],
                               options[:order], 
                               search_item(options)].compact.reject(&:blank?).join('|')
        other_tables = options[:other_tables]
        CGI::escape( [other_tables,this_table_url_vars].compact.reject(&:blank?).join(',') )
      end

      def table_me_url_for options, additional_options = {}
        "?table_me=#{url_vars_for options, additional_options}"
      end

      private
      def search_item options
        if options[:search]
          "#{options[:search][:column]} #{options[:search][:query]}"
        else
          nil
        end
      end

    end
  end
end