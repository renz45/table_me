module TableMe
  #sample url variable table_me
  #table_me=course|1|created_at,user|2|username
  class TableMePresenter
    attr_accessor :params, :data
    
    # @@data = {} 
    # @@params = {}
    # @@names = []
    def initialize model, options = {}
      # @model = model
      options[:per_page] ||= 10
      # table_options[:name] ||= set_name
      # table_options[:other_tables] = ''
      # self.params = parse_params table_params, table_options

      # setup_table_info
      self.data = model.limit(options[:per_page])
    end

  #   def name
  #     params[:name]
  #   end

  #   def self.set_data_for name, data
  #     @@data[name.to_sym] = data
  #     self.store_name name
  #   end

  #   def self.get_data_for name
  #     @@data[name.to_sym]
  #   end

  #   def self.set_params_for name, options
  #     @@params[name.to_sym] = options
  #     self.store_name name
  #   end

  #   def self.get_params_for name
  #     @@params[name.to_sym]
  #   end

  #   def self.names
  #     @@names
  #   end

  #   private
  #   def setup_table_info
  #     params[:total_count] = @model.count
  #     params[:page_total] = (params[:total_count] / params[:per_page].to_f).floor

  #     check_table_bounds      

  #     get_table_data
  #     save_data
      
  #   end

  #   def check_table_bounds
  #     if params[:page].to_i <= 0
  #       params[:page] = 1
  #     elsif params[:page].to_i > params[:page_total]
  #       params[:page] = params[:page_total]
  #     end
  #   end

  #   def save_data
  #     TableMePresenter.set_data_for params[:name], @table_data
  #     TableMePresenter.set_params_for params[:name], @params
  #   end

  #   def self.store_name name
  #     @@names << name unless @@names.include?(name)
  #   end

  #   def set_name
  #     if @model.kind_of? ActiveRecord::Relation
  #       @model.first.class.to_s.downcase
  #     else
  #       @model.to_s.downcase
  #     end
  #   end

  #   def get_table_data
  #     if @model.kind_of? Array
  #       raise <<-FAIL.strip_heredoc
  #       Data passed in must be an ActiveRecord model class, or ActiveRecord::Relation 
  #       (model.all returns an array, not a relation. Pass in just the model class to select all items)
  #       FAIL
  #     end
  #     @table_data = @model.order(params[:order])
  #                         .limit(params[:per_page])
  #                         .offset((params[:page].to_i - 1) * params[:per_page]) 
  #   end

  #   def parse_params table_params, table_options
  #     if table_params[:table_me]
  #       tables = table_params[:table_me].split(',')
  #       tables.each do |table|
  #         table_params = table.split('|')
  #         # preserve the other tables in a string, but remove the current one and parse it's params
  #         if table_params[0] == table_options[:name]
  #           tables.delete(table)
  #           break
  #         end
  #       end

  #       if table_params[0] == table_options[:name]
  #         table_options[:page] = table_params[1]
  #         table_options[:order] = table_params[2]
  #       else
  #         table_options[:page] = 1
  #         table_options[:order] = 'created_at ASC'
  #       end
  #       table_options[:other_tables] = tables.reject(&:blank?).join(',')
  #     end
      
  #     table_options
  #   end
  end
end