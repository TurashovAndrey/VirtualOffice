class AttachmentsController < ApplicationController
  def index
    @attachment = Attachment.new
    @attachments = Attachment.find_all_by_company_id(current_user.company)
    @attachment.company = current_user.company
  end

  def create
    @attachment = Attachment.new(params[:attachment])
    @attachment.company = current_user.company
    @attachment.user = current_user
    if @attachment.save
      flash[:notice] = t('attachment.flashes.created')
    else
      flash[:error] = t('attachment.flashes.create_error')
    end
    redirect_to attachments_path
  end

  def delete
    @attachment = Attachment.find(params[:id])
    if @attachment.destroy
      flash[:notice] = t('attachment.flashes.deleted')
    else
      flash[:error] = t('attachment.flashes.delete_error')
    end
    redirect_to attachments_path
  end
end
