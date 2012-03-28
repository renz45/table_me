require_relative '../table_for_presenter'
  
  # In your view you can create the table from the one initialized in the controller, 
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

module TableMe
  module TableForHelper
    def table_for(model, options = {}, &block)

      table_for_presenter = TableForPresenter.new(model, @table_me[model],options,&block)
      table_for_presenter.build_table
    end
    
    # Lets say that you want to have a visual que for if a user is an admin:
    # table_for :user do |t|
    #   t.column :id
    #   t.column :admin do |c|
    #     highlight_cell c.admin, green: true
    #   end
    #   t.column :created_at
    # end

    # You can put a green box around true in the column by passing an array to the color 
    # where the first value is the actual table value your looking for, while the second item 
    # is what will be used in the table field. But what if you want to change that true to the 
    # word 'Admin' and lets put a red box around all the non admins and make them say 'peons':

    # table_for :user do |t|
    #   t.column :id
    #   t.column :admin do |c|
    #     highlight_cell c.admin, green: [true, 'Admin'], red: [false, 'peon']
    #   end
    #   t.column :created_at
    # end

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