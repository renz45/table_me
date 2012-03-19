require File.expand_path('../../../table_me/table_for_presenter', __FILE__)
  #view
  # table_for :course, class: 'custom_table', id: 'the_table' do |t|
  #   t.column :id
  #   t.column :title do |c|
  #     content_tag :h1, c
  #   end
  #   t.column :created_at
  # end
module TableMe
  module TableForHelper
    def table_for(model,options = {}, &block)
      table_for_presenter = TableForPresenter.new(model,options,&block)
      table_for_presenter.build_table
    end
    
    def highlight_cell value, colors
      color_value = output_value = color = ''

      colors.each do |k,v|
        if v.kind_of? Array
          color_value = v[0]
          output_value = v[1]
        else
          output_value = color_value = v
        end
        
        if color_value == value
          color = k.to_s
          break
        end
      end

      unless color.empty?
        "<span class='#{color}'>#{output_value}</span>".html_safe
      else
        value
      end
    end
  end
end