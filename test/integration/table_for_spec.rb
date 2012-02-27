require 'spec_helper'

describe 'table_for helper html' do 
  let(:table_me_presenter) {TableMe::TableMePresenter.new(User)}
  let(:table_for_presenter) {TableMe::TableForPresenter.new(:user)}
  before(:each) do 
    30.times { FactoryGirl.create(:user) } 
    table_me_presenter
  end

  let(:table_me_data) {TableMe::TableMePresenter.data}
  let(:table_me_options) {TableMe::TableMePresenter.options}
  
  describe 'TableForPresenter' do 
    # before(:each) {visit '/test_page'}
    context '#build_tablewith a table name' do
      describe 'table_for_presenter.data' do
        it 'should be a ActiveRecord::Relation' do
          table_for_presenter.data.class.should eq ActiveRecord::Relation
        end
      end

      context 'without columns' do
         let(:table_html){Capybara::Node::Simple.new( table_for_presenter.build_table ) }

        it 'should have <table></table>' do
          table_html.should have_selector 'table'
       end

       describe '<table></table>'
        it 'should have <thead></thead>' do
            table_html.should have_selector 'table thead'
        end

        it 'should have <tbody></tbody>' do
          table_html.should have_selector 'table tbody'
        end

        describe '<thead></thead>' do

          it 'should have <tr></tr>' do
                table_html.should have_selector 'table thead tr'
          end

          describe '<tr></tr>' do
             let(:table_head) do
              table_for_presenter.data.first.attribute_names.map do |name|
                "<th>#{name}</th>"
              end.join.html_safe
            end

            it 'should have <th></th>' do
              table_html.should have_selector 'table thead tr th'
            end

            it 'should have table heads should have an attribute from an item in table_for_presenter.data
            ' do
              table_for_presenter.build_table.should match /#{table_head}/
            end

          end

        end# <thead></thead>

        describe '<tbody></tbody>' do
          it 'should have <tr></tr>' do
            table_html.should have_selector 'table tbody tr'
          end

          describe '<tr></tr>' do
            # this seems like the wrong thing to do to me.
            let(:table_rows) do
              cols = table_for_presenter.data.first.attribute_names
              table_for_presenter.data.map do |data|
                row = "<tr>"
                row << cols.map {|col| "<td>#{data[col]}</td>"}.join
                row << '</tr>'
              end.join
            end

            # loop assertions to check in tds for the string value
            it 'should have <td></td>' do
              table_html.should have_selector 'table tbody tr td'
            end

            it 'should have table data which contain DB column values for each item in table_for_presenter.data' do
              table_for_presenter.build_table.should match /#{table_rows}/
            end

          end#<tr></tr>
        end
        
      end# <table></table>
    end# without columns
  end#with table name

end#TableForPresenter
