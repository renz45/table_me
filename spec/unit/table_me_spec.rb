require 'spec_helper'

describe "TableMePresenter" do
  before(:each) { 20.times { FactoryGirl.create(:user) } }

  context "without a model" do
    it "should raise an error" do
      lambda { TableMe::TableMePresenter.new }.should raise_error
    end
  end

  context "with just a model" do
    let(:presenter) { TableMe::TableMePresenter.new(User) }
    describe "the presenter data" do

      it "should contain the first 10 records of that model" do
        presenter.data.length.should eq 10
      end

      it "should be an ActiveRecord::Relation" do
        presenter.data.class.should eq ActiveRecord::Relation
      end

    end # "the presenter data"

    describe "the presenter name" do
      it 'should contain user' do
        presenter.name.should eq 'user'
      end
    end

  end #  "with just a model"

  context 'with a model' do

    context 'has options' do

      context "options[:per_page] = 15" do
        let(:presenter) { TableMe::TableMePresenter.new(User, per_page: 15) }
        
        describe "the presenter data" do
          it "contain the first 15 records of that model" do
            presenter.data.length.should eq 15
          end
        end

        describe "the presenter options" do
          it "should be a hash" do
            presenter.options.kind_of?(Hash).should eq true
          end

          it "contains a key :per_page" do
            presenter.options.key?(:per_page).should eq true
          end

          it "contains a key :per_page which contains the value 15" do
            presenter.options[:per_page].should eq 15
          end

          it "contains a key page which is 1" do
            presenter.options[:page].should eq 1
          end

          it "contains a key page_total which should be 2" do
            presenter.options[:page_total].should eq 2
          end
        end # "the presenter options"

      end # "options[:per_page] = 15"

      context "options[:name] = 'custom_user_table'" do
        let(:presenter) { TableMe::TableMePresenter.new(User, name: 'custom_user_table') }
        
        describe "the presenter name" do
          it "contains 'custom_user_table'" do
            presenter.name.should eq 'custom_user_table'
          end
        end

        describe "the presenter options" do
          it "contains a key :name" do
            presenter.options.key?(:name).should eq true
          end

          it "contains a key :name which contains the value 'custom_user_table'" do
            presenter.options[:name].should eq 'custom_user_table'
          end
        end # "options[:name] = 'custom_user_table'"

      end # "options[:name] = 'custom_user_table'"

    end # 'has options'
    
    context "presenter.name = 'custom_table'" do
      let(:presenter) { TableMe::TableMePresenter.new(User) }
      
      let(:presenter_with_name) do
        presenter.name = 'custom_table'
        presenter
      end

      describe "presenter.options"  do
        it 'should have a key :name with value "custom_table"' do
          presenter_with_name.options[:name].should eq 'custom_table'
        end
      end
    end # "presenter.name = 'custom_table'"

    context "presenter.data should be read only" do
      let(:presenter) { TableMe::TableMePresenter.new(User) }
      
      describe "assigning a value to presenter.data" do
        it "should raise an error" do
          lambda { presenter.data = User.first }.should raise_error
        end
      end

      describe "reading a value from presenter.data" do
        it "should not raise an error" do
          lambda { presenter.data }.should_not raise_error
        end

        it "should be an ActiveRecord::Relation" do
          presenter.data.class.should eq ActiveRecord::Relation
        end
      end

    end # "presenter.data should be read only"

    context "with url params for a single table" do
      context "params[:table_me] = 'user|2|name ASC|email user'" do
        let(:params) do 
          {'tm_users'=>
            {page: '2',
            name: 'user',
            order: 'name ASC'}
          }
        end
        let(:presenter) { TableMe::TableMePresenter.new(User,{}, params) }

        describe "presenter.options[:page]" do
          it 'should equal 2' do
            presenter.options[:page].should eq '2'
          end
        end

        describe "presenter.options[:order]" do
          it 'should equal "name ASC"' do
            presenter.options[:order].should eq 'name ASC'
          end
        end

        describe "presenter.options[:search]" do
          let(:search_object) {{'column' => "email", 'query' => "user"}}
          let(:params) do 
            {'tm_users'=>
              {page: '2',
              name: 'user',
              order: 'name ASC',
              search: search_object,
              new_search: true}
            }
          end
          
          it 'should return a hash' do
            presenter.options[:search].class.should eq ActiveSupport::HashWithIndifferentAccess
          end

          it 'should equal {column: "email", query: "user"}' do
            presenter.options[:search].should eq search_object
          end
        end
      end 

    end # "with url params for a single table"

    context "with url params for multiple tables" do

      context "tm_user and user_two" do
        let(:order) {'created_at ASC'}
        let(:name) {'user_two'}
        let(:page) {'3'}

        let(:params_multi_tables) do
          params = {'tm_user'=>
                    {'page' => '2',
                    'name' => 'user',
                    'order' => 'name ASC'}
                  }

          params[:tm_user_user] = {page: page,
                                  name: name,
                                  order: order}
          params
        end
        let(:presenter) { TableMe::TableMePresenter.new(User,{name: 'user_two'}, params_multi_tables) }

        describe "presenter.options[:page]" do
          it 'should be correct' do
            presenter.options[:page].should eq page
          end
        end

        describe "presenter.options[:order]" do
          it 'should be correct' do
            presenter.options[:order].should eq order
          end
        end

        describe 'presenter.options[:other_tables]' do
          it 'should preserve other tables' do
            presenter.options[:other_tables].should eq [params_multi_tables['tm_user']]
          end
        end
      end
    end # "with url params for multiple tables"

    describe 'Pagination' do
      context 'page 2 with 2 users per page' do
        let(:order) {"name ASC"}
        let(:params) do
          {'tm_user'=>
            {page: '2',
            name: 'user',
            order: 'name ASC'}
          }
        end
        let(:presenter) { TableMe::TableMePresenter.new(User, {per_page: 2}, params) }
        let(:user_list) {User.limit(10).order(order)}

        describe 'presenter.data' do
          it 'should contain items 3 and 4 from the user_list' do
            presenter.data[0].should eq user_list[2]
            presenter.data[1].should eq user_list[3]
          end

          it 'should be in the currect order' do
            presenter.data[0].should eq user_list[2]
            presenter.data[1].should eq user_list[3]
          end
        end
      end
    end
  end # 'with a model'
end