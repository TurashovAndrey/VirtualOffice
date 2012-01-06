class PagesController < ApplicationController
  skip_before_filter :check_current_user
  layout 'main'

  def main
    @user = User.new
  end

  def id
    @user = User.new
  end
end
