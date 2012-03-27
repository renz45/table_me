require_relative 'url_builder'
module TableMe
  # This class creates the filter forms for searching a table.
  # Unlike the column class, the filter class is responsible
  # for creating it's own view. See the table_for_helper file
  # for documentation on how to use filters
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

    # Display the filter form
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

    # display a clear filters button, this clears the filters if any are active.
    # This could/should be just a link styled like a button, there really isn't a
    # need for it to be a form
    # TODO Change this into a link instead of a form
    def display_clear
      <<-HTML.strip_heredoc if options[:search]
        <form method='get' action="?">
          #{create_other_fields options}
          <input id='search' type='submit' value='Clear Filter' />
        </form>
      HTML
    end

    # getter for all the filters
    def self.filters_for table_name
      @@filters[table_name]
    end

    private

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

    def url_for_tables options
      TableMe::UrlBuilder.url_for options
    end
  end
end