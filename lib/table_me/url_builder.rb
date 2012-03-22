require 'cgi'
module TableMe
  class UrlBuilder
    class << self

      def url_for options
        this_table_url_vars = [options[:name],
                               options[:page],
                               options[:order], 
                               search_item(options)].compact.reject(&:blank?).join('|')
        other_tables = options[:other_tables]
        CGI::escape( [other_tables,this_table_url_vars].compact.reject(&:blank?).join(',') )
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