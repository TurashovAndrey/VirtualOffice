class AttachmentsController < ApplicationController
  def create
    @attachment = Attachment.new
    @attachment.user = current_user
    @folder = Folder.find(params[:attachment][:folder_id])
    if @attachment.update_attributes(params[:attachment])
      flash[:notice] = t('event.flashes.saves')
    else
      flash[:error] = t('event.flashes.save_error')
    end
    redirect_to folder_url(@folder)
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to folders_path, :error => t('attachment.flashes.delete_error')
    else
      @folder = @attachment.folder
    if @attachment.destroy
      flash[:notice] = t('attachment.flashes.deleted')
    else
      flash[:error] = t('attachment.flashes.delete_error')
    end
    redirect_to folder_url(@folder)
  end
end
