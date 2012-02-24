require 'spec_helper'

describe "TableMePresenter" do
  before(:all) { 20.times { FactoryGirl.create(:user) } }

  context "without a model" do
    it "should raise an error" do
      lambda { TableMe::TableMePresenter.new }.should raise_error
    end
  end

  context "with just a model" do

    describe "the presenter data" do
      before(:all) { 20.times { FactoryGirl.create(:user) } }


      let(:presenter) { TableMe::TableMePresenter.new(User) }

      it "contain the first 10 records of that model" do
        presenter.data.length.should eq 10
      end

    end

  end

  context "customizing number of records per page" do
    before(:all) { 20.times { FactoryGirl.create(:user) } }

    let(:presenter) { TableMe::TableMePresenter.new(User, per_page: 15) }

    describe "the presenter data" do
      it "contain the first 15 records of that model" do
        presenter.data.length.should eq 15
      end
    end
  end  
end