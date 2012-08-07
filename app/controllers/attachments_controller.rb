class AttachmentsController < ApplicationController
  def index
    redirect_to folders_path
  end

  def show
    redirect_to folders_path
  end

  def new
    redirect_to folders_path
  end

  def create
    if (!params[:attachment].nil?)
      @attachment = Attachment.new(params[:attachment])
      @attachment.company = current_user.company
      @attachment.user = current_user

      #if @params[:attachment][:folder]==0
      #  @attachment.folder = nil
      #end

      if @attachment.save
        flash[:notice] = t('attachment.flashes.created')
      else
        flash[:error] = t('attachment.flashes.create_error')
      end

      if !(@attachment.folder.nil?)
        redirect_to folder_path(@attachment.folder)
      else
        redirect_to folders_path
      end
    else
      redirect_to folders_path
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    if @attachment.destroy
      flash[:notice] = t('attachment.flashes.deleted')
    else
      flash[:error] = t('attachment.flashes.delete_error')
    end

    if !(@attachment.folder.nil?)
      redirect_to folder_path(@attachment.folder)
    else
      redirect_to folders_path
    end
  end
end
