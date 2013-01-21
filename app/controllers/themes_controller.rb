class ThemesController < ApplicationController
  def index
    get_init_themes
    @new_theme = Theme.new
    unless current_user.company.themes.first.nil?
      @default_theme = current_user.company.themes.first
    end
  end

  def show
    @theme = Theme.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to themes_url, :error => t('theme.flash.has_no_permission_to_show')
  else
    get_init_themes
    @new_theme = Theme.new
    unless has_permission_to_theme? params[:id]
      redirect_to themes_url, :error => t('theme.flash.has_no_permission_to_show')
    end
  end

  def new
    redirect_to themes_path
  end

  def create
    @theme = Theme.new
    @theme.user = current_user
    @theme.company = current_user.company
    if @theme.update_attributes(params[:theme])
      redirect_to themes_url, :notice => t('theme.save.success')
    else
      redirect_to theme_url(@theme),:error => t('theme.save.error')
    end

    @user_commented = @current_user
    @theme.comments.create(:title => "First comment.", :comment => "This is the first comment.")
  end

  def edit
    @theme = Theme.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to themes_url, :error => t('themes.flash.has_no_permission_to_edit')
    else
      if has_permission_to_theme? params[:id]
        get_init_themes
      else
        redirect_to themes_url, :error => t('theme.flash.has_no_permission_to_edit')
      end
  end

  def update
    @theme = Theme.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to themes_url, :error => t('theme.flash.has_no_permission_to_edit')
    else
      if has_permission_to_theme? params[:id]
       if @theme.update_attributes(params[:theme])
         redirect_to theme_url(@theme), :notice => t('theme.save.success')
      else
        redirect_to themes_url, :error => t('theme.save.error')
      end
    else
      redirect_to themes_url, :error => t('theme.flash.has_no_permission_to_edit')
    end
  end

  def destroy
    @theme = Theme.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to themes_url, :error => t('theme.flash.has_no_permission_to_edit')
    else
      if has_permission_to_theme?(params[:id])
        @theme.destroy
      else
        flash[:error] = t('theme.flash.has_no_permission_to_delete')
      end
      redirect_to themes_url, :notice => t('theme.delete.success')
  end

  protected

  def has_permission_to_theme?(theme_id)
    (Theme.find(theme_id).company == current_user.company) or
        (Theme.find(theme_id).user == current_user)
  end

  def get_init_themes
    @company_themes = current_user.company.themes
  end
end
