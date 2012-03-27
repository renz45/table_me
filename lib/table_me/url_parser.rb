require 'cgi'
require_relative 'url_builder'
module TableMe
  # Parse the url params into the hash needed for table_me to work. Take the tables
  # which aren't the current one and save them as other_tables so we can persist
  # their states in links.
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