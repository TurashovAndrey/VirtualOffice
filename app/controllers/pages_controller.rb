class PagesController < ApplicationController
  skip_before_filter :check_current_user
  layout 'main'

  def main
    @slide_companies = Company.find(:all, :conditions => ['logo_file_name != "missing.png"'], :limit => 4, :order => "RAND()")
    @user = User.new
  end

  def id
    @user = User.new
  end
end
