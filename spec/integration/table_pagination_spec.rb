require 'spec_helper'
require 'cgi'
describe TableMe::TablePagination do
  let(:table_me_options) { {name: 'user', page: '1', order: 'created_at ASC', page_total: 5, total_count: 25, other_tables: []} }
  let(:table_pagination) { TableMe::TablePagination.new(table_me_options) }
  let(:current_page) { table_me_options[:page].to_i }
  let(:total_pages) { table_me_options[:page_total] }
  let(:total_items) { table_me_options[:total_count].to_i }
  let(:table_name) { 'User' }

  describe '.pagination_info' do
    subject { Capybara::Node::Simple.new( table_pagination.pagination_info )  }

    it { should have_content table_name }
    it { should have_content current_page }
    it { should have_content total_pages }
    it { should have_content total_items }
  end

  describe '.pagination_controls' do
    let(:pagination_controls) { Capybara::Node::Simple.new( table_pagination.pagination_controls ) }
    subject { pagination_controls }

    describe 'next link' do
      let(:page) { current_page + 1 }
      subject { CGI::unescape(pagination_controls.find('a.next').to_json) }

    end

    describe 'previous link' do
      let(:page) { current_page - 1 }
      subject { CGI::unescape(pagination_controls.find('a.previous').to_json) }

    end
  end
end