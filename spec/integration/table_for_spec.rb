require 'spec_helper'
require 'pry'

describe 'table_for helper html' do 
  let(:block_content) {proc{|c| "<span>#{c.email}</span>"}}
  let(:block) { proc{|t| t.column :email, &block_content } }
  let(:table_me_presenter) {TableMe::TableMePresenter.new(User)}
  let(:table_for_presenter) {TableMe::TableForPresenter.new(:user)}
  let(:table_for_presenter_block) {TableMe::TableForPresenter.new(:user, &block)}
  let(:email) {User.first.email}
  before(:each) do 
    30.times { FactoryGirl.create(:user) } 
    table_me_presenter
  end

  let(:table_me_data) {TableMe::TableMePresenter.data['user']}
  let(:table_me_options) {TableMe::TableMePresenter.options}
  
  describe 'TableForPresenter' do 
    context '#build_table with a table name' do
      let(:table_html){ Capybara::Node::Simple.new( table_for_presenter.build_table ) }
      describe 'table_for_presenter.data' do
        it 'should be a ActiveRecord::Relation' do
          table_for_presenter.data.class.should eq ActiveRecord::Relation
        end
      end

      it 'should have <table></table>' do
        table_html.should have_selector 'table'
      end

      describe '<table></table' do
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
            it 'should have <th></th>' do
              table_html.should have_selector 'table thead tr th'
            end

            # search in each th of the tr and confirm the correct attribute names exist
            it 'each th should have an attribute name from the presenter_me_data' do
              tr = table_html.find('thead tr')
              data_attribute_names = table_me_data.first.attribute_names
              data_attribute_names.length.times do |n|
                tr.find("th:nth-child(#{n+1})").should have_content(data_attribute_names[n].split('_').join(' ').titleize)
              end
            end
          end # <tr></tr>
        end # <thead></thead>

        describe '<tbody></tbody>' do
          it 'should have <tr></tr>' do
            table_html.should have_selector 'table tbody tr'
          end

          describe '<tr></tr>' do

            it 'should have <td></td>' do
              table_html.should have_selector 'table tbody tr td'
            end

            it 'should have table data which contain DB column values for each item in table_for_presenter.data' do
              # check if the first item is displayed table data
              # check within each td for a column name
              first_tr = table_html.find('tbody tr:first-child')
              data_attribute_names = table_me_data.first.attribute_names
              data_attribute_names.length.times do |n|
                first_tr.find("td:nth-child(#{n+1})").should have_content(table_me_data.first[data_attribute_names[n]])
              end

              # check if the last items is displayed in the table data
              # check within each td for a column name
              last_tr = table_html.find('tbody tr:last-child')
              data_attribute_names = table_me_data.last.attribute_names
              data_attribute_names.length.times do |n|
                last_tr.find("td:nth-child(#{n+1})").should have_content(table_me_data.last[data_attribute_names[n]])
              end
            end # it

          end # <tr></tr>
        end # <tbody></tbody>
         
      end # <table></table>

      context 'without columns' do
        let(:table_html){Capybara::Node::Simple.new( table_for_presenter.build_table ) }
        describe '<table></table>' do
          describe '<thead></thead>' do
            describe '<tr></tr>' do
              # search in each th of the tr and confirm the correct attribute names exist
              it 'each th should have an attribute name from the presenter_me_data' do
                tr = table_html.find('thead tr')
                data_attribute_names = table_me_data.first.attribute_names
                data_attribute_names.length.times do |n|
                  tr.find("th:nth-child(#{n+1})").should have_content(data_attribute_names[n].split('_').join(' ').titleize)
                end
              end
            end
          end# <thead></thead>

          describe '<tbody></tbody>' do
            describe '<tr></tr>' do
              it 'should have table data which contain DB column values for each item in table_for_presenter.data' do
                # check if the first item is displayed table data
                # check within each td for a column name
                first_tr = table_html.find('tbody tr:first-child')
                data_attribute_names = table_me_data.first.attribute_names
                data_attribute_names.length.times do |n|
                  first_tr.find("td:nth-child(#{n+1})").should have_content(table_me_data.first[data_attribute_names[n]])
                end

                # check if the last items is displayed in the table data
                # check within each td for a column name
                last_tr = table_html.find('tbody tr:last-child')
                data_attribute_names = table_me_data.last.attribute_names
                data_attribute_names.length.times do |n|
                  last_tr.find("td:nth-child(#{n+1})").should have_content(table_me_data.last[data_attribute_names[n]])
                end
              end# it
            end # <tr></tr>
          end # <tbody></tbody>

        end # <table></table>
      end # without columns

      context 'with columns' do
        let(:table_html){Capybara::Node::Simple.new( table_for_presenter_block.build_table ) }
        describe '<table></table>' do
          describe '<thead></thead>' do
            describe '<tr></tr>' do
              # search in each th of the tr and confirm the correct attribute names exist
              it 'should have a th with only email' do
                tr = table_html.find('thead tr')
                tr.find("th:first-child").should have_content('Email')
              end
            end
          end# <thead></thead>

          describe '<tbody></tbody>' do
            describe '<td></td>' do
              it 'has a span tag' do
                td = table_html.find('tbody td')

                td.should have_content 'span'
              end
            end
          end# <tbody></tbody>
        end# <table></table>
      end # with columns
    end # with table name

    describe 'pagination links' do
      
    end# pagination links

  end # TableForPresenter
end # table_for helper html