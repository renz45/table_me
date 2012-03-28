require_relative '../table_me_presenter'
module TableMe

  # Controller
  # A table must first be created in your controller using the table_me method.

  # table_me(collection, options)
  # The collection can be two things, first an ActiveRecord::Relation, which 
  # is the result of some sort of active record query ex:

  # table_me( User.where(subscribed: true) )
  # Keep in mind that doing User.all just returns an array of objects, not the a relation.

  # In order to do the equivalent of the .all just pass in the ActiveRecord class:

  # table_me( User )
  # Possible options available for this method are:

  # name - Label for the the table
  # per_page - The amount of items per page of the table
  
  module TableMeHelper
    def table_me(model, options = {})
      table_presenter = TableMePresenter.new(model, options,params)
      @table_me ||= {}
      @table_me[table_presenter.name] = table_presenter

      table_presenter.name
    end
  end
end
