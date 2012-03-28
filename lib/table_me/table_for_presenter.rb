require_relative 'table_me_presenter'
require_relative 'table_pagination'
require_relative 'builder'
require_relative 'url_builder'

module TableMe

  # the first parameter of table_for is the name set in table_me. By default the class 
  # name is used if a name isn't set.

  # table_for :user
  # Now, this will list all columns from the database in your table, which you 
  # may not always want to do. You can pass a block of columns to be more specific:

  # table_for :user do |t|
  #   t.column :id
  #   t.column :email
  #   t.column :created_at
  # end

  # This will give you a user table with the columns id, email, and created_at.

  # What if you want to customize the output of the column? Each column can also 
  # take a block of content:

  # table_for :user do |t|
  #   t.column :id
  #   t.column :email do |c|
  #     "<h1>c.email</h1>"
  #   end
  #   t.column :created_at
  # end

  # Now, when a block is used to alter the content of a column, the sorting is lost, 
  # since the table can no longer assume what is in the column. You need to set a sort_on 
  # param to tell the column what to sort by. For example:

  # table_for :user do |t|
  #   t.column :id
  #   t.column :email, sort_on: :email do |c|
  #     "<h1>c.email</h1>"
  #   end
  #   t.column :created_at
  # end

  # Filters
  # You can add basic filter fields to the table by using the filter method. Right now, 
  # only one filter can be applied and the filters are search fields. I would like to 
  # eventually add different types for different types of data. I would like to eventually 
  # add in the ability for multiple filter types with a single search button, but the basic 
  # form is all I need at the moment. Ajax enabled filtering would be freaking great as well.

  # Filter usage:

  # table_for :user do |t|
  #   t.filter :email
  #   t.filter :name
  #   t.column :id
  #   t.column :email 
  #   t.column :name
  # end

  # The build_table method will use the other public methods to build a full table. It's 
  # possible to construct your own build table method if you want a custom layout.


  class TableForPresenter < ActionView::Base
    include ActionView::Helpers::CaptureHelper
    include Haml::Helpers if defined?(Haml)

    attr_accessor :name, :options
    attr_reader :data

    def initialize table_name, table_me_presenter, options = {}, &block
      @table_me_presenter = table_me_presenter

      self.options = ActiveSupport::HashWithIndifferentAccess.new(options.merge(@table_me_presenter.options))
      self.name = table_name
      @block = block

      # required to get capture to work with haml
      init_haml_helpers if defined?(Haml)

      setup_classes
      process_data_attributes 
    end

    # build the complete table with pagination and filters if set.

    def build_table 
      <<-HTML.strip_heredoc.html_safe
        <div class='table-me'>
          #{table_filters}
          <div class="table-me-table #{'with-filters' if table_builder.filters}">
            #{table_pagination.pagination_info}
            <table>
              <thead>
                <tr>#{create_header}</tr>
              </thead>
              <tbody>
                #{table_rows}
              </tbody>
            </table>
            #{table_pagination.pagination_controls}
          </div>
        </div>
      HTML
    end

    # get data from the table_me_presenter in the controller. This breaks encapsulation and makes
    # this class too tightly coupled to the TableMePresenter, I wanted to keep the table data out
    # of the class variables in the controller and view, but there has to be a better way to do it.
    # TODO decouple this and options below
    def data
      @table_me_presenter.data
    end


    # same as data above, only with table options. Ideally this needs to be a value object instead
    # of just a hash. TODO use a value object instead of a hash, see table_vo.rb
    # def options
    #   @table_me_presenter.options
    # end


    private


    def setup_classes
      # clear the filter saved to class
      TableMe::Filter.init
    end

    # create table filters if they exist
    def table_filters
      <<-HTML if table_builder.filters
        <div class='table-filters'>
          <h3>Filters</h3>
          #{table_builder.filters.map do |filter|
            filter.display
          end.join("\n")}
          #{table_builder.clear_filter}
        </div>
      HTML
    end

    # create a table pagination object
    def table_pagination
      @table_pagination ||= TablePagination.new(options)
    end

    # find the class of the data passed in 
    def data_class
      data.first.class
    end

    # create the sortable headers from columns given
    def create_header
      order = options[:order].split(' ')
      table_columns.map do |column|
        if column.sortable
          if order[0] == column.sortable.to_s
            url = TableMe::UrlBuilder.url_for(options, order: "#{column.sortable.to_s} #{order[1].downcase == 'asc' ? 'desc' : 'asc'}")
            klass = order[1]
          else
            url = TableMe::UrlBuilder.url_for(options, order: "#{column.sortable.to_s} asc")
            klass = nil
          end
          "<th><a #{"class='#{klass}'" if klass} href='#{url}'>#{column.name.to_s.split('_').join(' ').titleize}</a></th>"
        else
          "<th>#{column.name.to_s.split('_').join(' ').titleize}</th>"
        end
      end.join.html_safe
    end

    # create table rows based on data for each row using columns as a template
    def table_rows
      data.map do |d|
        <<-HTML
          <tr class="#{cycle('odd', 'even')}">
            #{table_column_for(d)}
          </tr>
        HTML
      end.join.html_safe
    end

    # cycle through an array of items, for now this is for row striping
    # Row striping can be handled by css, so this might just get removed.
    def cycle *items
      @cycle_items = items if @cycle_items.nil? || @cycle_items.empty?
      @cycle_items.pop
    end

    # it would ne nicer to encapsulate this into the column class, but then we have
    # to set it up like a view so capture works. For now, I'll leave this here, I'm not
    # sure if the encapsulation is worth the overhead
    def table_column_for data
      table_columns.map do |column|
        "<td>#{column.content ? capture(data, &column.content) : data[column.name]}</td>"
      end.join
    end

    # create a table builder instance
    def table_builder
      @builder ||= TableMe::Builder.new(options)
    end

    # get column names from the table_builder
    def col_names
      table_builder.names
    end

    # get table columns from the table_builder
    def table_columns
      table_builder.columns
    end

    # pass in the block given to the table_for_presenter if it exists
    # else just create a column for every column in the data object
    def process_data_attributes
      if @block
        capture(table_builder, &@block)
        if table_builder.columns.empty?
          build_all_columns
        end
      else
        build_all_columns
      end
    end

    # create a column for every column in the data object
    def build_all_columns
      data.first.attribute_names.each do |attribute|
        table_builder.column(attribute)
      end 
    end

  end
end