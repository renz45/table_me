require 'spec_helper'
require_relative '../../lib/table_me/url_parser'
require 'pry'
require 'cgi'
describe TableMe::URLParser do
  let(:name) {'user'}
  let(:column) {'name'}
  let(:query) { 'foo' }

  let(:new_column) { 'email' }
  let(:new_query) { 'user1' }
  let(:new_table_search) {"#{new_column} #{new_query}"}
  let(:new_table_search_hash) { {column: new_column, query: new_query } }

  let(:table_name) { 'user' }
  let(:table_page) {'2'}
  let(:table_order) {'created_at ASC'}
  let(:table_search) {"#{column} #{query}"}
  let(:table_search_hash) { {column: column, query: query } }
  let(:table_string) { "#{table_name}|#{table_page}|#{table_order}|#{table_search}" }

  let(:table_two_name) {'user_user'}
  let(:table_two_page) {'1'}
  let(:table_two_order) {'created_at ASC'}
  let(:other_table_string) { "#{table_two_name}|#{table_two_page}|#{table_two_order}" }

  let(:params) do 
    {
      table_me: CGI::escape("#{other_table_string},#{table_string}")
    }
  end

  let(:params_with_search) do 
    {
      table_me_search: new_query,
      table_me_search_info: CGI::escape("#{name}|#{new_column}"),
      table_me: CGI::escape("#{other_table_string},#{table_string}")
    }
  end

  let(:table_name) {'user'}
  let(:url_parser) {described_class}

  describe '#parse_params_for' do
    subject {url_parser.parse_params_for(params, name)}

    it { subject.class.should eq Hash }

    describe 'returned hash' do
      context 'with only table_me param' do
        it 'has the correct values' do 
          subject.values_at(:page,:name,:order,:search,:other_tables)
                    .should eq [table_page,table_name,table_order, table_search_hash, other_table_string]
        end
      end

      context 'with a new search' do
        subject {url_parser.parse_params_for(params_with_search, name)}

        it 'sets the page of the table to 1' do
          subject.values_at(:page).should eq [1]
        end

        it 'has the correct values' do 
          subject.values_at(:page,:name,:order,:search,:other_tables)
                 .should eq [1,table_name,table_order, new_table_search_hash, other_table_string]
        end
      end
    end
  end

end