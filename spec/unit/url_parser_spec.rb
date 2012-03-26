require 'spec_helper'
require_relative '../../lib/table_me/url_parser'
require 'pry'
describe TableMe::URLParser do
  let(:column) {'name'}
  let(:query) { 'foo' }

  let(:new_column) { 'email' }
  let(:new_query) { 'user1' }
  let(:new_table_search_hash) { {column: new_column, query: new_query } }

  let(:table_name) { 'user' }
  let(:table_page) {'2'}
  let(:table_order) {'created_at ASC'}
  let(:table_search_hash) { {'column' => column, 'query' => query } }

  let(:table_two_name) {'user_user'}
  let(:table_two_page) {'1'}
  let(:table_two_order) {'created_at ASC'}

  let(:table_two) do
    {
      'name' => table_two_name,
      'page' => table_two_page,
      'order' => table_two_order
    }
  end

  let(:params) do 
    ActiveSupport::HashWithIndifferentAccess.new({
      "tm_#{table_name}" => {
        'name' => table_name,
        'page' => table_page,
        'order' => table_order
      },
      "tm_#{table_two_name}" => table_two
    })
  end

  let(:params_with_search) do 
    ActiveSupport::HashWithIndifferentAccess.new({
      "tm_#{table_name}" => {
        'name' => table_name,
        'page' => table_page,
        'order' => table_order,
        'search' => {'column' => column, 'query' => query},
        'new_search' => 'true'
      },
      "tm_#{table_two_name}" => table_two
    })
  end

  let(:url_parser) {described_class}

  describe '#parse_params_for' do
    subject {url_parser.parse_params_for(params, table_name)}

    describe 'returned hash' do
      context 'with only table_me param' do
        it 'has the correct values' do 
          subject.values_at('page','name','order','other_tables')
                    .should eq [table_page,table_name,table_order, [table_two]]
        end
      end

      context 'with a new search' do
        subject {url_parser.parse_params_for(params_with_search, table_name)}

        it 'has the correct values' do 
          subject.values_at('page','name','order','search','other_tables')
                 .should eq [table_page,table_name,table_order, table_search_hash, [table_two]]
        end
      end
    end
  end

end