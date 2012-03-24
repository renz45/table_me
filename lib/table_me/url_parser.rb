
# parses a url variable 'table_me'/params[:table_me] with the format of:
# <table name>|<table page>|<table order>|<table search(optional)>
# into a table object ment for this current table
require 'cgi'
require_relative 'url_builder'
module TableMe
  class URLParser
    def self.parse_params_for params, name
      @@name = name
      parse_table_me(params)
    end


    private

    
    def self.parse_table_me params
      table_options = {}
      other_tables = []
      params.each do |k,v|
        if k.to_s.include? 'tm_'
          if v[:name] == @@name.to_s
            table_options = v
          else
            other_tables << v
          end
        end
      end
      table_options[:other_tables] = other_tables
      table_options
    end

    def self.name
      @@name
    end

  end
end