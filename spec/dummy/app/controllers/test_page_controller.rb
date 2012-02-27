class TestPageController < ApplicationController

  def index
    table_me User
    table_me User, name: 'user_with_col'
  end

end