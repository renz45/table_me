require 'table_me/table_me_helper/table_me_helper'
require 'table_me/table_for_helper/table_for_helper'

module TableMe
  class Engine < ::Rails::Engine
    isolate_namespace TableMe

    initializer "table_me" do
      ActionView::Base.send :include, TableMe::TableForHelper
      ActionController::Base.send :include, TableMe::TableMeHelper
    end

    initializer "table_me.load_app_instance_data" do |app|
      TableMe.setup do |config|
        config.app_root = app.root
      end
    end

    initializer "table_me.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

    config.generators do |g|
      g.test_framework :rspec, view_specs: false
    end
  end
end
