class ThemesController < ApplicationController
  def index
    @discussions = Discussion.where(:company_id => current_user.company).where(:theme_id => nil).all
    @themes = ThemesHelper.get_themes(current_user)
    @discussion = Discussion.new
    @theme = Theme.new
  end

  def show
    @theme = get_theme_permissions(params[:id])
    if @theme.nil?
      redirect_to themes_path
    else
      @themes = ThemesHelper.get_themes(current_user)
    end
  end

  def new
    @themes = ThemesHelper.get_themes(current_user)
    @theme = Theme.new
  end

  def create
    if (params[:theme][:theme].empty?)
      redirect_to new_theme_path
    else
      @theme = Theme.new
      @theme.user = current_user
      @theme.company = current_user.company
      @theme.update_attributes(params[:theme])

      save_groups(params[:group_ids],@theme)
      redirect_to themes_path
    end
  end

  def edit
    @theme = get_theme_permissions(params[:id])
    if @theme.nil?
      redirect_to themes_path
    else
      @themes = ThemesHelper.get_themes(current_user)
    end
  end

  def update
    @theme = get_theme_permissions(params[:id])
    if @theme.nil?
      redirect_to themes_path
    else
      @theme = Theme.find(params[:id])
      @theme.update_attributes(params[:theme])
      if (!params[:group_ids].nil?)
        save_groups(params[:group_ids],@theme)
      end
      respond_to do |format|
        format.html  {redirect_to themes_path}
        format.json { render :json => @theme, :status => :ok }
      end
    end
  end

  def destroy
    @theme = get_theme_permissions(params[:id])
    if @theme.nil?
      redirect_to themes_path
    else
      Permission.delete_all(:theme_id => @theme)
      @theme.destroy
      redirect_to themes_path
    end
  end


  protected

  def get_theme_permissions(theme_id)
    @theme = nil
    @theme_perms = Permission.where(:company_id => current_user.company).where(:theme_id => theme_id).order(:group_id)
    @theme_perms.each do |theme_perm|
      if ((theme_perm.user == current_user) ||
         ((theme_perm.group == current_user.group) && (theme_perm.company == current_user.company)) ||
         ((theme_perm.group.nil?) && (theme_perm.user.nil?) && (theme_perm.company == current_user.company)))
        @theme = Theme.find(theme_id)
        @permissions = Permission.where(:theme_id => @theme)
      end
    end
    @theme
  end

  def need_saving?(new_group, theme_id)
    @need_to_save = true
    if (new_group.nil?)
      if (!Permission.where(:user_id => current_user).where(:theme_id => theme_id).empty?)
        @need_to_save = false
      end
    else
      if (new_group.to_i == 0)
        if (!Permission.where(:company_id => current_user.company).where(:theme_id => theme_id).empty?)
          @need_to_save = false
        end
      else
        if (!Permission.where(:group_id => new_group).where(:theme_id => theme_id).empty?)
          @need_to_save = false
        end
      end
    end
    @need_to_save
  end

  def save_groups(groups, theme)
    @need_save = true
    Permission.delete_all(:theme_id => theme)
    if (groups.nil?)
      if (need_saving?(nil,theme.id))
        @new_permission = Permission.new
        @new_permission.theme = theme
        @new_permission.company = current_user.company
        @new_permission.user = current_user
        @new_permission.save
      end
    else
      groups.each do |new_group|
        while (!new_group.nil?)
          if need_saving?(new_group,theme.id) && (@need_save)
            @new_permission = Permission.new
            @new_permission.theme = theme
            @new_permission.company = current_user.company
            if (new_group.to_i != 0)
              @new_permission.group = Group.find(new_group)
            end
            @new_permission.save
          end
          if (new_group.to_i != 0)
            new_group = Group.find(new_group).parent_id
          else
            @need_save = false
          end
        end
      end
    end
  end

end
