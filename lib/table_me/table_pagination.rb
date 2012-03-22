require 'cgi'
require_relative 'url_builder'
module TableMe
  class TablePagination
    attr_accessor :options

    def initialize table_options
      self.options = table_options
    end

    def pagination_info
      <<-HTML.strip_heredoc
        <div class='table-me-pagination-info'>
          <h3>#{options[:name].split('_').join(' ').titleize}</h3> <p><b>#{options[:page]}</b> of <b>#{options[:page_total]}</b> out of a total <b>#{options[:total_count]}</b></p>
        </div>
      HTML
    end

    def pagination_controls
      <<-HTML.strip_heredoc
        <div class='table-me-pagination-controls'>
          <a href="#{prev_page_url}" class='previous'>&laquo; Prev</a> #{pagination_number_list} <a href="#{next_page_url}" class='next'>Next &raquo;</a>
        </div>
      HTML
    end

    def next_page_url
      page = if current_page == total_pages
        total_pages
      else
        current_page + 1
      end

      link_for_page page
    end

    def prev_page_url
      page = if current_page == 0
        0
      else
        current_page - 1
      end

      link_for_page page
    end

    def pagination_number_list 
      (1...page_button_count).to_a.map do |n|
        link_number = n + page_number_offset
        number_span(link_number)
      end.join(' ')
    end

    private

    def number_span link_number
      if current_page.to_s == link_number.to_s
        <<-HTML.strip_heredoc
          <span class='page current'>#{link_number}</span>
        HTML
      else
        <<-HTML.strip_heredoc
          <span class='page'><a href='#{link_for_page(link_number)}'>#{link_number}</a></span>
        HTML
      end
    end

    def link_for_page page
      temp_options = options.dup
      temp_options[:page] = page
       "?table_me=#{TableMe::UrlBuilder.url_for temp_options}"
    end

    def current_page
      options[:page].to_i
    end

    def total_pages
      options[:page_total]
    end

    def page_number_offset
      if current_page >= total_pages - 2
        current_page - 4 + (total_pages - current_page)
      elsif current_page <= 2
        1
      else
        current_page - 2
      end
    end

    def page_button_count
      if total_pages > 5
        5
      elsif total_pages > 1
        total_pages
      else
        0
      end
    end

  end
end