require_dependency 'table_me/table_for_presenter'
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
    def table_for(model,options = {},&block)

      table_for_presenter = TableForPresenter.new(self)
      table_for_presenter.build_table(model,options,&block)
    end
    
    
  end
end # TableMeControllerHelper