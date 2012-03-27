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
          <input type='text' name="tm_#{options[:name]}[search][query]" value="#{initial_value}"/>
          <input type='hidden' name="tm_#{options[:name]}[search][column]" value="#{column_name}"/>
          <input type='hidden' name="tm_#{options[:name]}[new_search]" value="true"/>
          #{create_other_fields options}
          <input id='search' type='submit' value='Search' />
        </form>
      HTML

    end

    def create_other_fields options
      inputs = []
      TableMe::UrlBuilder.filter_options(options).each do |option|
        option.each do |k,v|
          if k.to_s == 'search'
            # Adon't add the search fields if they are the current table
            unless option[:name] == options[:name]
              inputs << "<input type='hidden' name='tm_#{option[:name]}[search][query]' value='#{v[:query]}'/>"
              inputs << "<input type='hidden' name='tm_#{option[:name]}[search][column]' value='#{v[:column]}'/>"
            end
          else
            inputs << "<input type='hidden' name='tm_#{option[:name]}[#{k.to_s}]' value='#{v}'/>"
          end
        end
      end
      inputs.join("\n")
    end

    def display_clear
      <<-HTML.strip_heredoc if options[:search]
        <form method='get' action="?">
          #{create_other_fields options}
          <input id='search' type='submit' value='Clear Filter' />
        </form>
      HTML
    end

    def self.filters_for table_name
      @@filters[table_name]
    end

    private
    def url_for_tables options
      TableMe::UrlBuilder.url_for options
    end
  end
end