require File.expand_path('../table_me_presenter', __FILE__)
require File.expand_path('../table_pagination', __FILE__)
module TableMe
  #sample url variable table_me
  #table_me=course|1|created_at,user|2|username
  class TableForPresenter
    attr_accessor :name, :options
    attr_reader :data
    # it's easier to delagate the capture and tag helper methods to the view, since there are things
    # such as haml dependancies that need to be included as well
    def initialize table_name, options = {}, &block
      # self.parent = parent
      self.options = options
      self.name = table_name
    end

    # delegate :capture, :content_tag, to: :parent
    # delegate :capture,  to: :parent

    def build_table 
      # @table_block = block
      # options[:class] ||= ""
      
      # get_data_from_controller_for model.to_s.downcase

      # self.params = self.params.merge(options)
      # new_builder
      # table_me_wrapper(assemble_table)
      <<-HTML.strip_heredoc.html_safe
        <div class='#{options[:class]}'>
          <table>
            <thead>
              <tr>#{create_header}</tr>
            </thead>
            <tbody>
              #{table_rows}
            </tbody>
          </table>
        </div>
      HTML
    end

    def data
      TableMePresenter.data[name.to_s]
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
            #{col_names.map {|col| "<td>#{d[col]}</td>"}.join}
          </tr>
        HTML
      end.join
    end

    def col_names
      data.first.attribute_names
    end
  #   private
  #   def get_data_from_controller_for model_name
  #     # @table_data = TableMePresenter.get_data_for model_name
  #     # self.params = TableMePresenter.get_params_for model_name
  #     @table_data = TableMePresenter.data[model_name]
  #     self.params = TableMePresenter.options[model_name]
  #   end

  #   def new_builder
  #     @builder = TableMeBuilder.new
  #   end

  #   def table_me_wrapper content
  #     pagination = TablePagination.new(params)
  #     content_tag :div, class: "table-me-table #{params[:name]}-table #{params[:class]}" do
  #       "#{pagination.pagination_info} #{content} #{pagination.pagination_controls}".html_safe
  #     end
  #   end

  #   def assemble_table
  #     content_tag :table do
  #       "#{build_table_head} #{build_table_body}".html_safe
  #     end
  #   end

  #   def build_table_head
  #     if @table_block
  #       header = capture(@builder,&@table_block)
  #     else
  #       header = @table_data.first.class.attribute_names.map do |name|
  #         @builder.column(name)
  #       end.join
  #     end
  #     content_tag(:thead, header.html_safe)
  #   end

  #   def build_table_body
  #     body = @table_data.map do |data|
  #       build_row(data)
  #     end.join("\n")

  #     content_tag(:tbody, body.html_safe)
  #   end

  #   def build_row item
  #     content_tag(:tr, class: cycle('even', 'odd')) do
  #       @builder.names.map do |col_name|
  #         build_table_data(item, col_name)
  #       end.join("\n").html_safe
  #     end
  #   end

  #   def build_table_data item,col_name
  #     # NOTE I was getting a weird gsub error when trying to use content_tag here for some reason.
  #     "<td>#{
  #       if block = @builder.get_block_for(col_name)
  #         capture(item, &block)
  #       else
  #         item.send(col_name)
  #       end
  #     }</td>"
  #   end

  #   def highlight_cell value, colors
  #     "<span class='#{colors.key(value).to_s}'>#{value.to_s}</span>".html_safe
  #   end

  #   def cycle *values
  #     @values = values if @values.nil? || @values.empty?
  #     @values.shift
  #   end
    
  #   class TableMeBuilder
  #     include ActionView::Helpers::TagHelper

  #     def initialize
  #       @names = []
  #       @blocks = {}
  #     end

  #     def column(name, &block)
  #       @names << name 
  #       @blocks[name] = block unless block.nil?
  #       content_tag(:th, name.to_s.split('_').join(' ').titleize)
  #     end

  #     def get_block_for name
  #       if @blocks.key?(name)
  #         @blocks[name]
  #       else
  #         false
  #       end  
  #     end

  #     def names
  #       @names
  #     end
  #   end
  end
end