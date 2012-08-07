class DiscussionsController < ApplicationController
  def new
    if ((!params[:theme_id].nil?) && (get_theme_permissions(params[:theme_id]).nil?))
        redirect_to themes_path
    else
        @themes = ThemesHelper.get_themes(current_user)
        @discussion = Discussion.new
        @discussion.theme = @theme
    end
  end

  def create
    if ((params[:discussion][:theme_id]!="") && (get_theme_permissions(params[:discussion][:theme_id]).nil?))
      redirect_to themes_path
    else
      @discussion = Discussion.new
      @discussion.user = current_user
      @discussion.company = current_user.company
      @discussion.update_attributes(params[:discussion])
      if !@discussion.theme.nil?
        redirect_to theme_path(@discussion.theme)
      else
        redirect_to themes_path
      end
    end
  end

  def update
    @discussion = Discussion.find(params[:id])
    if (((@discussion.theme.nil?) && (@discussion.company != current_user.company)) ||
        ((!@discussion.theme.nil?) && (get_theme_permissions(@discussion.theme_id).nil?)))
        redirect_to themes_path
    else
      @discussion.update_attributes(params[:discussion])
      @comment = nil
      if (!params[:comment].nil?) && (params[:comment][:comment] != "")
        #Save comment and attachment for it
        @comment = Comment.new
        @comment.discussion = @discussion
        @comment.user = current_user
        @comment.company = current_user.company
        @comment.comment = params[:comment][:comment]
        @comment.comment_date = DateTime.now
        @comment.save
      end

      if !(params[:task_attachment].nil?)
          @attachment = TaskAttachment.new
          @attachment.discussion = @discussion
          @attachment.user = current_user
          @attachment.company = current_user.company
          @attachment.comment = @comment
          @attachment.attachment =  params[:task_attachment][:attachment]
          @attachment.save
      end
      respond_to do |format|
        format.html  {redirect_to themes_path}
        format.json { render :json => @discussion, :status => :ok }
      end
    end
  end

  def show
    @discussion = Discussion.find(params[:id])
    if (((@discussion.theme.nil?) && (@discussion.company != current_user.company)) ||
        ((!@discussion.theme.nil?) && (get_theme_permissions(@discussion.theme_id).nil?)))
        redirect_to themes_path
    else
        @themes = ThemesHelper.get_themes(current_user)
        @discussion = Discussion.find(params[:id])
        @comment = Comment.new
        @comment.user = current_user
        @task_attachment = TaskAttachment.new
        @comments = Comment.where(:discussion_id => @discussion.id)
    end
  end

  def destroy
    @discussion = Discussion.find(params[:id])
    if (((@discussion.theme.nil?) && (@discussion.company != current_user.company)) ||
        ((!@discussion.theme.nil?) && (get_theme_permissions(@discussion.theme_id).nil?)))
        redirect_to themes_path
    else
      @discussion.destroy
      if !@discussion.theme.nil?
        redirect_to theme_path(@discussion.theme)
      else
        redirect_to themes_path
      end
    end
  end

  def edit
    @discussion = Discussion.find(params[:id])
    if (((@discussion.theme.nil?) && (@discussion.company != current_user.company)) ||
        ((!@discussion.theme.nil?) && (get_theme_permissions(@discussion.theme_id).nil?)))
        redirect_to themes_path
    else
        @themes = ThemesHelper.get_themes(current_user)
        @discussion = Discussion.find(params[:id])
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
end
