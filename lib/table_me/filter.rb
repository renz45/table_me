require_relative 'url_builder'
module TableMe
  class Filter
    attr_accessor :options, :column_name
    
    @@filters = {}

    def initialize options, column_name
      self.options = options
      self.column_name = column_name

      @@filters[options[:name]] ||= []


      @@filters[options[:name]].delete_if {|item| item.column_name == column_name}
      @@filters[options[:name]] << self 
    end

    def display
      initial_value = options[:search] && options[:search][:column] == column_name.to_s ? options[:search][:query] : ''
      <<-HTML.strip_heredoc
        <form method='get' action="?">
          <label for='search'>#{column_name.to_s.split('_').join(" ").titleize}</label>
          <input type='text' name='table_me_search' value="#{initial_value}"/>
          <input type='hidden' name='table_me_search_info' value="#{options[:name]}%7C#{column_name}" />
          <input type='hidden' name='table_me' value="#{table_for_url_var}" />
          <input id='search' type='submit' value='Search' />
        </form>
      HTML

    end

    def display_clear
      <<-HTML.strip_heredoc
        <form method='get' action="?">
          <input type='hidden' name='table_me_search' value=""/>
          <input type='hidden' name='table_me_search_info' value="#{options[:name]}%7C#{options[:search][:column]}" />
          <input type='hidden' name='table_me' value="#{table_for_url_var}" />
          <input id='search' type='submit' value='Clear Filter' />
        </form>
      HTML
    end

    def self.filters_for table_name
      @@filters[table_name]
    end

    private
    def table_for_url_var
      TableMe::UrlBuilder.url_vars_for options
    end
  end
end