module TableMe
  class TablePagination
    attr_accessor :params

    def initialize table_params
      self.params = table_params
    end

    def pagination_info
      <<-HTML.strip_heredoc
        <div class='table-me-pagination-info'>
          <b>#{params[:page]}</b> of <b>#{params[:page_total]}</b> out of a total <b>#{params[:total_count]}</b>
        </div>
      HTML
    end

    def pagination_controls
      "<a href='#{prev_page_url}'>&laquo; prev</a> #{pagination_number_list} <a href='#{next_page_url}'>next &raquo;</a>"
    end

    def next_page_url
      page = if params[:page] == params[:page_total]
        params[:page_total]
      else
        params[:page].to_i + 1
      end

      link_for_page page
    end

    def prev_page_url
      page = if params[:page] == 0
        0
      else
        params[:page].to_i - 1
      end

      link_for_page page
    end

    def pagination_number_list 
      html = (0...page_button_count).to_a.map do |n|
        link_number = n + page_number_offset
        number_span(link_number)
      end.join(' ')

      html
    end

    def number_span link_number
      if params[:page].to_s == link_number.to_s
        "<span class='page current'>#{link_number}</span>"
      else
        "<span class='page'><a href=#{link_for_page(link_number)}>#{link_number}</a></span>"
      end
    end

    def link_for_page page
       this_table_url_vars = [params[:name],page,params[:order]].join('%7C')
       other_tables = params[:other_tables].split('|').join('%7C')
       "?table_me=#{[other_tables,this_table_url_vars].compact.reject(&:blank?).join(',')}"
    end

    def page_number_offset
      if params[:page].to_i >= params[:page_total] - 2
        params[:page].to_i - 4 + (params[:page_total] - params[:page].to_i)
      elsif params[:page].to_i <= 2
        1
      else
        params[:page].to_i - 2
      end
    end

    def page_button_count
      if params[:page_total] > 5
        5
      elsif params[:page_total] > 1
        params[:page_total]
      else
        0
      end
    end

  end
end