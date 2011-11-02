class PagesController < ApplicationController
  skip_before_filter :check_current_user

  def main
     @user = User.new
  end

end
