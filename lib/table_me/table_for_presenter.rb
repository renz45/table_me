require_relative 'table_me_presenter'
require_relative 'table_pagination'
require_relative 'builder'

module TableMe
  #sample url variable table_me
  #table_me=course|1|created_at,user|2|username
  class TableForPresenter < ActionView::Base
    include ActionView::Helpers::CaptureHelper
    include Haml::Helpers if defined?(Haml)

    attr_accessor :name, :options
    attr_reader :data

    def initialize table_name, options = {}, &block
      # self.parent = parent
      self.options = options
      self.name = table_name
      @block = block

      # required to get capture to work with haml
      init_haml_helpers if defined?(Haml)

      process_data_attributes 
    end

    def build_table 
      <<-HTML.strip_heredoc.html_safe
        <div class="table-me-table">
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
      HTML
    end

    def data
      TableMePresenter.data[name.to_s]
    end

    def options
      TableMePresenter.options[name.to_s]
    end


    private


    def table_pagination
      @table_pagination ||= TablePagination.new(options)
    end

    def data_class
      data.first.class
    end

    def create_header
      col_names.map do |name|
        "<th>#{name}</th>"
      end.join.html_safe
    end

    def table_rows
      data.map do |d|
        <<-HTML
          <tr>
            #{table_column_for(d)}
          </tr>
        HTML
      end.join.html_safe
    end

    def table_column_for data
      table_columns.map do |column|
        if column.content
          "<td>#{capture(data, &column.content)}</td>"
        else
          "<td>#{data[column.name]}</td>"
        end
      end.join
    end

    def table_builder
      @builder ||= TableMe::Builder.new
    end

    def col_names
      table_builder.names
    end

    def table_columns
      table_builder.columns
    end

    def process_data_attributes
      if @block
        capture(table_builder, &@block)
      else
        data.first.attribute_names.each do |attribute|
          table_builder.column(attribute)
        end 
      end
    end

  end
end