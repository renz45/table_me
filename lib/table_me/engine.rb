require_dependency 'table_me/table_me_helper/table_me_helper'
require_dependency 'table_me/table_for_helper/table_for_helper'
module TableMe
  class Engine < ::Rails::Engine
    isolate_namespace TableMe
    
    config.autoload_paths << File.expand_path("../table_me", __FILE__)

    initializer "table_me" do
      ActionView::Base.send :include, TableMe::TableForHelper
      ActionController::Base.send :include, TableMe::TableMeHelper
    end
  end
end
