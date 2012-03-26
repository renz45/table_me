require_relative '../../lib/table_me/url_builder'
require 'spec_helper'
describe TableMe::UrlBuilder do
  let(:table_two){{name: 'table_two', page: '2', order: 'name ASC'}}
  let(:search) {{column: "name", query: "foo"}}
  let(:options) do
    {page: 1,
    name: "user",
    order: "created_at ASC",
    search: search,
    other_tables: [table_two]}
  end

  let(:url_var) {
                  {"tm_#{table_two[:name]}" => table_two, 
                   "tm_#{options[:name]}" => {page: options[:page], 
                                              name: options[:name],
                                              order: options[:order],
                                              search: options[:search]}
                  }.to_param
                }

  let(:url_builder) { described_class }

  describe '.table_me_url_for' do
    subject {url_builder.url_for options}
    it 'displays the correct string for the url' do
      subject.should eq "?#{url_var}"
    end
  end
end