require_relative 'url_parser'
module TableMe
  #sample url variable table_me
  #table_me=course|1|created_at,user|2|username
  class TableMePresenter
    attr_accessor :params, :name
    attr_reader :data, :options

    class << self
      def data
        @@data
      end

      def options
        @@options
      end
    end

    @@data = {}
    @@options = {}
    
    def initialize model, options = {}, params = {}
      @options = ActiveSupport::HashWithIndifferentAccess.new(options)

      set_defaults_for model
      parse_params_for params
      get_data_for model
      @@options[self.name] = @options
    end

    def parse_params_for params
      options.merge! URLParser.parse_params_for(params, self.name)
    end

    def set_defaults_for model
      options[:page] = 1
      options[:per_page] ||= 10
      options[:name] ||= model.to_s.downcase
      options[:order] ||= 'created_at ASC'
      self.name = options[:name]
    end

    def get_data_for model

      model = apply_search_to(model)

      @@data[self.name] = @data = model.limit(options[:per_page])
                                       .offset(start_item)
                                       .order(options[:order])

      options[:total_count] = model.count
      options[:page_total] = (options[:total_count] / options[:per_page].to_f).ceil
    end

    def apply_search_to model
      if options[:search]
        if options[:new_search]
          options[:page] = 1
          options.delete(:new_search)
        end
        model.where(model.arel_table[options[:search][:column]].matches("%#{options[:search][:query]}%"))
      else
        model
      end
    end

    def start_item
      (options[:page].to_i - 1) * options[:per_page].to_i
    end

    def name= value
      self.options[:name] = @name = value
    end
  end
end