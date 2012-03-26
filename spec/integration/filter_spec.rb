require 'spec_helper'
require 'pry'
require_relative '../../lib/table_me/filter'
describe TableMe::Filter do
  let(:options) do
    {
      other_tables: [{page:1, name: 'user_user', order: 'created_at ASC'}],
      page: 1,
      name: 'user',
      order: 'created_at ASC',
    }
  end

  let(:name) { :email }
  let(:filter) { TableMe::Filter.new(options, name) }

  describe '.display' do
    subject { Capybara::Node::Simple.new(filter.display) }
    it 'displays filter form' do
      subject.find('form').should be_true
    end

    describe 'filter form' do
      it 'has an input for the search query' do
        subject.find('input[type=text]').should be_true
      end
    end
    
  end
end