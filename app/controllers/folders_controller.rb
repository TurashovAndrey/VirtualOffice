class FoldersController < ApplicationController
  def index
    @attachment = Attachment.new
    @attachments = Attachment.where(:company_id => current_user.company).where(:folder_id => nil )

    @folders = FoldersHelper.get_folders(current_user)
    @my_folders = FoldersHelper.get_private_folders(current_user)

    @all_folders = FoldersHelper.get_folders(current_user)
    @all_folders += FoldersHelper.get_private_folders(current_user)

    @folder = Folder.new
  end

  def new
    @folder = Folder.new
    @folders = FoldersHelper.get_folders(current_user)
    @my_folders = FoldersHelper.get_private_folders(current_user)
  end

  def create
    if (params[:folder][:folder_name].empty?)
      redirect_to new_folder_path
    else
      @folder = Folder.new
      @folder.user = current_user
      @folder.company = current_user.company
      @folder.update_attributes(params[:folder])

      save_groups(params[:group_ids],@folder)
      redirect_to folders_path
    end
  end

  def edit
    @folder = get_folder_permissions(params[:id])
    if @folder.nil?
      redirect_to folders_path
    else
      @attachment = Attachment.new
      @attachments = Attachment.where(:company_id => current_user.company).where(:folder_id => nil)
      @folders = FoldersHelper.get_folders(current_user)
      @my_folders = FoldersHelper.get_private_folders(current_user)
    end
  end

  def update
    @folder = get_folder_permissions(params[:id])
    if @folder.nil?
      redirect_to folders_path
    else
      @folder = Folder.find(params[:id])
      @folder.update_attributes(params[:folder])
      if (!params[:group_ids].nil?)
        save_groups(params[:group_ids],@folder)
      end
      respond_to do |format|
        format.html  {redirect_to folder_path(@folder)}
        format.json { render :json => @folder, :status => :ok }
      end
    end
  end

  def show
    @folder = get_folder_permissions(params[:id])
    if @folder.nil?
      redirect_to folders_path
    else
      @all_folders = FoldersHelper.get_folders(current_user)
      @all_folders += FoldersHelper.get_private_folders(current_user)

      @folders = FoldersHelper.get_folders(current_user)
      @my_folders = FoldersHelper.get_private_folders(current_user)
      @attachments = Attachment.where(:folder_id => @folder)
      @attachment = Attachment.new
      @attachment.folder = @folder
    end
  end

  def destroy
    @folder = get_folder_permissions(params[:id])
    if @folder.nil?
      redirect_to folders_path
    else
      Permission.delete_all(:folder_id => @folder)
      @folder.destroy
      redirect_to folders_path
    end
  end

  protected
    def get_folder_permissions(folder_id)
      @folder = nil
      @folder_perms = Permission.where(:company_id => current_user.company).where(:folder_id => folder_id).order(:group_id)
      @folder_perms.each do |folder_perm|
        if ((folder_perm.user == current_user) ||
           ((folder_perm.group == current_user.group) && (folder_perm.company == current_user.company)) ||
           ((folder_perm.group.nil?) && (folder_perm.user.nil?) && (folder_perm.company == current_user.company)))
          @folder = Folder.find(folder_id)
          @permissions = Permission.where(:folder_id => @folder)
        end
      end
      @folder
    end

    def need_saving?(new_group, folder_id)
      @need_to_save = true
      if (new_group.nil?)
        if (!Permission.where(:user_id => current_user).where(:folder_id => folder_id).empty?)
          @need_to_save = false
        end
      else
        if (new_group.to_i == 0)
          if (!Permission.where(:company_id => current_user.company).where(:folder_id => folder_id).empty?)
            @need_to_save = false
          end
        else
          if (!Permission.where(:group_id => new_group).where(:folder_id => folder_id).empty?)
            @need_to_save = false
          end
        end
      end
      @need_to_save
    end

    def save_groups(groups, folder)
      Permission.delete_all(:folder_id => folder)
      if (groups.nil?)
        if (need_saving?(nil,folder.id))
          @new_permission = Permission.new
          @new_permission.folder = folder
          @new_permission.company = current_user.company
          @new_permission.user = current_user
          @new_permission.save
        end
      else
        groups.each do |new_group|
          while (!new_group.nil?)
            if need_saving?(new_group,folder.id)
              @new_permission = Permission.new
              @new_permission.folder = folder
              @new_permission.company = current_user.company
              if (new_group.to_i != 0)
                @new_permission.group = Group.find(new_group)
              end
              @new_permission.save
            end
            if (new_group.to_i != 0)
              new_group = Group.find(new_group).parent_id
            else
              new_group = nil
            end
          end
        end
      end
    end
end
