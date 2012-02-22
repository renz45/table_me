require_dependency 'table_me/table_me_presenter'
module TableMe
  module TableMeHelper
    def table_me(model, options = {})
      #sample url variable table_me
      #table_me=course|1|created_at,user|2|username
      table_presenter = TableMePresenter.new(model,options,params)
      table_presenter.name
    end
  end
end
