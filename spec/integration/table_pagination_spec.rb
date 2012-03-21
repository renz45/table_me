require 'spec_helper'
describe TableMe::TablePagination do
  let(:table_me_presenter) { TableMe::TableMePresenter.new(User) }
  let(:table_me_options) { TableMe::TableMePresenter.options['user'] }
  let(:table_pagination) { TableMe::TablePagination.new(table_me_options) }
  let(:current_page) { table_me_options[:page] }
  let(:total_pages) { table_me_options[:page_total] }
  let(:total_items) { table_me_options[:total_count] }
  let(:table_name) { 'User' }

  before do
    table_me_presenter
  end

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
      subject { pagination_controls.find('a.next').to_json }

      it 'should preserve other table states' do
        table_me_options[:other_tables] = "user_user%7C3%7Ccreated_at%20ASC"
        should match /.*table_me=user_user%7C3%7Ccreated_at%20ASC,user%7C#{page}%7Ccreated_at[%20\s]ASC.*/
      end
      it 'should generate a link the next page in the string' do
        should match /.*table_me=.*user%7C#{page}%7Ccreated_at[%20\s]ASC.*/
      end
    end

    describe 'previous link' do
      let(:page) { current_page - 1 }
      subject { pagination_controls.find('a.previous').to_json }
      
      it 'should preserve other table states' do
        table_me_options[:other_tables] = "user_user%7C3%7Ccreated_at%20ASC"
        should match /.*table_me=user_user%7C3%7Ccreated_at%20ASC,user%7C#{page}%7Ccreated_at[%20\s]ASC.*/
      end
      it 'should generate a link the prev page in the string' do
        should match /.*table_me=.*user%7C#{page}%7Ccreated_at[%20\s]ASC.*/
      end
    end
  end
end