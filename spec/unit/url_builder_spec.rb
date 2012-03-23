require_relative '../../lib/table_me/url_builder'
require 'cgi'
describe TableMe::UrlBuilder do
  let(:options) do
    {page: 1,
    name: "user",
    order: "created_at ASC",
    search: {column: "name", query: "foo"},
    other_tables: "user_user|1|created_at ASC"}
  end

  let(:url_var) {CGI::escape("#{options[:other_tables]},#{options[:name]}|#{options[:page]}|#{options[:order]}|#{options[:search][:column]} #{options[:search][:query]}")}

  let(:url_builder) { described_class }

  describe '.url_vars_for' do
    subject {url_builder.url_vars_for options}
    it 'displays the correct string for the url' do
      subject.should eq url_var
    end
  end

  describe '.table_me_url_for' do
    subject {url_builder.table_me_url_for options}
    it 'displays the correct string for the url' do
      subject.should eq "?table_me=#{url_var}"
    end
  end
end