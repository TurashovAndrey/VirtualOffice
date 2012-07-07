class ThemesController < ApplicationController
  def index
    @themes = Theme.where(:company_id => current_user.company)
    @discussions = Discussion.where(:company_id => current_user).where(:theme_id => nil)
  end

  def show
    @themes = Theme.where(:company_id => current_user.company)
    @theme = Theme.find(params[:id])
  end

  def new
    @themes = Theme.where(:company_id => current_user.company)
    @theme = Theme.new
  end

  def create
    @theme = Theme.new
    @theme.user = current_user
    @theme.company = current_user.company
    @theme.update_attributes(params[:theme])
    redirect_to themes_path
  end
end
