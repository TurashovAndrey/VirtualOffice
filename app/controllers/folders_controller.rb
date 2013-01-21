class FoldersController < ApplicationController
  def index
    get_init_folders
    @new_folder = Folder.new
    unless current_user.company.folders.first.nil?
      @folder = current_user.company.folders.first
      @new_attachment = Attachment.new
      @new_attachment.folder = @folder
    end
  end

  def new
    redirect_to folders_path
  end

  def create
    @folder = Folder.new
    @folder.user = current_user
    @folder.company = current_user.company
    if @folder.update_attributes(params[:folder])
      flash[:notice] = t('folder.save.success')
      redirect_to folder_path(@folder)
    else
      flash[:error] = t('folder.save.error')
    end
  end

  def edit
    @folder = Folder.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to folders_url, :error => t('folder.flash.has_no_permission_to_show')
    else
      if has_permission_to_folder? params[:id]
        get_init_folders
      else
        flash[:error] = t('folder.flash.has_no_permission_to_edit')
      end
  end

  def update
    @folder = Folder.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to folders_url, :error => t('folder.flash.has_no_permission_to_show')
    else
      if has_permission_to_folder? params[:id]
        if @folder.update_attributes(params[:folder])
          flash[:notice] = t('folder.save.success')
          redirect_to folder_path(@folder)
        else
          flash[:error] = t('folder.save.error')
          redirect_to folders_path
        end
      else
        flash[:error] = t('folder.flash.has_no_permission_to_edit')
        redirect_to folders_path
      end
  end

  def show
    @folder = Folder.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to folders_url, :error => t('folder.flash.has_no_permission_to_show')
    else
      get_init_folders
      @new_folder = Folder.new
      @new_attachment = Attachment.new
      @new_attachment.folder = @folder
      unless has_permission_to_folder? params[:id]
        redirect_to folders_path, :error => t('folder.flash.has_no_permission_to_show')
      end
  end

  def destroy
    @folder = Folder.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to folders_url, :error => t('folder.flash.has_no_permission_to_show')
    else
      if has_permission_to_folder?(params[:id])
        @folder = Folder.find(params[:id])
        @folder.destroy
      else
        flash[:error] = t('folder.flash.has_no_permission_to_delete')
      end
      redirect_to folders_path
  end

  protected
    def has_permission_to_folder?(folder_id)
      (Folder.find(folder_id).company == current_user.company) or
      (Folder.find(folder_id).user == current_user)
    end

  def get_init_folders
    @company_folders = current_user.company.folders
  end

end
